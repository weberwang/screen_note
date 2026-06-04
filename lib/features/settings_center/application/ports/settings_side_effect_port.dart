import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';

/// 设置副作用端口，后续用于同步 Widget 样式和通知相关降级能力。
abstract interface class SettingsSideEffectPort {
  /// 在设置变更后执行必要同步；失败时只能降级，不能阻断偏好写入。
  Future<void> handlePreferencesChanged(SettingsPreferences preferences);
}
