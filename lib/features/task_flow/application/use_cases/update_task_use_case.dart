import 'package:uuid/uuid.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';

/// 事项编辑输入，统一承接编辑页提交的可变字段。
final class UpdateTaskInput {
  /// 创建编辑输入。
  const UpdateTaskInput({
    required this.taskId,
    required this.title,
    required this.note,
    required this.isPinned,
    required this.isPrivate,
  });

  /// 目标事项 ID。
  final String taskId;

  /// 编辑后的标题。
  final String title;

  /// 编辑后的备注。
  final String note;

  /// 编辑后的置顶状态。
  final bool isPinned;

  /// 编辑后的隐私状态。
  final bool isPrivate;
}

/// 事项更新用例，负责读取既有实体并只更新允许编辑的字段。
final class UpdateTaskUseCase {
  /// 创建事项更新用例。
  const UpdateTaskUseCase({
    required TaskRepository repository,
    required Uuid uuid,
  }) : _repository = repository,
       _uuid = uuid;

  final TaskRepository _repository;
  final Uuid _uuid;

  /// 执行更新逻辑，标题为空时直接拒绝，避免把无效数据写回仓储。
  Future<TaskEntity> execute(UpdateTaskInput input, {DateTime? now}) async {
    final String normalizedTitle = input.title.trim();
    if (normalizedTitle.isEmpty) {
      throw ArgumentError.value(input.title, 'title', '事项标题不能为空');
    }

    final TaskEntity currentTask = await _repository.findTaskById(input.taskId) ??
        (throw StateError('未找到待更新事项: ${input.taskId}'));
    final DateTime timestamp = (now ?? DateTime.now()).toUtc();
    final TaskEntity updatedTask = currentTask.copyWith(
      title: normalizedTitle,
      note: input.note.trim(),
      isPinned: input.isPinned,
      isPrivate: input.isPrivate,
      updatedAt: timestamp,
    );

    await _repository.updateTask(updatedTask);
    await _repository.appendEvent(
      TaskEventEntity(
        id: _uuid.v4(),
        taskId: updatedTask.id,
        type: TaskEventType.updated,
        occurredAt: timestamp,
      ),
    );
    return updatedTask;
  }
}
