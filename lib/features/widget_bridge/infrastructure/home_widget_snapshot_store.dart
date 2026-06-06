import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';

import 'home_widget_snapshot_store_stub.dart'
    if (dart.library.io) 'home_widget_snapshot_store_io.dart' as implementation;

/// 创建小组件快照存储实现；非原生平台自动退回降级存储，保证主链路不被插件能力阻断。
WidgetSnapshotStore createWidgetSnapshotStore({required AppLogger logger}) {
  return implementation.createWidgetSnapshotStore(logger: logger);
}
