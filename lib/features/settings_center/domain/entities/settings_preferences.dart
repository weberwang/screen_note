import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';

part 'settings_preferences.freezed.dart';

/// 设置中心偏好实体，统一承载锁屏隐私、通知与展示样式选择。
@freezed
abstract class SettingsPreferences with _$SettingsPreferences {
  /// 创建设置偏好实体。
  const factory SettingsPreferences({
    required bool maskPrivateContent,
    required bool notificationsEnabled,
    required WidgetDisplayMode widgetDisplayMode,
  }) = _SettingsPreferences;
}
