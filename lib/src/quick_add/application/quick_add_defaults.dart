import 'package:freezed_annotation/freezed_annotation.dart';

import 'quick_add_entry_source.dart';

part 'quick_add_defaults.freezed.dart';
part 'quick_add_defaults.g.dart';

/// 快速添加默认值策略。
///
/// 不同入口只允许通过这份契约注入默认截止时间、置顶与隐私开关，
/// 后续流程层与展示层只消费结果，不再自行拼装默认值分支。
@freezed
abstract class QuickAddDefaults with _$QuickAddDefaults {
  /// 创建快速添加默认值配置。
  const factory QuickAddDefaults({
    DateTime? dueAt,
    @Default(false) bool isPinned,
    @Default(false) bool isPrivate,
  }) = _QuickAddDefaults;

  /// 从 JSON 还原快速添加默认值配置。
  factory QuickAddDefaults.fromJson(Map<String, Object?> json) =>
      _$QuickAddDefaultsFromJson(json);

  /// 根据入口来源返回默认值。
  ///
  /// 这里先显式列出所有允许来源，即使当前默认行为一致，也能防止后续
  /// 新增来源时漏掉默认值策略审查。
  static QuickAddDefaults forSource(QuickAddEntrySource source) {
    return switch (source) {
      QuickAddEntrySource.home ||
      QuickAddEntrySource.appIntent ||
      QuickAddEntrySource.controlCenter ||
      QuickAddEntrySource.lockScreen ||
      QuickAddEntrySource.actionButton ||
      QuickAddEntrySource.deepLink ||
      QuickAddEntrySource.fallback => const QuickAddDefaults(),
    };
  }
}
