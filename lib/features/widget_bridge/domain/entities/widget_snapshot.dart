import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot_item.dart';

part 'widget_snapshot.freezed.dart';
part 'widget_snapshot.g.dart';

/// 锁屏小组件共享快照，统一描述展示模式、条目列表与降级标记。
@freezed
abstract class WidgetSnapshot with _$WidgetSnapshot {
  /// 创建共享快照。
  const factory WidgetSnapshot({
    required String snapshotId,
    required DateTime generatedAt,
    required WidgetDisplayMode displayMode,
    required List<WidgetSnapshotItem> items,
    required bool hasPrivateContent,
    required bool hasFallbackContent,
    required int version,
  }) = _WidgetSnapshot;

  /// 从 JSON 读取共享快照，供 Flutter 和原生层共享同一份序列化合同。
  factory WidgetSnapshot.fromJson(Map<String, dynamic> json) =>
      _$WidgetSnapshotFromJson(json);
}
