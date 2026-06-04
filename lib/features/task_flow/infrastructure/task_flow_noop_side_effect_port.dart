import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';

/// 空副作用实现，保证提醒和快照能力未接入时也不会阻断事项主链路。
final class TaskFlowNoopSideEffectPort implements TaskFlowSideEffectPort {
  /// 创建空副作用实现。
  const TaskFlowNoopSideEffectPort();

  @override
  Future<void> handleTaskMutation({
    required TaskEntity task,
    required TaskMutationKind kind,
  }) async {}
}
