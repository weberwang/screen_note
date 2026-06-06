import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/core/storage/app_preferences.dart';
import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/application/use_cases/load_settings_preferences_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_settings_preferences_use_case.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/settings_center/infrastructure/settings_preferences_repository_impl.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_snapshot_shared_providers.dart';
import 'package:screen_note/features/widget_bridge/application/services/widget_snapshot_auto_sync_coordinator.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/widget_snapshot_settings_side_effect_port.dart';
import 'package:screen_note/l10n/app_localizations.dart';

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
  final TaskRepository taskRepository = ref.watch(taskRepositoryProvider);
  final WidgetSnapshotAutoSyncCoordinator coordinator =
      WidgetSnapshotAutoSyncCoordinator(
        taskRepository: taskRepository,
        snapshotStore: ref.watch(widgetSnapshotStoreProvider),
        projector: ref.watch(widgetSnapshotProjectorProvider),
        locale: _resolveAutoSyncLocale(),
        loadStoredPreferences: () async {
          final repository = await ref.read(
            settingsPreferencesRepositoryProvider.future,
          );
          return repository.load();
        },
      );
  return WidgetSnapshotSettingsSideEffectPort(
    coordinator: coordinator,
    logger: AppLogger.instance,
  );
}

Locale _resolveAutoSyncLocale() {
  final Locale locale = PlatformDispatcher.instance.locale;
  return AppLocalizations.supportedLocales.any(
        (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
      )
      ? Locale(locale.languageCode)
      : AppLocalizations.supportedLocales.first;
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
