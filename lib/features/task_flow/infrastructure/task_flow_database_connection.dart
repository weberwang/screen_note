import 'package:drift/drift.dart';

import 'package:screen_note/features/task_flow/infrastructure/task_flow_database_connection_stub.dart'
    if (dart.library.io)
      'package:screen_note/features/task_flow/infrastructure/task_flow_database_connection_native.dart'
    if (dart.library.html)
      'package:screen_note/features/task_flow/infrastructure/task_flow_database_connection_web.dart'
    as connection;

/// 打开 task-flow 数据库连接，按平台选择合适的 Drift 执行器。
QueryExecutor openTaskFlowDatabaseConnection() {
  return connection.openTaskFlowDatabaseConnection();
}
