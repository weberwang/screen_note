import 'package:uuid/uuid.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';

/// 更新事项输入，统一承接编辑页允许提交的最小字段集。
final class UpdateTaskInput {
  /// 创建更新事项输入。
  const UpdateTaskInput({
    required this.taskId,
    required this.title,
    required this.note,
    this.dueAt,
    this.reminderAt,
    this.isPinned = false,
    this.isPrivate = false,
    this.reminderMode = TaskReminderMode.normal,
  });

  /// 目标事项 ID。
  final String taskId;

  /// 标题。
  final String title;

  /// 备注。
  final String note;

  /// 到期时间。
  final DateTime? dueAt;

  /// 提醒时间。
  final DateTime? reminderAt;

  /// 是否置顶。
  final bool isPinned;

  /// 是否私密。
  final bool isPrivate;

  /// 提醒模式。
  final TaskReminderMode reminderMode;
}

/// 更新事项用例统一承接编辑态保存，确保保住原事项身份且不误走新建链路。
final class UpdateTaskUseCase {
  /// 创建更新事项用例。
  const UpdateTaskUseCase({
    required TaskMutationRepository repository,
    required Uuid uuid,
  }) : _repository = repository,
       _uuid = uuid;

  final TaskMutationRepository _repository;
  final Uuid _uuid;

  /// 执行更新。
  Future<TaskEntity> execute(UpdateTaskInput input, {DateTime? now}) async {
    final String normalizedTitle = input.title.trim();
    if (normalizedTitle.isEmpty) {
      throw ArgumentError.value(input.title, 'title', '标题不能为空');
    }

    final TaskEntity? existingTask = await _repository.findTaskById(input.taskId);
    if (existingTask == null) {
      throw StateError('事项不存在，无法更新');
    }

    final DateTime timestamp = now ?? DateTime.now();
    final TaskEntity updatedTask = existingTask.copyWith(
      title: normalizedTitle,
      note: input.note.trim(),
      dueAt: input.dueAt,
      reminderAt: input.reminderAt,
      isPinned: input.isPinned,
      isPrivate: input.isPrivate,
      reminderMode: input.reminderMode,
      updatedAt: timestamp,
    );
    final TaskEventEntity event = TaskEventEntity(
      id: _uuid.v4(),
      taskId: existingTask.id,
      type: 'edited',
      fromStatus: existingTask.status,
      toStatus: existingTask.status,
      occurredAt: timestamp,
    );

    await _repository.updateTaskWithEvent(task: updatedTask, event: event);
    return updatedTask;
  }
}
