import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';

/// 事项变更类型，统一驱动提醒与快照等后续副作用编排。
enum TaskMutationKind {
  /// 创建事项。
  created,

  /// 更新事项。
  updated,

  /// 完成事项。
  completed,

  /// 删除事项。
  deleted,

  /// 恢复事项。
  restored,
}

/// 事项副作用端口，隔离提醒、快照刷新与系统桥接能力。
abstract interface class TaskFlowSideEffectPort {
  /// 在事项变更后执行必要副作用；失败时只能降级，不能破坏主状态提交。
  Future<void> handleTaskMutation({
    required TaskEntity task,
    required TaskMutationKind kind,
  });
}
