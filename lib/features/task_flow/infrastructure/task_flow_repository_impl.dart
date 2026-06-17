import 'package:drift/drift.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';

/// `drift` 仓储实现，统一维护事项真源与操作日志的本地落库。
final class TaskFlowRepositoryImpl implements TaskMutationRepository {
  /// 创建 `task-flow` 仓储实现。
  const TaskFlowRepositoryImpl({required TaskFlowDatabase database})
    : _database = database;

  final TaskFlowDatabase _database;

  @override
  Future<void> createTask(TaskEntity task) async {
    await _insertTask(task);
  }

  @override
  Future<void> createTaskWithEvent({
    required TaskEntity task,
    required TaskEventEntity event,
  }) async {
    await _database.transaction(() async {
      await _insertTask(task);
      await _insertEvent(event);
    });
  }

  @override
  Future<void> updateTaskWithEvent({
    required TaskEntity task,
    required TaskEventEntity event,
  }) async {
    await _database.transaction(() async {
      await _insertTask(task);
      await _insertEvent(event);
    });
  }

  @override
  Future<TaskEntity?> findTaskById(String id) async {
    final TaskRecord? row = await (_database.select(
      _database.taskRecords,
    )..where((TaskRecords table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapTaskRowToEntity(row);
  }

  @override
  Future<List<TaskEntity>> loadTasksByStatus(TaskStatus status) async {
    final List<TaskRecord> rows =
        await (_database.select(_database.taskRecords)
              ..where((TaskRecords table) => table.status.equals(status.name))
              ..orderBy(<OrderingTerm Function(TaskRecords)>[
                (TaskRecords table) =>
                    OrderingTerm.desc(table.updatedAtEpochMs),
                (TaskRecords table) =>
                    OrderingTerm.desc(table.createdAtEpochMs),
              ]))
            .get();
    return rows.map(_mapTaskRowToEntity).toList(growable: false);
  }

  @override
  Future<int> countTasksByStatus(TaskStatus status) async {
    final Expression<int> countExpression = _database.taskRecords.id.count();
    final TypedResult result =
        await (_database.selectOnly(_database.taskRecords)
              ..addColumns(<Expression<Object>>[countExpression])
              ..where(_database.taskRecords.status.equals(status.name)))
            .getSingle();
    return result.read(countExpression) ?? 0;
  }

  /// 统一事项写入路径，供事务和测试预置共用，避免 SQL 分散。
  Future<void> _insertTask(TaskEntity task) async {
    await _database
        .into(_database.taskRecords)
        .insert(
          _mapTaskEntityToCompanion(task),
          mode: InsertMode.insertOrReplace,
        );
  }

  /// 统一事件写入路径，重复事件 ID 必须显式失败，才能触发事务回滚。
  Future<void> _insertEvent(TaskEventEntity event) async {
    await _database
        .into(_database.taskEventRecords)
        .insert(
          TaskEventRecordsCompanion.insert(
            id: event.id,
            taskId: event.taskId,
            type: event.type,
            fromStatus: event.fromStatus,
            toStatus: event.toStatus,
            occurredAtEpochMs: event.occurredAt.millisecondsSinceEpoch,
          ),
        );
  }

  /// 把领域实体映射成持久化 companion，避免表结构泄露给应用层。
  TaskRecordsCompanion _mapTaskEntityToCompanion(TaskEntity task) {
    return TaskRecordsCompanion.insert(
      id: task.id,
      title: task.title,
      note: Value<String>(task.note),
      dueAtEpochMs: Value<int?>(task.dueAt?.millisecondsSinceEpoch),
      reminderAtEpochMs: Value<int?>(task.reminderAt?.millisecondsSinceEpoch),
      isPinned: Value<bool>(task.isPinned),
      isPrivate: Value<bool>(task.isPrivate),
      status: task.status,
      reminderMode: task.reminderMode,
      createdAtEpochMs: task.createdAt.millisecondsSinceEpoch,
      updatedAtEpochMs: task.updatedAt.millisecondsSinceEpoch,
      completedAtEpochMs: Value<int?>(task.completedAt?.millisecondsSinceEpoch),
      deletedAtEpochMs: Value<int?>(task.deletedAt?.millisecondsSinceEpoch),
    );
  }

  /// 从数据库行恢复领域实体，确保页面层永远只看到内部模型。
  TaskEntity _mapTaskRowToEntity(TaskRecord row) {
    return TaskEntity(
      id: row.id,
      title: row.title,
      note: row.note,
      dueAt: _fromEpochMs(row.dueAtEpochMs),
      reminderAt: _fromEpochMs(row.reminderAtEpochMs),
      isPinned: row.isPinned,
      isPrivate: row.isPrivate,
      status: row.status,
      reminderMode: row.reminderMode,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAtEpochMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAtEpochMs),
      completedAt: _fromEpochMs(row.completedAtEpochMs),
      deletedAt: _fromEpochMs(row.deletedAtEpochMs),
    );
  }

  /// 数据库存的是毫秒戳，这里集中做时间恢复，避免映射散落。
  DateTime? _fromEpochMs(int? epochMs) {
    if (epochMs == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(epochMs);
  }
}
