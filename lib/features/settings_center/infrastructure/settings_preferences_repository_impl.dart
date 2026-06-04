import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

/// SharedPreferences 版设置仓储，实现轻量偏好持久化。
final class SettingsPreferencesRepositoryImpl
    implements SettingsPreferencesRepository {
  /// 创建仓储实现。
  const SettingsPreferencesRepositoryImpl({required SharedPreferences preferences})
    : _preferences = preferences;

  static const String _maskPrivateContentKey = 'settings.maskPrivateContent';
  static const String _notificationsEnabledKey = 'settings.notificationsEnabled';
  static const String _widgetDisplayModeKey = 'settings.widgetDisplayMode';

  final SharedPreferences _preferences;

  @override
  Future<SettingsPreferences> load() async {
    final String? widgetDisplayModeName = _preferences.getString(
      _widgetDisplayModeKey,
    );

    return SettingsPreferences(
      maskPrivateContent: _preferences.getBool(_maskPrivateContentKey) ?? true,
      notificationsEnabled: _preferences.getBool(_notificationsEnabledKey) ?? true,
      widgetDisplayMode: widgetDisplayModeName == null
          ? WidgetDisplayMode.list3
          : WidgetDisplayMode.values.byName(widgetDisplayModeName),
    );
  }

  @override
  Future<void> save(SettingsPreferences preferences) async {
    await _preferences.setBool(
      _maskPrivateContentKey,
      preferences.maskPrivateContent,
    );
    await _preferences.setBool(
      _notificationsEnabledKey,
      preferences.notificationsEnabled,
    );
    await _preferences.setString(
      _widgetDisplayModeKey,
      preferences.widgetDisplayMode.name,
    );
  }
}
