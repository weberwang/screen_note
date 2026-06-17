import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/load_task_feed_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/update_task_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/update_task_status_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_noop_side_effect_port.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';

void main() {
  late TaskFlowDatabase database;
  late TaskFlowRepositoryImpl repository;
  late CreateTaskUseCase createTaskUseCase;
  late LoadTaskFeedUseCase loadTaskFeedUseCase;
  late UpdateTaskUseCase updateTaskUseCase;
  late UpdateTaskStatusUseCase updateTaskStatusUseCase;

  setUp(() {
    database = TaskFlowDatabase.test(NativeDatabase.memory());
    repository = TaskFlowRepositoryImpl(database: database);
    createTaskUseCase = CreateTaskUseCase(
      repository: repository,
      sideEffectPort: const TaskFlowNoopSideEffectPort(),
      uuid: const Uuid(),
    );
    loadTaskFeedUseCase = LoadTaskFeedUseCase(repository: repository);
    updateTaskUseCase = UpdateTaskUseCase(
      repository: repository,
      uuid: const Uuid(),
    );
    updateTaskStatusUseCase = UpdateTaskStatusUseCase(
      repository: repository,
      sideEffectPort: const TaskFlowNoopSideEffectPort(),
      uuid: const Uuid(),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('createTask 会拒绝空白标题', () async {
    await expectLater(
      createTaskUseCase.execute(const CreateTaskInput(title: '   ', note: '')),
      throwsArgumentError,
    );
  });

  test('createTask 成功后事件表会落库 created 事件', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);

    final TaskEntity createdTask = await createTaskUseCase.execute(
      const CreateTaskInput(title: '验证创建事件', note: ''),
      now: now,
    );

    final List<TaskEventRecord> events = await _loadEventsForTask(
      database,
      createdTask.id,
    );

    expect(events, hasLength(1));
    expect(events.single.type, 'created');
    expect(events.single.fromStatus, TaskStatus.active);
    expect(events.single.toStatus, TaskStatus.active);
    expect(events.single.occurredAtEpochMs, now.millisecondsSinceEpoch);
  });

  test('updateTask 会保住原事项身份并写入 edited 事件', () async {
    final DateTime createdAt = DateTime(2026, 6, 4, 10);
    await repository.createTask(
      _buildTask(id: 'task-1', title: '原始标题', createdAt: createdAt),
    );

    final TaskEntity updatedTask = await updateTaskUseCase.execute(
      const UpdateTaskInput(
        taskId: 'task-1',
        title: '更新后的标题',
        note: '更新后的备注',
        isPinned: true,
        isPrivate: true,
      ),
      now: createdAt.add(const Duration(minutes: 30)),
    );

    final List<TaskEntity> activeTasks = await repository.loadTasksByStatus(
      TaskStatus.active,
    );
    final List<TaskEventRecord> events = await _loadEventsForTask(
      database,
      'task-1',
    );

    expect(updatedTask.id, 'task-1');
    expect(activeTasks, hasLength(1));
    expect(activeTasks.single.title, '更新后的标题');
    expect(activeTasks.single.note, '更新后的备注');
    expect(activeTasks.single.isPinned, isTrue);
    expect(activeTasks.single.isPrivate, isTrue);
    expect(events.single.type, 'edited');
    expect(events.single.fromStatus, TaskStatus.active);
    expect(events.single.toStatus, TaskStatus.active);
  });

  test('loadTaskFeed 会按主事项、过期、今日、普通顺序返回 active 事项', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);
    await repository.createTask(
      _buildTask(id: 'normal', title: '普通事项', createdAt: now),
    );
    await repository.createTask(
      _buildTask(
        id: 'today',
        title: '今天事项',
        dueAt: DateTime(2026, 6, 4, 18),
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
    );
    await repository.createTask(
      _buildTask(
        id: 'overdue',
        title: '过期事项',
        dueAt: DateTime(2026, 6, 3, 18),
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    );
    await repository.createTask(
      _buildTask(id: 'pinned', title: '主事项', isPinned: true, createdAt: now),
    );

    final TaskFeedSnapshot snapshot = await loadTaskFeedUseCase.execute(
      now: now,
    );

    expect(snapshot.pinnedTasks.map((TaskEntity task) => task.id), <String>[
      'pinned',
    ]);
    expect(snapshot.overdueTasks.map((TaskEntity task) => task.id), <String>[
      'overdue',
    ]);
    expect(snapshot.todayTasks.map((TaskEntity task) => task.id), <String>[
      'today',
    ]);
    expect(snapshot.otherTasks.map((TaskEntity task) => task.id), <String>[
      'normal',
    ]);
    expect(snapshot.activeCount, 4);
  });

  test('complete delete restore 只通过 active completed deleted 三态流转', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);
    await repository.createTask(
      _buildTask(id: 'task-1', title: '恢复链路', createdAt: now),
    );

    await updateTaskStatusUseCase.completeTask(
      taskId: 'task-1',
      occurredAt: now.add(const Duration(minutes: 5)),
    );
    await updateTaskStatusUseCase.deleteTask(
      taskId: 'task-1',
      occurredAt: now.add(const Duration(minutes: 10)),
    );
    await updateTaskStatusUseCase.restoreTask(
      taskId: 'task-1',
      occurredAt: now.add(const Duration(minutes: 15)),
    );

    final TaskEntity? restored = await repository.findTaskById('task-1');
    expect(restored, isNotNull);
    expect(restored?.status, TaskStatus.active);
    expect(restored?.completedAt, isNull);
    expect(restored?.deletedAt, isNull);
  });

  test('complete delete restore 后事件表会记录正确的 fromStatus 与 toStatus', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);
    await repository.createTask(
      _buildTask(id: 'task-events', title: '事件链路', createdAt: now),
    );

    await updateTaskStatusUseCase.completeTask(
      taskId: 'task-events',
      occurredAt: now.add(const Duration(minutes: 5)),
    );
    await updateTaskStatusUseCase.deleteTask(
      taskId: 'task-events',
      occurredAt: now.add(const Duration(minutes: 10)),
    );
    await updateTaskStatusUseCase.restoreTask(
      taskId: 'task-events',
      occurredAt: now.add(const Duration(minutes: 15)),
    );

    final List<TaskEventRecord> events = await _loadEventsForTask(
      database,
      'task-events',
    );

    expect(events, hasLength(3));
    expect(events[0].type, 'completed');
    expect(events[0].fromStatus, TaskStatus.active);
    expect(events[0].toStatus, TaskStatus.completed);
    expect(events[1].type, 'deleted');
    expect(events[1].fromStatus, TaskStatus.completed);
    expect(events[1].toStatus, TaskStatus.deleted);
    expect(events[2].type, 'restored');
    expect(events[2].fromStatus, TaskStatus.deleted);
    expect(events[2].toStatus, TaskStatus.active);
  });

  test('deleted 事项不能直接 complete', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);
    await repository.createTask(
      _buildTask(
        id: 'deleted-task',
        title: '已删除事项',
        createdAt: now,
        status: TaskStatus.deleted,
        deletedAt: now,
      ),
    );

    await expectLater(
      updateTaskStatusUseCase.completeTask(
        taskId: 'deleted-task',
        occurredAt: now.add(const Duration(minutes: 1)),
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('completed 事项不能直接 restore', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);
    await repository.createTask(
      _buildTask(
        id: 'completed-task',
        title: '已完成事项',
        createdAt: now,
        status: TaskStatus.completed,
        completedAt: now,
      ),
    );

    await expectLater(
      updateTaskStatusUseCase.restoreTask(
        taskId: 'completed-task',
        occurredAt: now.add(const Duration(minutes: 1)),
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('active 事项不能直接 restore', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);
    await repository.createTask(
      _buildTask(id: 'active-task', title: '进行中事项', createdAt: now),
    );

    final int eventCountBefore = await _countEvents(database);

    await expectLater(
      updateTaskStatusUseCase.restoreTask(
        taskId: 'active-task',
        occurredAt: now.add(const Duration(minutes: 1)),
      ),
      throwsA(isA<StateError>()),
    );

    final TaskEntity? unchangedTask = await repository.findTaskById(
      'active-task',
    );
    final int eventCountAfter = await _countEvents(database);

    expect(unchangedTask?.status, TaskStatus.active);
    expect(unchangedTask?.updatedAt, now);
    expect(unchangedTask?.completedAt, isNull);
    expect(unchangedTask?.deletedAt, isNull);
    expect(eventCountAfter, eventCountBefore);
  });

  test('createTaskWithEvent 在事件插入失败时会整体回滚', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);
    await database
        .into(database.taskEventRecords)
        .insert(
          TaskEventRecordsCompanion.insert(
            id: 'duplicate-event',
            taskId: 'seed-task',
            type: 'seed',
            fromStatus: TaskStatus.active,
            toStatus: TaskStatus.active,
            occurredAtEpochMs: now.millisecondsSinceEpoch,
          ),
        );

    await expectLater(
      repository.createTaskWithEvent(
        task: _buildTask(id: 'atomic-task', title: '事务回滚', createdAt: now),
        event: TaskEventEntity(
          id: 'duplicate-event',
          taskId: 'atomic-task',
          type: 'created',
          fromStatus: TaskStatus.active,
          toStatus: TaskStatus.active,
          occurredAt: now,
        ),
      ),
      throwsA(isA<Exception>()),
    );

    final TaskEntity? rolledBackTask = await repository.findTaskById(
      'atomic-task',
    );
    final int duplicateEventCount = await _countEventsById(
      database,
      'duplicate-event',
    );

    expect(rolledBackTask, isNull);
    expect(duplicateEventCount, 1);
  });
}

/// 构造测试事项，确保测试输入与正式实体结构保持一致。
TaskEntity _buildTask({
  required String id,
  required String title,
  required DateTime createdAt,
  DateTime? dueAt,
  bool isPinned = false,
  TaskStatus status = TaskStatus.active,
  DateTime? completedAt,
  DateTime? deletedAt,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: '',
    dueAt: dueAt,
    reminderAt: null,
    isPinned: isPinned,
    isPrivate: false,
    status: status,
    reminderMode: TaskReminderMode.normal,
    createdAt: createdAt,
    updatedAt: createdAt,
    completedAt: completedAt,
    deletedAt: deletedAt,
  );
}

/// 按任务读取事件流，确保状态事件断言直接面向真实落库结果。
Future<List<TaskEventRecord>> _loadEventsForTask(
  TaskFlowDatabase database,
  String taskId,
) {
  return (database.select(database.taskEventRecords)
        ..where((TaskEventRecords table) => table.taskId.equals(taskId))
        ..orderBy(<drift.OrderingTerm Function(TaskEventRecords)>[
          (TaskEventRecords table) =>
              drift.OrderingTerm.asc(table.occurredAtEpochMs),
        ]))
      .get();
}

/// 统计全部事件数量，用于证明非法流转没有写入脏日志。
Future<int> _countEvents(TaskFlowDatabase database) async {
  final drift.Expression<int> countExpression = database.taskEventRecords.id
      .count();
  final drift.TypedResult result = await (database.selectOnly(
    database.taskEventRecords,
  )..addColumns(<drift.Expression<Object>>[countExpression])).getSingle();
  return result.read(countExpression) ?? 0;
}

/// 统计指定事件 ID 的条数，用于验证事务失败后没有留下半写入结果。
Future<int> _countEventsById(TaskFlowDatabase database, String eventId) async {
  final drift.Expression<int> countExpression = database.taskEventRecords.id
      .count();
  final drift.TypedResult result =
      await (database.selectOnly(database.taskEventRecords)
            ..addColumns(<drift.Expression<Object>>[countExpression])
            ..where(database.taskEventRecords.id.equals(eventId)))
          .getSingle();
  return result.read(countExpression) ?? 0;
}
