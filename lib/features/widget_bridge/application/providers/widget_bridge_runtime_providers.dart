import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_snapshot_shared_providers.dart';
import 'package:screen_note/features/widget_bridge/application/services/widget_snapshot_auto_sync_coordinator.dart';
import 'package:screen_note/features/widget_bridge/application/services/widget_snapshot_sync_service.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';

export 'widget_snapshot_shared_providers.dart';

part 'widget_bridge_runtime_providers.g.dart';

/// Widget 自动同步协调器 Provider，统一复用任务真源、设置偏好与共享存储。
@Riverpod(keepAlive: true)
WidgetSnapshotAutoSyncCoordinator widgetSnapshotAutoSyncCoordinator(Ref ref) {
  final TaskRepository taskRepository = ref.watch(taskFlowRepositoryProvider);
  final SettingsPreferencesRepository settingsRepository = ref.watch(
    settingsPreferencesRepositoryProvider,
  );

  return WidgetSnapshotAutoSyncCoordinator(
    taskRepository: taskRepository,
    snapshotStore: ref.watch(widgetSnapshotStoreProvider),
    projector: ref.watch(widgetSnapshotProjectorProvider),
    loadStoredPreferences: settingsRepository.loadPreferences,
  );
}

/// Widget 快照同步服务 Provider，供后续手动同步或诊断入口统一复用。
@Riverpod(keepAlive: true)
WidgetSnapshotSyncService widgetSnapshotSyncService(Ref ref) {
  return WidgetSnapshotSyncService(
    taskRepository: ref.watch(taskFlowRepositoryProvider),
    settingsRepository: ref.watch(settingsPreferencesRepositoryProvider),
    snapshotStore: ref.watch(widgetSnapshotStoreProvider),
    projector: ref.watch(widgetSnapshotProjectorProvider),
  );
}

@Riverpod(keepAlive: true)
class WidgetBridgeController extends _$WidgetBridgeController {
  @override
  Future<WidgetSnapshot> build() {
    return ref.watch(widgetSnapshotSyncServiceProvider).loadSnapshot();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<WidgetSnapshot>();
    state = await AsyncValue.guard(
      () => ref.read(widgetSnapshotSyncServiceProvider).loadSnapshot(),
    );
  }

  Future<bool> syncSnapshot() async {
    final bool synced = await ref
        .read(widgetSnapshotSyncServiceProvider)
        .syncSnapshot();
    if (synced) {
      await refresh();
    }
    return synced;
  }
}
