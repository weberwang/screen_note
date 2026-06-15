import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';

/// 空副作用实现，保证设置页可以先稳定落偏好，再逐步接入通知与 Widget 联动。
final class SettingsSideEffectNoopPort implements SettingsSideEffectPort {
  /// 创建空副作用实现。
  const SettingsSideEffectNoopPort();

  @override
  Future<void> onPreferencesChanged(SettingsCenterPreferences preferences) async {}
}
