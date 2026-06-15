import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';

/// 设置偏好仓储接口，统一隔离持久化实现细节。
abstract interface class SettingsPreferencesRepository {
  /// 读取当前设置偏好。
  Future<SettingsCenterPreferences> loadPreferences();

  /// 保存当前设置偏好。
  Future<void> savePreferences(SettingsCenterPreferences preferences);
}
