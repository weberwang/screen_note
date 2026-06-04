import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';

/// 设置偏好仓储接口，统一隔离 SharedPreferences 和后续平台能力接线。
abstract interface class SettingsPreferencesRepository {
  /// 读取当前设置偏好。
  Future<SettingsPreferences> load();

  /// 保存当前设置偏好。
  Future<void> save(SettingsPreferences preferences);
}
