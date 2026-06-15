import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

/// SharedPreferences 版设置仓储，实现轻量偏好的持久化读写。
final class SettingsPreferencesRepositoryImpl
    implements SettingsPreferencesRepository {
  /// 创建仓储实现。
  const SettingsPreferencesRepositoryImpl({required SharedPreferences preferences})
    : _preferences = preferences;

  static const String _privacyModeEnabledKey = 'settings.privacyModeEnabled';
  static const String _widgetDisplayModeKey = 'settings.widgetDisplayMode';
  static const String _themeModePreferenceKey = 'settings.themeModePreference';
  static const String _languagePreferenceKey = 'settings.languagePreference';

  final SharedPreferences _preferences;

  @override
  Future<SettingsCenterPreferences> loadPreferences() async {
    final String? widgetDisplayModeName = _preferences.getString(
      _widgetDisplayModeKey,
    );
    final String? themeModeName = _preferences.getString(_themeModePreferenceKey);
    final String? languageName = _preferences.getString(_languagePreferenceKey);

    return SettingsCenterPreferences(
      privacyModeEnabled: _preferences.getBool(_privacyModeEnabledKey) ?? false,
      widgetDisplayMode: widgetDisplayModeName == null
          ? WidgetDisplayMode.previewOnly
          : WidgetDisplayMode.values.byName(widgetDisplayModeName),
      themeModePreference: themeModeName == null
          ? SettingsThemeModePreference.system
          : SettingsThemeModePreference.values.byName(themeModeName),
      languagePreference: languageName == null
          ? SettingsLanguagePreference.en
          : SettingsLanguagePreference.values.byName(languageName),
    );
  }

  @override
  Future<void> savePreferences(SettingsCenterPreferences preferences) async {
    await _preferences.setBool(
      _privacyModeEnabledKey,
      preferences.privacyModeEnabled,
    );
    await _preferences.setString(
      _widgetDisplayModeKey,
      preferences.widgetDisplayMode.name,
    );
    await _preferences.setString(
      _themeModePreferenceKey,
      preferences.themeModePreference.name,
    );
    await _preferences.setString(
      _languagePreferenceKey,
      preferences.languagePreference.name,
    );
  }
}
