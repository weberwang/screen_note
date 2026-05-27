import 'dart:developer';

import '../../tasks/application/services/task_sorting_service.dart';
import '../../tasks/domain/entities/task.dart';
import '../../tasks/domain/repositories/task_repository.dart';
import '../domain/enums/widget_display_mode.dart';
import '../domain/models/widget_snapshot.dart';
import '../domain/repositories/widget_display_mode_repository.dart';
import '../domain/repositories/widget_snapshot_store.dart';
import 'widget_refresh_result.dart';
import 'widget_snapshot_builder.dart';
import 'widget_snapshot_refresher.dart';

/// Widget 刷新调度器。
///
/// 事项主链路只在用例末尾调用它一次；它负责读取当前任务、复用主应用排序、
/// 生成共享快照并在失败时自动降级到最后有效内容或空态。
final class WidgetRefreshScheduler implements WidgetSnapshotRefresher {
  /// 创建 Widget 刷新调度器。
  WidgetRefreshScheduler({
    required TaskRepository taskRepository,
    required TaskSortingService taskSortingService,
    required WidgetDisplayModeRepository displayModeRepository,
    required WidgetSnapshotBuilder snapshotBuilder,
    required WidgetSnapshotStore snapshotStore,
    required DateTime Function() now,
  }) : _taskRepository = taskRepository,
       _taskSortingService = taskSortingService,
       _displayModeRepository = displayModeRepository,
       _snapshotBuilder = snapshotBuilder,
       _snapshotStore = snapshotStore,
       _now = now;

  final TaskRepository _taskRepository;
  final TaskSortingService _taskSortingService;
  final WidgetDisplayModeRepository _displayModeRepository;
  final WidgetSnapshotBuilder _snapshotBuilder;
  final WidgetSnapshotStore _snapshotStore;
  final DateTime Function() _now;

  @override
  Future<WidgetRefreshResult> refresh() async {
    try {
      final List<Task> allTasks = await _taskRepository.findAll();
      final WidgetDisplayMode mode = await _displayModeRepository.read();
      final List<Task> sortedTasks = _taskSortingService.sortActiveTasks(
        allTasks,
        now: _now(),
      );
      final WidgetSnapshot snapshot = _snapshotBuilder.build(
        sortedTasks: sortedTasks,
        displayMode: mode,
      );

      await _snapshotStore.save(snapshot);
      return WidgetRefreshResult.success;
    } catch (error, stackTrace) {
      log(
        'Widget refresh failed, trying fallback snapshot.',
        name: 'WidgetRefreshScheduler',
        error: error,
        stackTrace: stackTrace,
      );
      return _saveFallback();
    }
  }

  Future<WidgetRefreshResult> _saveFallback() async {
    try {
      final WidgetSnapshot? cachedSnapshot = await _snapshotStore.readLastValid();
      final WidgetSnapshot fallbackSnapshot = _snapshotBuilder.markAsFallback(
        cachedSnapshot ?? _snapshotBuilder.buildEmptySnapshot(),
      );
      await _snapshotStore.save(fallbackSnapshot);
      return WidgetRefreshResult.savedFallback;
    } catch (error, stackTrace) {
      log(
        'Widget fallback save failed, downgrade to non-blocking failure.',
        name: 'WidgetRefreshScheduler',
        error: error,
        stackTrace: stackTrace,
      );
      return WidgetRefreshResult.failedButNonBlocking;
    }
  }
}
