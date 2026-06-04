import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/core/storage/app_preferences.dart';
import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/application/use_cases/load_settings_preferences_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_settings_preferences_use_case.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/settings_center/infrastructure/settings_preferences_repository_impl.dart';
import 'package:screen_note/features/settings_center/infrastructure/settings_side_effect_noop_port.dart';

part 'settings_center_runtime_providers.g.dart';

/// 设置页偏好存储入口，复用全局 SharedPreferences 基线。
@riverpod
Future<SharedPreferences> settingsSharedPreferences(Ref ref) {
  return ref.watch(sharedPreferencesProvider.future);
}

/// 设置偏好仓储提供器。
@riverpod
Future<SettingsPreferencesRepository> settingsPreferencesRepository(Ref ref) async {
  final SharedPreferences preferences = await ref.watch(
    settingsSharedPreferencesProvider.future,
  );
  return SettingsPreferencesRepositoryImpl(preferences: preferences);
}

/// 设置副作用端口提供器。
@riverpod
SettingsSideEffectPort settingsSideEffectPort(Ref ref) {
  return const SettingsSideEffectNoopPort();
}

/// 读取设置偏好用例提供器。
@riverpod
Future<LoadSettingsPreferencesUseCase> loadSettingsPreferencesUseCase(
  Ref ref,
) async {
  final SettingsPreferencesRepository repository = await ref.watch(
    settingsPreferencesRepositoryProvider.future,
  );
  return LoadSettingsPreferencesUseCase(repository: repository);
}

/// 更新设置偏好用例提供器。
@riverpod
Future<UpdateSettingsPreferencesUseCase> updateSettingsPreferencesUseCase(
  Ref ref,
) async {
  final SettingsPreferencesRepository repository = await ref.watch(
    settingsPreferencesRepositoryProvider.future,
  );
  return UpdateSettingsPreferencesUseCase(
    repository: repository,
    sideEffectPort: ref.watch(settingsSideEffectPortProvider),
  );
}

/// 设置页控制器，统一收口偏好读取、切换和保存。
@riverpod
class SettingsCenterController extends _$SettingsCenterController {
  /// 构建设置页状态。
  @override
  Future<SettingsPreferences> build() async {
    final LoadSettingsPreferencesUseCase useCase = await ref.watch(
      loadSettingsPreferencesUseCaseProvider.future,
    );
    return useCase.execute();
  }

  /// 更新设置页偏好并立即回显。
  Future<void> save(SettingsPreferences preferences) async {
    final UpdateSettingsPreferencesUseCase useCase = await ref.read(
      updateSettingsPreferencesUseCaseProvider.future,
    );
    await useCase.execute(preferences);
    state = AsyncData(preferences);
  }
}
