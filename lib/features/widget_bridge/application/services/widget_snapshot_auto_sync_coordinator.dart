import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/task_flow/application/use_cases/load_task_feed_use_case.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/widget_snapshot_projector.dart';

/// Widget 自动同步协调器，负责把当前事实源与偏好投影成稳定快照并写入共享存储。
final class WidgetSnapshotAutoSyncCoordinator {
  /// 创建自动同步协调器。
  WidgetSnapshotAutoSyncCoordinator({
    required TaskRepository taskRepository,
    required WidgetSnapshotStore snapshotStore,
    required WidgetSnapshotProjector projector,
    required Future<SettingsCenterPreferences> Function() loadStoredPreferences,
  }) : _loadTaskFeedUseCase = LoadTaskFeedUseCase(repository: taskRepository),
       _snapshotStore = snapshotStore,
       _projector = projector,
       _loadStoredPreferences = loadStoredPreferences;

  final LoadTaskFeedUseCase _loadTaskFeedUseCase;
  final WidgetSnapshotStore _snapshotStore;
  final WidgetSnapshotProjector _projector;
  final Future<SettingsCenterPreferences> Function() _loadStoredPreferences;

  /// 用当前已持久化偏好生成并同步快照。
  Future<bool> syncStoredPreferences({DateTime? now}) async {
    final SettingsCenterPreferences preferences =
        await _loadStoredPreferences();
    return syncPreferences(preferences, now: now);
  }

  /// 用给定偏好生成并同步快照，适合设置保存完成后的即时联动。
  Future<bool> syncPreferences(
    SettingsCenterPreferences preferences, {
    DateTime? now,
  }) async {
    final taskFeed = await _loadTaskFeedUseCase.execute(now: now);
    final snapshot = _projector.project(
      taskFeed: taskFeed,
      preferences: preferences,
      now: now,
    );
    return _snapshotStore.saveSnapshot(snapshot);
  }
}
