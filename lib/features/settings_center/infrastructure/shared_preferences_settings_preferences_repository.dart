import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/settings_center/infrastructure/settings_preferences_repository_impl.dart';

/// SharedPreferences 偏好仓储入口，按调用时懒加载实例，避免页面装配阶段提前持有平台对象。
final class SharedPreferencesSettingsPreferencesRepository
    implements SettingsPreferencesRepository {
  /// 创建 SharedPreferences 偏好仓储入口。
  const SharedPreferencesSettingsPreferencesRepository();

  /// 统一延迟获取 SharedPreferences，避免 provider 同步构造阶段依赖异步初始化。
  Future<SettingsPreferencesRepositoryImpl> _loadRepository() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return SettingsPreferencesRepositoryImpl(preferences: preferences);
  }

  @override
  Future<SettingsCenterPreferences> loadPreferences() async {
    final repository = await _loadRepository();
    return repository.loadPreferences();
  }

  @override
  Future<void> savePreferences(SettingsCenterPreferences preferences) async {
    final repository = await _loadRepository();
    await repository.savePreferences(preferences);
  }
}
