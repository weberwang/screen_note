import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';

/// `task-flow` 副作用端口，统一承接提醒、快照刷新等能力降级型动作。
abstract interface class TaskFlowSideEffectPort {
  /// 事项创建后触发副作用。
  Future<void> onTaskCreated(TaskEntity task);

  /// 事项状态变化后触发副作用。
  Future<void> onTaskStatusChanged({
    required TaskEntity task,
    required TaskEventEntity event,
  });

  /// 首页任务流读取后触发副作用。
  Future<void> onTaskFeedLoaded(TaskFeedSnapshot snapshot);
}
