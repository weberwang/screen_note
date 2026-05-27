import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tasks_table.dart';

part 'tasks_dao.g.dart';

/// 事项表数据访问对象。
///
/// 这里只负责基础增删改查与监听，不在 DAO 中掺入排序、过期派生或状态机逻辑。
@DriftAccessor(tables: [TasksTable])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  /// 创建事项 DAO。
  TasksDao(super.attachedDatabase);

  /// 监听全部事项。
  Stream<List<TaskRow>> watchAll() {
    return select(tasksTable).watch();
  }

  /// 监听指定事项。
  Stream<TaskRow?> watchById(String id) {
    final query = select(tasksTable)..where((table) => table.id.equals(id));
    return query.watchSingleOrNull();
  }

  /// 查询全部事项。
  Future<List<TaskRow>> findAll() {
    return select(tasksTable).get();
  }

  /// 查询指定事项。
  Future<TaskRow?> findById(String id) {
    final query = select(tasksTable)..where((table) => table.id.equals(id));
    return query.getSingleOrNull();
  }

  /// 保存单个事项。
  Future<void> upsertOne(TasksTableCompanion entry) async {
    await into(tasksTable).insertOnConflictUpdate(entry);
  }

  /// 批量保存事项。
  Future<void> upsertMany(Iterable<TasksTableCompanion> entries) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(tasksTable, entries.toList());
    });
  }
}
