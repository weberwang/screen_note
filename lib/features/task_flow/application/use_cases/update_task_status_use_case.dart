import 'package:uuid/uuid.dart';

import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';

/// 状态流转用例，统一编排完成、删除、恢复三条关键状态链路。
final class UpdateTaskStatusUseCase {
  /// 创建状态流转用例。
  const UpdateTaskStatusUseCase({
    required TaskMutationRepository repository,
    required TaskFlowSideEffectPort sideEffectPort,
    required Uuid uuid,
  }) : _repository = repository,
       _sideEffectPort = sideEffectPort,
       _uuid = uuid;

  final TaskMutationRepository _repository;
  final TaskFlowSideEffectPort _sideEffectPort;
  final Uuid _uuid;

  /// 标记完成。
  Future<void> completeTask({
    required String taskId,
    required DateTime occurredAt,
  }) async {
    await _updateStatus(
      taskId: taskId,
      occurredAt: occurredAt,
      nextStatus: TaskStatus.completed,
      eventType: 'completed',
      completedAt: occurredAt,
      deletedAt: null,
    );
  }

  /// 软删除事项。
  Future<void> deleteTask({
    required String taskId,
    required DateTime occurredAt,
  }) async {
    await _updateStatus(
      taskId: taskId,
      occurredAt: occurredAt,
      nextStatus: TaskStatus.deleted,
      eventType: 'deleted',
      completedAt: null,
      deletedAt: occurredAt,
    );
  }

  /// 恢复已删除事项，并沿用原任务 ID。
  Future<void> restoreTask({
    required String taskId,
    required DateTime occurredAt,
  }) async {
    await _updateStatus(
      taskId: taskId,
      occurredAt: occurredAt,
      nextStatus: TaskStatus.active,
      eventType: 'restored',
      completedAt: null,
      deletedAt: null,
    );
  }

  /// 统一状态更新与日志写入，避免页面层直接改库导致历史链路失真。
  Future<void> _updateStatus({
    required String taskId,
    required DateTime occurredAt,
    required TaskStatus nextStatus,
    required String eventType,
    required DateTime? completedAt,
    required DateTime? deletedAt,
  }) async {
    final TaskEntity? currentTask = await _repository.findTaskById(taskId);
    if (currentTask == null) {
      throw StateError('未找到事项: $taskId');
    }

    _assertTransitionAllowed(currentTask.status, nextStatus);

    final TaskEntity updatedTask = currentTask.copyWith(
      status: nextStatus,
      updatedAt: occurredAt,
      completedAt: completedAt,
      deletedAt: deletedAt,
    );
    final TaskEventEntity event = TaskEventEntity(
      id: _uuid.v4(),
      taskId: taskId,
      type: eventType,
      fromStatus: currentTask.status,
      toStatus: nextStatus,
      occurredAt: occurredAt,
    );

    await _repository.updateTaskWithEvent(task: updatedTask, event: event);
    await _sideEffectPort.onTaskStatusChanged(task: updatedTask, event: event);
  }

  /// 只允许被业务明确定义的状态跳转，避免错误或无意义写入污染真源。
  void _assertTransitionAllowed(TaskStatus current, TaskStatus next) {
    final bool isAllowed = switch ((current, next)) {
      (TaskStatus.active, TaskStatus.completed) => true,
      (TaskStatus.active, TaskStatus.deleted) => true,
      (TaskStatus.completed, TaskStatus.deleted) => true,
      (TaskStatus.deleted, TaskStatus.active) => true,
      _ => false,
    };

    if (!isAllowed) {
      throw StateError('非法状态流转: ${current.name} -> ${next.name}');
    }
  }
}
