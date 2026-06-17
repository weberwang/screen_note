import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';

part 'settings_center_preferences.freezed.dart';

/// 设置中心偏好实体统一承载隐私模式与 Widget 展示模式。
@freezed
abstract class SettingsCenterPreferences with _$SettingsCenterPreferences {
  /// 创建设置中心偏好实体。
  const factory SettingsCenterPreferences({
    @Default(true) bool privacyModeEnabled,
    @Default(WidgetDisplayMode.previewOnly)
    WidgetDisplayMode widgetDisplayMode,
    @Default(SettingsThemeModePreference.system)
    SettingsThemeModePreference themeModePreference,
    @Default(SettingsLanguagePreference.zh)
    SettingsLanguagePreference languagePreference,
  }) = _SettingsCenterPreferences;
}
