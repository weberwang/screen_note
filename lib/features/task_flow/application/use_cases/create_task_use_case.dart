import 'package:uuid/uuid.dart';

import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';

/// 创建事项输入，只暴露当前 Task 1 需要的最小字段集。
final class CreateTaskInput {
  /// 创建创建事项输入。
  const CreateTaskInput({
    required this.title,
    required this.note,
    this.dueAt,
    this.reminderAt,
    this.isPinned = false,
    this.isPrivate = false,
    this.reminderMode = TaskReminderMode.normal,
  });

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

/// 创建事项用例，负责校验输入、落库并写入首条操作日志。
final class CreateTaskUseCase {
  /// 创建创建事项用例。
  const CreateTaskUseCase({
    required TaskMutationRepository repository,
    required TaskFlowSideEffectPort sideEffectPort,
    required Uuid uuid,
  }) : _repository = repository,
       _sideEffectPort = sideEffectPort,
       _uuid = uuid;

  final TaskMutationRepository _repository;
  final TaskFlowSideEffectPort _sideEffectPort;
  final Uuid _uuid;

  /// 执行创建。
  Future<TaskEntity> execute(CreateTaskInput input, {DateTime? now}) async {
    final String normalizedTitle = input.title.trim();
    if (normalizedTitle.isEmpty) {
      throw ArgumentError.value(input.title, 'title', '标题不能为空');
    }

    final DateTime timestamp = now ?? DateTime.now();
    final TaskEntity task = TaskEntity(
      id: _uuid.v4(),
      title: normalizedTitle,
      note: input.note.trim(),
      dueAt: input.dueAt,
      reminderAt: input.reminderAt,
      isPinned: input.isPinned,
      isPrivate: input.isPrivate,
      status: TaskStatus.active,
      reminderMode: input.reminderMode,
      createdAt: timestamp,
      updatedAt: timestamp,
      completedAt: null,
      deletedAt: null,
    );
    final TaskEventEntity event = TaskEventEntity(
      id: _uuid.v4(),
      taskId: task.id,
      type: 'created',
      fromStatus: TaskStatus.active,
      toStatus: TaskStatus.active,
      occurredAt: timestamp,
    );

    await _repository.createTaskWithEvent(task: task, event: event);
    await _sideEffectPort.onTaskCreated(task);
    return task;
  }
}
