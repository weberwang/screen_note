import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_snapshot_item.freezed.dart';
part 'widget_snapshot_item.g.dart';

/// 锁屏小组件单条快照项，只保留原生渲染必须消费的稳定字段。
@freezed
abstract class WidgetSnapshotItem with _$WidgetSnapshotItem {
  /// 创建小组件快照项。
  const factory WidgetSnapshotItem({
    required String title,
    required String statusLabel,
    required String dueLabel,
    required bool isPinned,
    required bool isOverdue,
    required bool isPrivate,
    required int rank,
  }) = _WidgetSnapshotItem;

  /// 从 JSON 读取快照项，保证 Flutter 与原生侧共享同一份合同结构。
  factory WidgetSnapshotItem.fromJson(Map<String, dynamic> json) =>
      _$WidgetSnapshotItemFromJson(json);
}
