import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';

/// 空副作用实现，用于测试与当前未接入平台能力时的安全降级。
final class TaskFlowNoopSideEffectPort implements TaskFlowSideEffectPort {
  /// 创建无副作用端口。
  const TaskFlowNoopSideEffectPort();

  @override
  Future<void> onTaskCreated(TaskEntity task) async {}

  @override
  Future<void> onTaskStatusChanged({
    required TaskEntity task,
    required TaskEventEntity event,
  }) async {}

  @override
  Future<void> onTaskFeedLoaded(TaskFeedSnapshot snapshot) async {}
}
