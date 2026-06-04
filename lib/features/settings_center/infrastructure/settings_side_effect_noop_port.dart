import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';

/// 空副作用实现，保证设置页先能稳定写偏好，再逐步接通知与 Widget 同步。
final class SettingsSideEffectNoopPort implements SettingsSideEffectPort {
  /// 创建空副作用实现。
  const SettingsSideEffectNoopPort();

  @override
  Future<void> handlePreferencesChanged(SettingsPreferences preferences) async {}
}
