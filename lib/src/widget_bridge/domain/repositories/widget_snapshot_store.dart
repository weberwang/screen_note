import '../models/widget_snapshot.dart';

/// Widget 快照仓储。
///
/// 该仓储负责当前快照与最后有效快照的读写边界，应用层只关心快照语义，
/// 不直接接触 App Group、HomeWidget 或底层 JSON 键名。
abstract interface class WidgetSnapshotStore {
  /// 读取当前快照。
  Future<WidgetSnapshot?> read();

  /// 读取最后一次可安全展示的快照。
  Future<WidgetSnapshot?> readLastValid();

  /// 保存当前快照，并同步更新最后有效快照。
  Future<void> save(WidgetSnapshot snapshot);
}
