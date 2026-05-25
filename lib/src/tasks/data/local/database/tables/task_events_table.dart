import 'package:drift/drift.dart';

import '../../../../domain/entities/task_event.dart';
import '../converters/json_map_converter.dart';
import 'tasks_table.dart';

/// 事项操作日志表。
@DataClassName('TaskEventRow')
@TableIndex(
  name: 'task_events_task_id_created_at_idx',
  columns: {#taskId, #createdAt},
)
@TableIndex(name: 'task_events_action_idx', columns: {#action})
class TaskEventsTable extends Table {
  /// 日志唯一标识。
  TextColumn get id => text()();

  /// 关联事项 ID。
  TextColumn get taskId => text().references(TasksTable, #id)();

  /// 操作类型。
  ///
  /// `expire` 只表示进入过期显示的记录，不代表事项被写成新的持久状态。
  TextColumn get action => textEnum<TaskEventAction>()();

  /// 日志创建时间。
  DateTimeColumn get createdAt => dateTime()();

  /// 额外上下文。
  TextColumn get metadata =>
      text().map(const JsonMapConverter()).withDefault(const Constant('{}'))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
