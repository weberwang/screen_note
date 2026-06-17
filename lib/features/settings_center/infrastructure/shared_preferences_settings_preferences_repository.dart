import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

const _privacyModeKey = 'settings_center.privacy_mode_enabled';
const _widgetDisplayModeKey = 'settings_center.widget_display_mode';
const _themeModePreferenceKey = 'settings_center.theme_mode_preference';
const _languagePreferenceKey = 'settings_center.language_preference';

/// `shared_preferences` 仓储实现，统一维护设置页轻量偏好，不把 key 散落到页面层。
final class SharedPreferencesSettingsPreferencesRepository
    implements SettingsPreferencesRepository {
  /// 创建偏好仓储实现。
  const SharedPreferencesSettingsPreferencesRepository();

  @override
  Future<SettingsCenterPreferences> loadPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final bool privacyModeEnabled =
        preferences.getBool(_privacyModeKey) ?? true;
    final String rawWidgetDisplayMode =
        preferences.getString(_widgetDisplayModeKey) ??
        WidgetDisplayMode.previewOnly.name;
    final String rawThemeModePreference =
        preferences.getString(_themeModePreferenceKey) ??
        SettingsThemeModePreference.system.name;
    final String rawLanguagePreference =
        preferences.getString(_languagePreferenceKey) ??
        SettingsLanguagePreference.zh.name;

    return SettingsCenterPreferences(
      privacyModeEnabled: privacyModeEnabled,
      widgetDisplayMode: _parseWidgetDisplayMode(rawWidgetDisplayMode),
      themeModePreference: _parseThemeModePreference(rawThemeModePreference),
      languagePreference: _parseLanguagePreference(rawLanguagePreference),
    );
  }

  @override
  Future<void> savePreferences(SettingsCenterPreferences preferences) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setBool(
      _privacyModeKey,
      preferences.privacyModeEnabled,
    );
    await sharedPreferences.setString(
      _widgetDisplayModeKey,
      preferences.widgetDisplayMode.name,
    );
    await sharedPreferences.setString(
      _themeModePreferenceKey,
      preferences.themeModePreference.name,
    );
    await sharedPreferences.setString(
      _languagePreferenceKey,
      preferences.languagePreference.name,
    );
  }

  /// 旧值或脏值都回退到安全模式，避免异常偏好扩大为隐私风险。
  WidgetDisplayMode _parseWidgetDisplayMode(String rawValue) {
    return WidgetDisplayMode.values
            .where((mode) => mode.name == rawValue)
            .firstOrNull ??
        WidgetDisplayMode.previewOnly;
  }

  /// 脏主题偏好回退到系统模式，避免异常持久化把应用锁死在错误展示状态。
  SettingsThemeModePreference _parseThemeModePreference(String rawValue) {
    return SettingsThemeModePreference.values
            .where((mode) => mode.name == rawValue)
            .firstOrNull ??
        SettingsThemeModePreference.system;
  }

  /// 脏语言偏好回退到简体中文，保证应用至少回到当前主交付语言。
  SettingsLanguagePreference _parseLanguagePreference(String rawValue) {
    return SettingsLanguagePreference.values
            .where((language) => language.name == rawValue)
            .firstOrNull ??
        SettingsLanguagePreference.zh;
  }
}
