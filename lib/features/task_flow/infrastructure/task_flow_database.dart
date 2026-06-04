import 'package:drift/drift.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database_connection.dart';

part 'task_flow_database.g.dart';

/// 事项主表，承载主链路事实与可恢复状态。
class TaskRecords extends Table {
  /// 事项主键。
  TextColumn get id => text()();

  /// 标题。
  TextColumn get title => text()();

  /// 备注。
  TextColumn get note => text().withDefault(const Constant(''))();

  /// 截止时间 UTC 毫秒。
  IntColumn get dueAtEpochMs => integer().nullable()();

  /// 提醒时间 UTC 毫秒。
  IntColumn get reminderAtEpochMs => integer().nullable()();

  /// 是否置顶。
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  /// 是否隐私事项。
  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();

  /// 持久状态。
  TextColumn get status => textEnum<TaskStatus>()();

  /// 提醒模式。
  TextColumn get reminderMode => textEnum<TaskReminderMode>()();

  /// 创建时间 UTC 毫秒。
  IntColumn get createdAtEpochMs => integer()();

  /// 更新时间 UTC 毫秒。
  IntColumn get updatedAtEpochMs => integer()();

  /// 完成时间 UTC 毫秒。
  IntColumn get completedAtEpochMs => integer().nullable()();

  /// 删除时间 UTC 毫秒。
  IntColumn get deletedAtEpochMs => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// 事项事件表，保证关键状态流转具备审计能力。
class TaskEventRecords extends Table {
  /// 事件主键。
  TextColumn get id => text()();

  /// 关联事项主键。
  TextColumn get taskId => text()();

  /// 事件类型。
  TextColumn get type => text()();

  /// 发生时间 UTC 毫秒。
  IntColumn get occurredAtEpochMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// task-flow 本地数据库，统一收口事项事实和事件日志。
@DriftDatabase(tables: <Type>[TaskRecords, TaskEventRecords])
class TaskFlowDatabase extends _$TaskFlowDatabase {
  /// 创建正式数据库实例。
  TaskFlowDatabase() : super(openTaskFlowDatabaseConnection());

  /// 创建测试数据库实例。
  TaskFlowDatabase.test(super.executor);

  @override
  int get schemaVersion => 1;
}
