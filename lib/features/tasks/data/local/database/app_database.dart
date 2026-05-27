import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../domain/entities/task.dart';
import '../../../domain/entities/task_event.dart';
import 'converters/json_map_converter.dart';
import 'daos/task_events_dao.dart';
import 'daos/tasks_dao.dart';
import 'tables/task_events_table.dart';
import 'tables/tasks_table.dart';

part 'app_database.g.dart';

/// 事项模块本地数据库。
///
/// 阶段一只负责提供 Task / TaskEvent 的持久化骨架，
/// 排序、过期派生和状态流转仍然停留在应用层。
@DriftDatabase(
  tables: <Type>[TasksTable, TaskEventsTable],
  daos: <Type>[TasksDao, TaskEventsDao],
)
class AppDatabase extends _$AppDatabase {
  /// 使用默认文件连接创建数据库。
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// 使用外部执行器创建数据库。
  ///
  /// 这个命名构造主要服务测试场景，避免仓储测试依赖真实文件系统。
  AppDatabase.forExecutor(super.executor) : super();

  /// 当前数据库 schema 版本。
  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final Directory directory = await getApplicationSupportDirectory();
      final File databaseFile = File(
        path.join(directory.path, 'screen_note.sqlite'),
      );
      return NativeDatabase(databaseFile);
    });
  }
}
