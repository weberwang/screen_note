import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/load_task_feed_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/update_task_status_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_noop_side_effect_port.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';

/// 验证 task-flow 的最小正式主链路：创建、排序、完成与软删除。
void main() {
  late TaskFlowDatabase database;
  late TaskFlowRepositoryImpl repository;
  late CreateTaskUseCase createTaskUseCase;
  late LoadTaskFeedUseCase loadTaskFeedUseCase;
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
    updateTaskStatusUseCase = UpdateTaskStatusUseCase(
      repository: repository,
      sideEffectPort: const TaskFlowNoopSideEffectPort(),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('createTask 会拒绝空白标题', () async {
    expect(
      () => createTaskUseCase.execute(
        const CreateTaskInput(title: '   ', note: ''),
      ),
      throwsArgumentError,
    );
  });

  test('loadTaskFeed 会按置顶、过期、今日、普通顺序返回 active 事项', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);
    await repository.createTask(
      _task(
        id: 'normal',
        title: '普通事项',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    );
    await repository.createTask(
      _task(
        id: 'today',
        title: '今天事项',
        dueAt: DateTime(2026, 6, 4, 18),
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
    );
    await repository.createTask(
      _task(
        id: 'overdue',
        title: '过期事项',
        dueAt: DateTime(2026, 6, 3, 18),
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    );
    await repository.createTask(
      _task(
        id: 'pinned',
        title: '置顶事项',
        isPinned: true,
        createdAt: now,
      ),
    );

    final TaskFeedSnapshot snapshot = await loadTaskFeedUseCase.execute(now: now);

    expect(snapshot.pinnedTasks.map((task) => task.id), <String>['pinned']);
    expect(snapshot.overdueTasks.map((task) => task.id), <String>['overdue']);
    expect(snapshot.todayTasks.map((task) => task.id), <String>['today']);
    expect(snapshot.otherTasks.map((task) => task.id), <String>['normal']);
    expect(snapshot.activeCount, 4);
  });

  test('completeTask 和 deleteTask 只改变持久状态并刷新计数', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);
    await repository.createTask(
      _task(id: 'complete-me', title: '完成它', createdAt: now),
    );
    await repository.createTask(
      _task(id: 'delete-me', title: '删除它', createdAt: now),
    );

    await updateTaskStatusUseCase.completeTask(
      taskId: 'complete-me',
      occurredAt: now.add(const Duration(minutes: 10)),
    );
    await updateTaskStatusUseCase.deleteTask(
      taskId: 'delete-me',
      occurredAt: now.add(const Duration(minutes: 20)),
    );

    final TaskFeedSnapshot snapshot = await loadTaskFeedUseCase.execute(now: now);
    final TaskEntity? completed = await repository.findTaskById('complete-me');
    final TaskEntity? deleted = await repository.findTaskById('delete-me');

    expect(snapshot.activeCount, 0);
    expect(snapshot.completedCount, 1);
    expect(snapshot.deletedCount, 1);
    expect(completed?.status, TaskStatus.completed);
    expect(deleted?.status, TaskStatus.deleted);
  });
}

/// 测试任务构造器，统一生成符合持久化约束的实体。
TaskEntity _task({
  required String id,
  required String title,
  required DateTime createdAt,
  DateTime? dueAt,
  bool isPinned = false,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: '',
    dueAt: dueAt,
    reminderAt: null,
    isPinned: isPinned,
    isPrivate: false,
    status: TaskStatus.active,
    reminderMode: TaskReminderMode.normal,
    createdAt: createdAt,
    updatedAt: createdAt,
    completedAt: null,
    deletedAt: null,
  );
}
