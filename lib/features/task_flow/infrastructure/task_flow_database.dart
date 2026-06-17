import 'package:drift/drift.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database_connection.dart';

part 'task_flow_database.g.dart';

/// 事项主表，保存任务真源事实，不在持久层引入 `expired` 第四态。
class TaskRecords extends Table {
  /// 事项 ID。
  TextColumn get id => text()();

  /// 标题。
  TextColumn get title => text()();

  /// 备注。
  TextColumn get note => text().withDefault(const Constant(''))();

  /// 到期时间毫秒戳。
  IntColumn get dueAtEpochMs => integer().nullable()();

  /// 提醒时间毫秒戳。
  IntColumn get reminderAtEpochMs => integer().nullable()();

  /// 是否置顶。
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  /// 是否私密。
  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();

  /// 持久状态。
  TextColumn get status => textEnum<TaskStatus>()();

  /// 提醒模式。
  TextColumn get reminderMode => textEnum<TaskReminderMode>()();

  /// 创建时间毫秒戳。
  IntColumn get createdAtEpochMs => integer()();

  /// 更新时间毫秒戳。
  IntColumn get updatedAtEpochMs => integer()();

  /// 完成时间毫秒戳。
  IntColumn get completedAtEpochMs => integer().nullable()();

  /// 删除时间毫秒戳。
  IntColumn get deletedAtEpochMs => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// 事项事件表，记录关键状态变化，避免后续历史中心缺失真相来源。
class TaskEventRecords extends Table {
  /// 事件 ID。
  TextColumn get id => text()();

  /// 关联事项 ID。
  TextColumn get taskId => text()();

  /// 事件类型。
  TextColumn get type => text()();

  /// 变化前状态。
  TextColumn get fromStatus => textEnum<TaskStatus>()();

  /// 变化后状态。
  TextColumn get toStatus => textEnum<TaskStatus>()();

  /// 发生时间毫秒戳。
  IntColumn get occurredAtEpochMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// `task-flow` drift 数据库入口。
@DriftDatabase(tables: <Type>[TaskRecords, TaskEventRecords])
class TaskFlowDatabase extends _$TaskFlowDatabase {
  /// 创建数据库；未显式传入执行器时使用平台默认连接。
  TaskFlowDatabase([QueryExecutor? executor])
    : super(executor ?? openTaskFlowDatabaseConnection());

  /// 创建测试数据库，避免测试写入真实本地文件。
  TaskFlowDatabase.test(super.executor);

  @override
  int get schemaVersion => 1;
}
