import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

/// 更新设置偏好的用例，统一收口写入与后续同步副作用。
final class UpdateSettingsPreferencesUseCase {
  /// 创建更新用例。
  const UpdateSettingsPreferencesUseCase({
    required SettingsPreferencesRepository repository,
    required SettingsSideEffectPort sideEffectPort,
  }) : _repository = repository,
       _sideEffectPort = sideEffectPort;

  final SettingsPreferencesRepository _repository;
  final SettingsSideEffectPort _sideEffectPort;

  /// 执行更新逻辑。
  Future<void> execute(SettingsPreferences preferences) async {
    await _repository.save(preferences);
    await _sideEffectPort.handlePreferencesChanged(preferences);
  }
}
