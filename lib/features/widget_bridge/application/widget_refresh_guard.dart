import 'dart:developer';

import 'widget_snapshot_refresher.dart';

/// 执行非阻塞 Widget 刷新。
///
/// 事项主链路已经完成数据库写入和日志落库后，Widget 刷新只能作为能力增强；
/// 这里统一吞掉刷新异常，只留下可排查日志，避免调用方各自复制 try/catch。
Future<void> runNonBlockingWidgetRefresh({
  required WidgetSnapshotRefresher refresher,
  required String actionName,
}) async {
  try {
    await refresher.refresh();
  } catch (error, stackTrace) {
    log(
      'Widget refresh failed after $actionName, degrade to non-blocking.',
      name: 'WidgetRefreshGuard',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
