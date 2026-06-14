import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_snapshot_item.freezed.dart';
part 'widget_snapshot_item.g.dart';

/// Widget 单条快照项，只保留原生展示与点击回流必须消费的稳定字段。
@freezed
abstract class WidgetSnapshotItem with _$WidgetSnapshotItem {
  /// 创建 Widget 快照项。
  const factory WidgetSnapshotItem({
    required String taskId,
    required String launchTarget,
    required String title,
    required String statusLabel,
    required String dueLabel,
    required bool isPinned,
    required bool isOverdue,
    required bool isPrivate,
    required int rank,
  }) = _WidgetSnapshotItem;

  /// 从 JSON 解析快照项，保证 Flutter 与原生扩展共享同一合同。
  factory WidgetSnapshotItem.fromJson(Map<String, dynamic> json) =>
      _$WidgetSnapshotItemFromJson(json);
}
