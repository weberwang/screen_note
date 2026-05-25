import 'package:drift/drift.dart';

import '../../domain/entities/task_event.dart';
import '../../domain/repositories/task_event_repository.dart';
import '../local/database/app_database.dart';
import '../local/database/daos/task_events_dao.dart';

/// 基于 Drift 的事项日志仓储实现。
final class DriftTaskEventRepository implements TaskEventRepository {
  /// 创建 Drift 事项日志仓储。
  DriftTaskEventRepository(this._taskEventsDao);

  final TaskEventsDao _taskEventsDao;

  @override
  Stream<List<TaskEvent>> watchByTaskId(String taskId) {
    return _taskEventsDao.watchByTaskId(taskId).map(_mapRows);
  }

  @override
  Future<List<TaskEvent>> findByTaskId(String taskId) async {
    final List<TaskEventRow> rows = await _taskEventsDao.findByTaskId(taskId);
    return _mapRows(rows);
  }

  @override
  Future<void> save(TaskEvent event) {
    return _taskEventsDao.insertOne(_toCompanion(event));
  }

  List<TaskEvent> _mapRows(List<TaskEventRow> rows) {
    return rows.map(_mapRow).toList(growable: false);
  }

  TaskEvent _mapRow(TaskEventRow row) {
    return TaskEvent(
      id: row.id,
      taskId: row.taskId,
      action: row.action,
      createdAt: row.createdAt,
      metadata: row.metadata,
    );
  }

  TaskEventsTableCompanion _toCompanion(TaskEvent event) {
    return TaskEventsTableCompanion(
      id: Value(event.id),
      taskId: Value(event.taskId),
      action: Value(event.action),
      createdAt: Value(event.createdAt),
      metadata: Value(event.metadata),
    );
  }
}
