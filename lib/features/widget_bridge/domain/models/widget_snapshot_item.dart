import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_snapshot_item.freezed.dart';
part 'widget_snapshot_item.g.dart';

/// Widget 展示条目。
///
/// 这里只存锁屏展示所需的稳定字段，不向 Widget 暴露完整事项实体，
/// 避免原生侧重新承载业务判断和隐私正文。
@freezed
abstract class WidgetSnapshotItem with _$WidgetSnapshotItem {
  /// 创建 Widget 展示条目。
  const factory WidgetSnapshotItem({
    required String title,
    required String statusLabel,
    required String dueLabel,
    required bool isPinned,
    required bool isOverdue,
    required bool isPrivate,
    required int rank,
  }) = _WidgetSnapshotItem;

  /// 从 JSON 还原 Widget 展示条目。
  factory WidgetSnapshotItem.fromJson(Map<String, Object?> json) =>
      _$WidgetSnapshotItemFromJson(json);
}
