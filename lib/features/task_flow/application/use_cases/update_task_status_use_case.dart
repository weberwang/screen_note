import 'package:uuid/uuid.dart';

import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';

/// 状态流转用例，统一收口完成、删除、恢复等关键状态修改。
final class UpdateTaskStatusUseCase {
  /// 创建状态流转用例。
  UpdateTaskStatusUseCase({
    required TaskRepository repository,
    required TaskFlowSideEffectPort sideEffectPort,
    Uuid? uuid,
  }) : _repository = repository,
       _sideEffectPort = sideEffectPort,
       _uuid = uuid ?? const Uuid();

  final TaskRepository _repository;
  final TaskFlowSideEffectPort _sideEffectPort;
  final Uuid _uuid;

  /// 完成事项，并记录状态事件。
  Future<TaskEntity> completeTask({
    required String taskId,
    DateTime? occurredAt,
  }) async {
    return _transition(
      taskId: taskId,
      occurredAt: occurredAt,
      targetStatus: TaskStatus.completed,
      mutationKind: TaskMutationKind.completed,
      eventType: TaskEventType.completed,
    );
  }

  /// 软删除事项，并记录删除时间。
  Future<TaskEntity> deleteTask({
    required String taskId,
    DateTime? occurredAt,
  }) async {
    return _transition(
      taskId: taskId,
      occurredAt: occurredAt,
      targetStatus: TaskStatus.deleted,
      mutationKind: TaskMutationKind.deleted,
      eventType: TaskEventType.deleted,
    );
  }

  /// 恢复事项回到 active，不允许物理重建。
  Future<TaskEntity> restoreTask({
    required String taskId,
    DateTime? occurredAt,
  }) async {
    return _transition(
      taskId: taskId,
      occurredAt: occurredAt,
      targetStatus: TaskStatus.active,
      mutationKind: TaskMutationKind.restored,
      eventType: TaskEventType.restored,
    );
  }

  Future<TaskEntity> _transition({
    required String taskId,
    required TaskStatus targetStatus,
    required TaskMutationKind mutationKind,
    required TaskEventType eventType,
    DateTime? occurredAt,
  }) async {
    final TaskEntity currentTask = await _repository.findTaskById(taskId) ??
        (throw StateError('未找到待流转事项: $taskId'));
    final DateTime timestamp = (occurredAt ?? DateTime.now()).toUtc();
    final TaskEntity updatedTask = currentTask.copyWith(
      status: targetStatus,
      updatedAt: timestamp,
      completedAt: targetStatus == TaskStatus.completed ? timestamp : null,
      deletedAt: targetStatus == TaskStatus.deleted ? timestamp : null,
    );

    await _repository.updateTask(updatedTask);
    await _repository.appendEvent(
      TaskEventEntity(
        id: _uuid.v4(),
        taskId: updatedTask.id,
        type: eventType,
        occurredAt: timestamp,
      ),
    );
    await _sideEffectPort.handleTaskMutation(
      task: updatedTask,
      kind: mutationKind,
    );
    return updatedTask;
  }
}
