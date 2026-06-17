import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

/// 语言偏好更新用例统一负责落库与共享副作用，避免页面层自己编排全局语言切换。
final class UpdateLanguagePreferenceUseCase {
  /// 创建语言偏好更新用例。
  const UpdateLanguagePreferenceUseCase({
    required SettingsPreferencesRepository repository,
    required SettingsSideEffectPort sideEffectPort,
  }) : _repository = repository,
       _sideEffectPort = sideEffectPort;

  final SettingsPreferencesRepository _repository;
  final SettingsSideEffectPort _sideEffectPort;

  /// 更新语言偏好。
  Future<SettingsCenterPreferences> execute({
    required SettingsLanguagePreference language,
  }) async {
    final SettingsCenterPreferences current =
        await _repository.loadPreferences();
    final SettingsCenterPreferences next = current.copyWith(
      languagePreference: language,
    );
    await _repository.savePreferences(next);
    // 语言切换同样先持久化再广播，避免根应用和设置页短暂读到不一致的语言值。
    await _sideEffectPort.onPreferencesChanged(next);
    return next;
  }
}
