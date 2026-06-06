import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:screen_note/features/history_center/application/use_cases/load_history_snapshot_use_case.dart';
import 'package:screen_note/features/history_center/domain/entities/history_snapshot.dart';
import 'package:screen_note/features/task_flow/application/use_cases/update_task_status_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_noop_side_effect_port.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';

/// 验证 history-center 的历史读取会按最近完成和最近删除时间稳定倒序返回。
void main() {
  late TaskFlowDatabase database;
  late TaskFlowRepositoryImpl repository;
  late LoadHistorySnapshotUseCase loadHistorySnapshotUseCase;
  late UpdateTaskStatusUseCase updateTaskStatusUseCase;

  setUp(() {
    database = TaskFlowDatabase.test(NativeDatabase.memory());
    repository = TaskFlowRepositoryImpl(database: database);
    loadHistorySnapshotUseCase = LoadHistorySnapshotUseCase(
      repository: repository,
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

  test('execute 会按完成时间和删除时间倒序返回历史快照', () async {
    final DateTime now = DateTime.utc(2026, 6, 6, 10);
    await repository.createTask(
      _task(id: 'completed-early', title: '较早完成', createdAt: now),
    );
    await repository.createTask(
      _task(id: 'completed-late', title: '较晚完成', createdAt: now),
    );
    await repository.createTask(
      _task(id: 'deleted-early', title: '较早删除', createdAt: now),
    );
    await repository.createTask(
      _task(id: 'deleted-late', title: '较晚删除', createdAt: now),
    );

    await updateTaskStatusUseCase.completeTask(
      taskId: 'completed-early',
      occurredAt: now.add(const Duration(minutes: 10)),
    );
    await updateTaskStatusUseCase.completeTask(
      taskId: 'completed-late',
      occurredAt: now.add(const Duration(minutes: 30)),
    );
    await updateTaskStatusUseCase.deleteTask(
      taskId: 'deleted-early',
      occurredAt: now.add(const Duration(minutes: 20)),
    );
    await updateTaskStatusUseCase.deleteTask(
      taskId: 'deleted-late',
      occurredAt: now.add(const Duration(minutes: 40)),
    );

    final HistorySnapshot snapshot = await loadHistorySnapshotUseCase.execute();

    expect(
      snapshot.completedTasks.map((TaskEntity task) => task.id),
      <String>['completed-late', 'completed-early'],
    );
    expect(
      snapshot.deletedTasks.map((TaskEntity task) => task.id),
      <String>['deleted-late', 'deleted-early'],
    );
  });
}

/// 测试任务构造器，统一生成满足持久化约束的实体。
TaskEntity _task({
  required String id,
  required String title,
  required DateTime createdAt,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: '',
    dueAt: null,
    reminderAt: null,
    isPinned: false,
    isPrivate: false,
    status: TaskStatus.active,
    reminderMode: TaskReminderMode.normal,
    createdAt: createdAt,
    updatedAt: createdAt,
    completedAt: null,
    deletedAt: null,
  );
}
