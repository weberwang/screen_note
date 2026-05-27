import 'package:drift/drift.dart';

import '../../../../domain/entities/task.dart';

/// 事项持久化表。
@DataClassName('TaskRow')
@TableIndex(name: 'tasks_status_updated_at_idx', columns: {#status, #updatedAt})
@TableIndex(name: 'tasks_due_at_idx', columns: {#dueAt})
@TableIndex(name: 'tasks_deleted_at_idx', columns: {#deletedAt})
class TasksTable extends Table {
  /// 事项唯一标识。
  TextColumn get id => text()();

  /// 事项标题。
  TextColumn get title => text()();

  /// 事项备注。
  TextColumn get note => text().nullable()();

  /// 持久状态。
  ///
  /// 这里只允许三种稳定状态，过期展示通过 `dueAt` 在上层派生，不单独落库。
  TextColumn get status => textEnum<TaskStatus>()();

  /// 截止或提醒时间。
  DateTimeColumn get dueAt => dateTime().nullable()();

  /// 是否置顶。
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  /// 是否隐私事项。
  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();

  /// 提醒模式。
  TextColumn get reminderMode => textEnum<TaskReminderMode>()();

  /// 创建时间。
  DateTimeColumn get createdAt => dateTime()();

  /// 更新时间。
  DateTimeColumn get updatedAt => dateTime()();

  /// 完成时间。
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// 软删除时间。
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
