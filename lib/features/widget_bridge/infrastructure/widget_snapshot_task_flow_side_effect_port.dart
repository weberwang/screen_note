import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/widget_bridge/application/services/widget_snapshot_auto_sync_coordinator.dart';

/// 事项副作用实现，把关键任务变更自动联动到最新 Widget 快照同步。
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
    // Widget 快照只关心数据已经变化，不区分入口来源，统一走同一条降级同步链路。
    await _syncSafely();
  }

  @override
  Future<void> onTaskStatusChanged({
    required TaskEntity task,
    required TaskEventEntity event,
  }) async {
    // 状态流转后最新快照必须尽快对齐，但同步失败也不能回滚已提交的任务事务。
    await _syncSafely();
  }

  @override
  Future<void> onTaskFeedLoaded(TaskFeedSnapshot snapshot) async {
    // 只读快照加载阶段不需要强制回写 Widget，避免普通读取放大成额外副作用。
  }

  /// Widget 同步失败只能记录并降级，绝不能回滚已经落库的事项变更。
  Future<void> _syncSafely() async {
    try {
      await _coordinator.syncStoredPreferences();
    } catch (_) {
      _logger.warning('widget_snapshot_sync_after_task_mutation_failed');
    }
  }
}
