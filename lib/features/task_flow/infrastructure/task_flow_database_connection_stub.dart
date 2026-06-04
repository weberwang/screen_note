import 'package:drift/drift.dart';

/// 默认兜底执行器；当前平台若未实现连接方式，则显式暴露能力缺口。
QueryExecutor openTaskFlowDatabaseConnection() {
  throw UnsupportedError('当前平台尚未配置 task-flow 数据库连接');
}
