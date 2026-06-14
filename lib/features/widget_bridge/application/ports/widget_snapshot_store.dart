import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';

/// Widget 快照存储端口，统一隔离 App Group、插件刷新和平台差异。
abstract interface class WidgetSnapshotStore {
  /// 保存当前稳定快照；失败时只能降级，不能阻断事项与设置主链路。
  Future<bool> saveSnapshot(WidgetSnapshot snapshot);
}
