import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';

part 'settings_center_preferences.freezed.dart';

/// 设置中心偏好实体，统一承接隐私、展示、主题与语言偏好。
@freezed
abstract class SettingsCenterPreferences with _$SettingsCenterPreferences {
  /// 创建设置中心偏好实体。
  const factory SettingsCenterPreferences({
    @Default(false) bool privacyModeEnabled,
    @Default(WidgetDisplayMode.previewOnly) WidgetDisplayMode widgetDisplayMode,
    @Default(SettingsThemeModePreference.system)
    SettingsThemeModePreference themeModePreference,
    @Default(SettingsLanguagePreference.en)
    SettingsLanguagePreference languagePreference,
  }) = _SettingsCenterPreferences;
}
