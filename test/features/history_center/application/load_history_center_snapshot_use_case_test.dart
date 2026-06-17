import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:screen_note/features/history_center/application/use_cases/load_history_center_snapshot_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';

void main() {
  late TaskFlowDatabase database;
  late TaskFlowRepositoryImpl repository;
  late LoadHistoryCenterSnapshotUseCase useCase;

  setUp(() {
    database = TaskFlowDatabase.test(NativeDatabase.memory());
    repository = TaskFlowRepositoryImpl(database: database);
    useCase = LoadHistoryCenterSnapshotUseCase(repository: repository);
  });

  tearDown(() async {
    await database.close();
  });

  test('历史快照会按最近完成与最近删除分区倒序返回事项', () async {
    await repository.createTask(
      _task(
        id: 'completed-old',
        title: '旧完成事项',
        status: TaskStatus.completed,
        completedAt: DateTime(2026, 6, 14, 9),
        updatedAt: DateTime(2026, 6, 14, 9),
      ),
    );
    await repository.createTask(
      _task(
        id: 'completed-new',
        title: '新完成事项',
        status: TaskStatus.completed,
        completedAt: DateTime(2026, 6, 14, 12),
        updatedAt: DateTime(2026, 6, 14, 12),
      ),
    );
    await repository.createTask(
      _task(
        id: 'deleted-old',
        title: '旧删除事项',
        status: TaskStatus.deleted,
        deletedAt: DateTime(2026, 6, 14, 10),
        updatedAt: DateTime(2026, 6, 14, 10),
      ),
    );
    await repository.createTask(
      _task(
        id: 'deleted-new',
        title: '新删除事项',
        status: TaskStatus.deleted,
        deletedAt: DateTime(2026, 6, 14, 13),
        updatedAt: DateTime(2026, 6, 14, 13),
      ),
    );

    final snapshot = await useCase.execute();

    expect(
      snapshot.completedTasks.map((task) => task.id),
      <String>['completed-new', 'completed-old'],
    );
    expect(
      snapshot.deletedTasks.map((task) => task.id),
      <String>['deleted-new', 'deleted-old'],
    );
  });

  test('历史快照在没有完成和删除事项时会进入空态', () async {
    final snapshot = await useCase.execute();

    expect(snapshot.completedTasks, isEmpty);
    expect(snapshot.deletedTasks, isEmpty);
    expect(snapshot.isEmpty, isTrue);
  });
}

/// 统一构造测试事项，避免每条历史测试都重复样板字段。
TaskEntity _task({
  required String id,
  required String title,
  required TaskStatus status,
  required DateTime updatedAt,
  DateTime? completedAt,
  DateTime? deletedAt,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: '',
    dueAt: null,
    reminderAt: null,
    isPinned: false,
    isPrivate: false,
    status: status,
    reminderMode: TaskReminderMode.normal,
    createdAt: updatedAt.subtract(const Duration(hours: 1)),
    updatedAt: updatedAt,
    completedAt: completedAt,
    deletedAt: deletedAt,
  );
}
