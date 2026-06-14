import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';

/// 设置副作用端口，统一承接偏好落库后的能力降级型联动动作。
abstract interface class SettingsSideEffectPort {
  /// 设置偏好变更后触发副作用。
  Future<void> onPreferencesChanged(SettingsCenterPreferences preferences);
}
