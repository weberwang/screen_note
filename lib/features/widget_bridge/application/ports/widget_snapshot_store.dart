import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';

/// 小组件快照存储端口，统一隔离 App Group、HomeWidget 和刷新触发细节。
abstract interface class WidgetSnapshotStore {
  /// 保存当前稳定快照；失败时只能降级为保留最后一次有效内容。
  Future<bool> saveSnapshot(WidgetSnapshot snapshot);
}
