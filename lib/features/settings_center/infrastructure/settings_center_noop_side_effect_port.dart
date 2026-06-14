import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';

/// 设置中心空副作用实现，供测试或能力未接入场景安全降级。
final class SettingsCenterNoopSideEffectPort implements SettingsSideEffectPort {
  /// 创建无副作用端口。
  const SettingsCenterNoopSideEffectPort();

  @override
  Future<void> onPreferencesChanged(SettingsCenterPreferences preferences) async {}
}
