import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

/// 读取设置偏好的用例，统一输出页面所需的当前偏好快照。
final class LoadSettingsPreferencesUseCase {
  /// 创建读取用例。
  const LoadSettingsPreferencesUseCase({
    required SettingsPreferencesRepository repository,
  }) : _repository = repository;

  final SettingsPreferencesRepository _repository;

  /// 执行读取逻辑。
  Future<SettingsPreferences> execute() {
    return _repository.load();
  }
}
