import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/widget_bridge/application/services/widget_snapshot_auto_sync_coordinator.dart';

/// 事项副作用实现，把创建/完成/删除/恢复等状态变更自动联动到锁屏快照同步。
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
  Future<void> handleTaskMutation({
    required TaskEntity task,
    required TaskMutationKind kind,
  }) async {
    try {
      await _coordinator.syncStoredPreferences();
    } catch (error, stackTrace) {
      // 锁屏快照同步失败只允许降级，绝不能回滚已经提交的事项状态。
      _logger.warning(
        'widget_snapshot_sync_after_task_mutation_failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
