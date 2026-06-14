import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';

/// 非原生平台降级存储，明确说明当前环境不支持真实 Widget 同步。
final class UnsupportedWidgetSnapshotStore implements WidgetSnapshotStore {
  /// 创建降级存储。
  const UnsupportedWidgetSnapshotStore({required AppLogger logger})
    : _logger = logger;

  final AppLogger _logger;

  @override
  Future<bool> saveSnapshot(WidgetSnapshot snapshot) async {
    _logger.warning('widget_snapshot_store_unsupported_platform');
    return false;
  }
}

/// 创建降级存储实例。
WidgetSnapshotStore createWidgetSnapshotStore({required AppLogger logger}) {
  return UnsupportedWidgetSnapshotStore(logger: logger);
}
