import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

/// 主题偏好更新用例统一收口主题持久化与共享副作用联动，避免页面层直接碰仓储。
final class UpdateThemeModePreferenceUseCase {
  /// 创建主题偏好更新用例。
  const UpdateThemeModePreferenceUseCase({
    required SettingsPreferencesRepository repository,
    required SettingsSideEffectPort sideEffectPort,
  }) : _repository = repository,
       _sideEffectPort = sideEffectPort;

  final SettingsPreferencesRepository _repository;
  final SettingsSideEffectPort _sideEffectPort;

  /// 更新主题偏好。
  Future<SettingsCenterPreferences> execute({
    required SettingsThemeModePreference mode,
  }) async {
    final SettingsCenterPreferences current =
        await _repository.loadPreferences();
    final SettingsCenterPreferences next = current.copyWith(
      themeModePreference: mode,
    );
    await _repository.savePreferences(next);
    // 先落库再广播副作用，保证根应用和后续桥接链路读到的是同一份稳定偏好。
    await _sideEffectPort.onPreferencesChanged(next);
    return next;
  }
}
