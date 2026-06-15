import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

/// 主题偏好更新用例，统一负责落库与设置侧联动。
final class UpdateThemeModePreferenceUseCase {
  /// 创建主题偏好更新用例。
  const UpdateThemeModePreferenceUseCase({
    required SettingsPreferencesRepository repository,
    required SettingsSideEffectPort sideEffectPort,
  }) : _repository = repository,
       _sideEffectPort = sideEffectPort;

  final SettingsPreferencesRepository _repository;
  final SettingsSideEffectPort _sideEffectPort;

  /// 更新主题偏好，并在保存成功后触发共享副作用。
  Future<SettingsCenterPreferences> execute({
    required SettingsThemeModePreference mode,
  }) async {
    final current = await _repository.loadPreferences();
    final next = current.copyWith(themeModePreference: mode);
    await _repository.savePreferences(next);
    await _sideEffectPort.onPreferencesChanged(next);
    return next;
  }
}
