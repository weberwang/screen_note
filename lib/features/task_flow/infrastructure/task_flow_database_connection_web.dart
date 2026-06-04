import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';

/// 打开 Web 数据库连接；当前仅作为 Web 端本地持久化的保守实现。
QueryExecutor openTaskFlowDatabaseConnection() {
  return WebDatabase('screen_note_task_flow');
}
