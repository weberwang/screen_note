import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/task_events_table.dart';

part 'task_events_dao.g.dart';

/// 事项日志表数据访问对象。
@DriftAccessor(tables: [TaskEventsTable])
class TaskEventsDao extends DatabaseAccessor<AppDatabase>
    with _$TaskEventsDaoMixin {
  /// 创建事项日志 DAO。
  TaskEventsDao(super.attachedDatabase);

  /// 监听某个事项的全部日志。
  Stream<List<TaskEventRow>> watchByTaskId(String taskId) {
    final query = select(taskEventsTable)
      ..where((table) => table.taskId.equals(taskId));
    return query.watch();
  }

  /// 查询某个事项的全部日志。
  Future<List<TaskEventRow>> findByTaskId(String taskId) {
    final query = select(taskEventsTable)
      ..where((table) => table.taskId.equals(taskId));
    return query.get();
  }

  /// 追加一条事项日志。
  Future<void> insertOne(TaskEventsTableCompanion entry) async {
    await into(taskEventsTable).insert(entry);
  }
}
