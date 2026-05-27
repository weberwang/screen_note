import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/widget_display_mode.dart';
import 'widget_snapshot_item.dart';

part 'widget_snapshot.freezed.dart';
part 'widget_snapshot.g.dart';

/// Widget 共享快照。
///
/// Flutter 主应用把排序和隐私处理结果压缩成这份快照，Widget 只读不写，
/// 以此保证原生壳层不再重复数据库查询与业务推导。
@freezed
abstract class WidgetSnapshot with _$WidgetSnapshot {
  /// 创建 Widget 共享快照。
  const factory WidgetSnapshot({
    required String snapshotId,
    required DateTime generatedAt,
    required WidgetDisplayMode displayMode,
    @Default(<WidgetSnapshotItem>[]) List<WidgetSnapshotItem> items,
    @Default(false) bool hasPrivateContent,
    @Default(false) bool hasFallbackContent,
    @Default(1) int version,
  }) = _WidgetSnapshot;

  /// 从 JSON 还原 Widget 快照。
  factory WidgetSnapshot.fromJson(Map<String, Object?> json) =>
      _$WidgetSnapshotFromJson(json);
}
