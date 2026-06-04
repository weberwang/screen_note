import 'package:drift/drift.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';

/// Drift 版事项仓储实现，统一屏蔽表结构与领域实体之间的映射。
final class TaskFlowRepositoryImpl implements TaskRepository {
  /// 创建 Drift 仓储。
  const TaskFlowRepositoryImpl({required TaskFlowDatabase database})
    : _database = database;

  final TaskFlowDatabase _database;

  @override
  Future<void> createTask(TaskEntity task) async {
    await _database.into(_database.taskRecords).insert(_toCompanion(task));
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await (_database.update(
      _database.taskRecords,
    )..where((table) => table.id.equals(task.id))).write(
      _toCompanion(task),
    );
  }

  @override
  Future<TaskEntity?> findTaskById(String id) async {
    final TaskRecord? record =
        await (_database.select(_database.taskRecords)
              ..where((table) => table.id.equals(id)))
            .getSingleOrNull();
    return record == null ? null : _toEntity(record);
  }

  @override
  Future<List<TaskEntity>> loadTasksByStatus(TaskStatus status) async {
    // 当前 MVP 数据量较小，先统一拉取后按领域状态过滤，避免把枚举转换细节散落在查询层。
    final List<TaskRecord> records =
        await (_database.select(_database.taskRecords)
              ..orderBy(<OrderingTerm Function($TaskRecordsTable)>[
                (table) => OrderingTerm.desc(table.updatedAtEpochMs),
              ]))
            .get();
    return records
        .where((TaskRecord record) => record.status == status)
        .map(_toEntity)
        .toList(growable: false);
  }

  @override
  Future<int> countTasksByStatus(TaskStatus status) async {
    final List<TaskRecord> records = await _database
        .select(_database.taskRecords)
        .get();
    return records.where((TaskRecord record) => record.status == status).length;
  }

  @override
  Future<void> appendEvent(TaskEventEntity event) async {
    await _database.into(_database.taskEventRecords).insert(
      TaskEventRecordsCompanion.insert(
        id: event.id,
        taskId: event.taskId,
        type: event.type.name,
        occurredAtEpochMs: event.occurredAt.toUtc().millisecondsSinceEpoch,
      ),
    );
  }

  TaskEntity _toEntity(TaskRecord record) {
    return TaskEntity(
      id: record.id,
      title: record.title,
      note: record.note,
      dueAt: _fromEpochMs(record.dueAtEpochMs),
      reminderAt: _fromEpochMs(record.reminderAtEpochMs),
      isPinned: record.isPinned,
      isPrivate: record.isPrivate,
      status: record.status,
      reminderMode: record.reminderMode,
      createdAt: _fromEpochMs(record.createdAtEpochMs)!,
      updatedAt: _fromEpochMs(record.updatedAtEpochMs)!,
      completedAt: _fromEpochMs(record.completedAtEpochMs),
      deletedAt: _fromEpochMs(record.deletedAtEpochMs),
    );
  }

  TaskRecordsCompanion _toCompanion(TaskEntity task) {
    return TaskRecordsCompanion(
      id: Value(task.id),
      title: Value(task.title),
      note: Value(task.note),
      dueAtEpochMs: Value(task.dueAt?.toUtc().millisecondsSinceEpoch),
      reminderAtEpochMs: Value(task.reminderAt?.toUtc().millisecondsSinceEpoch),
      isPinned: Value(task.isPinned),
      isPrivate: Value(task.isPrivate),
      status: Value(task.status),
      reminderMode: Value(task.reminderMode),
      createdAtEpochMs: Value(task.createdAt.toUtc().millisecondsSinceEpoch),
      updatedAtEpochMs: Value(task.updatedAt.toUtc().millisecondsSinceEpoch),
      completedAtEpochMs: Value(
        task.completedAt?.toUtc().millisecondsSinceEpoch,
      ),
      deletedAtEpochMs: Value(task.deletedAt?.toUtc().millisecondsSinceEpoch),
    );
  }

  DateTime? _fromEpochMs(int? value) {
    if (value == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }
}
