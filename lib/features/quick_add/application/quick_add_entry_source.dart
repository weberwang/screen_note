import 'package:json_annotation/json_annotation.dart';

part 'quick_add_entry_source.g.dart';

/// 快速添加入口来源。
///
/// 这里固定阶段四允许写入的来源白名单，避免页面、系统桥接或后续流程层
/// 各自发明新的字符串常量，导致草稿恢复与埋点口径不一致。
@JsonEnum(alwaysCreate: true)
enum QuickAddEntrySource {
  @JsonValue('home')
  home,

  @JsonValue('appIntent')
  appIntent,

  @JsonValue('controlCenter')
  controlCenter,

  @JsonValue('lockScreen')
  lockScreen,

  @JsonValue('actionButton')
  actionButton,

  @JsonValue('deepLink')
  deepLink,

  @JsonValue('fallback')
  fallback,
}

/// 暴露稳定的来源枚举映射，供契约层和测试层共享同一份 JSON 口径。
const Map<QuickAddEntrySource, String> quickAddEntrySourceJsonMap =
    _$QuickAddEntrySourceEnumMap;
