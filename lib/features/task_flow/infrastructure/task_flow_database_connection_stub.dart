import 'package:drift/drift.dart';

/// 非原生平台暂不开放真实数据库，避免误接入不可用能力。
QueryExecutor openTaskFlowDatabaseConnection() {
  throw UnsupportedError('当前平台暂不支持 task-flow 原生数据库连接');
}
