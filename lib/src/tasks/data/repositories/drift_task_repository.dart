import 'package:drift/drift.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../local/database/app_database.dart';
import '../local/database/daos/tasks_dao.dart';

/// 基于 Drift 的事项仓储实现。
final class DriftTaskRepository implements TaskRepository {
  /// 创建 Drift 事项仓储。
  DriftTaskRepository(this._tasksDao);

  final TasksDao _tasksDao;

  @override
  Stream<List<Task>> watchAll() {
    return _tasksDao.watchAll().map(_mapRows);
  }

  @override
  Stream<Task?> watchById(String id) {
    return _tasksDao.watchById(id).map(_mapRowNullable);
  }

  @override
  Future<Task?> findById(String id) async {
    final TaskRow? row = await _tasksDao.findById(id);
    return _mapRowNullable(row);
  }

  @override
  Future<List<Task>> findAll() async {
    final List<TaskRow> rows = await _tasksDao.findAll();
    return _mapRows(rows);
  }

  @override
  Future<void> save(Task task) {
    return _tasksDao.upsertOne(_toCompanion(task));
  }

  @override
  Future<void> saveAll(Iterable<Task> tasks) {
    return _tasksDao.upsertMany(tasks.map(_toCompanion));
  }

  List<Task> _mapRows(List<TaskRow> rows) {
    return rows.map(_mapRow).toList(growable: false);
  }

  Task? _mapRowNullable(TaskRow? row) {
    if (row == null) {
      return null;
    }

    return _mapRow(row);
  }

  Task _mapRow(TaskRow row) {
    return Task(
      id: row.id,
      title: row.title,
      note: row.note,
      status: row.status,
      dueAt: row.dueAt,
      isPinned: row.isPinned,
      isPrivate: row.isPrivate,
      reminderMode: row.reminderMode,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      completedAt: row.completedAt,
      deletedAt: row.deletedAt,
    );
  }

  TasksTableCompanion _toCompanion(Task task) {
    return TasksTableCompanion(
      id: Value(task.id),
      title: Value(task.title),
      note: Value(task.note),
      status: Value(task.status),
      dueAt: Value(task.dueAt),
      isPinned: Value(task.isPinned),
      isPrivate: Value(task.isPrivate),
      reminderMode: Value(task.reminderMode),
      createdAt: Value(task.createdAt),
      updatedAt: Value(task.updatedAt),
      completedAt: Value(task.completedAt),
      deletedAt: Value(task.deletedAt),
    );
  }
}
