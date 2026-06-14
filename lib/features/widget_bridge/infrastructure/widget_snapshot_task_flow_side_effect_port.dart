import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/widget_bridge/application/services/widget_snapshot_auto_sync_coordinator.dart';

/// 事项副作用实现，把创建与关键状态流转自动联动到最新 Widget 快照同步。
final class WidgetSnapshotTaskFlowSideEffectPort
    implements TaskFlowSideEffectPort {
  /// 创建事项副作用实现。
  const WidgetSnapshotTaskFlowSideEffectPort({
    required WidgetSnapshotAutoSyncCoordinator coordinator,
    required AppLogger logger,
  }) : _coordinator = coordinator,
       _logger = logger;

  final WidgetSnapshotAutoSyncCoordinator _coordinator;
  final AppLogger _logger;

  @override
  Future<void> onTaskCreated(TaskEntity task) async {
    await _syncSafely();
  }

  @override
  Future<void> onTaskStatusChanged({
    required TaskEntity task,
    required TaskEventEntity event,
  }) async {
    await _syncSafely();
  }

  @override
  Future<void> onTaskFeedLoaded(TaskFeedSnapshot snapshot) async {}

  /// Widget 同步失败只能记录并降级，绝不能回滚已经落库的事项变更。
  Future<void> _syncSafely() async {
    try {
      await _coordinator.syncStoredPreferences();
    } catch (_) {
      _logger.warning('widget_snapshot_sync_after_task_mutation_failed');
    }
  }
}
