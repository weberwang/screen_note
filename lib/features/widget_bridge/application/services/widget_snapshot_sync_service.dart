import 'dart:ui';

import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/task_flow/application/use_cases/load_task_feed_use_case.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/widget_snapshot_projector.dart';

/// Widget 快照同步服务，统一收口事实源读取、投影和共享存储写入。
final class WidgetSnapshotSyncService {
  /// 创建 Widget 快照同步服务。
  WidgetSnapshotSyncService({
    required TaskRepository taskRepository,
    required SettingsPreferencesRepository settingsRepository,
    required WidgetSnapshotStore snapshotStore,
    required WidgetSnapshotProjector projector,
    required Locale locale,
  }) : _loadTaskFeedUseCase = LoadTaskFeedUseCase(repository: taskRepository),
       _settingsRepository = settingsRepository,
       _snapshotStore = snapshotStore,
       _projector = projector,
       _locale = locale;

  final LoadTaskFeedUseCase _loadTaskFeedUseCase;
  final SettingsPreferencesRepository _settingsRepository;
  final WidgetSnapshotStore _snapshotStore;
  final WidgetSnapshotProjector _projector;
  final Locale _locale;

  /// 读取当前可用于 Widget / 锁屏的稳定快照。
  Future<WidgetSnapshot> loadSnapshot({DateTime? now}) async {
    final taskFeed = await _loadTaskFeedUseCase.execute(now: now);
    final settingsPreferences = await _settingsRepository.loadPreferences();
    return _projector.project(
      taskFeed: taskFeed,
      preferences: settingsPreferences,
      locale: _locale,
      now: now,
    );
  }

  /// 生成并写入当前稳定快照；返回值只表示桥接是否成功，不会影响业务主链路。
  Future<bool> syncSnapshot({DateTime? now}) async {
    final WidgetSnapshot snapshot = await loadSnapshot(now: now);
    return _snapshotStore.saveSnapshot(snapshot);
  }
}
