import 'package:uuid/uuid.dart';

import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';

/// 创建事项输入，收口首页快速添加与完整编辑页的共享最小合同。
final class CreateTaskInput {
  /// 创建输入对象。
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

  /// 截止时间。
  final DateTime? dueAt;

  /// 提醒时间。
  final DateTime? reminderAt;

  /// 是否置顶。
  final bool isPinned;

  /// 是否隐私事项。
  final bool isPrivate;

  /// 提醒模式。
  final TaskReminderMode reminderMode;
}

/// 创建事项用例，统一完成校验、落库、日志与副作用编排。
final class CreateTaskUseCase {
  /// 创建用例。
  const CreateTaskUseCase({
    required TaskRepository repository,
    required TaskFlowSideEffectPort sideEffectPort,
    required Uuid uuid,
  }) : _repository = repository,
       _sideEffectPort = sideEffectPort,
       _uuid = uuid;

  final TaskRepository _repository;
  final TaskFlowSideEffectPort _sideEffectPort;
  final Uuid _uuid;

  /// 执行创建逻辑；空白标题一律拒绝，避免无意义空事项污染排序。
  Future<TaskEntity> execute(
    CreateTaskInput input, {
    DateTime? now,
  }) async {
    final String normalizedTitle = input.title.trim();
    if (normalizedTitle.isEmpty) {
      throw ArgumentError.value(input.title, 'title', '事项标题不能为空');
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
      createdAt: timestamp.toUtc(),
      updatedAt: timestamp.toUtc(),
      completedAt: null,
      deletedAt: null,
    );

    await _repository.createTask(task);
    await _repository.appendEvent(
      TaskEventEntity(
        id: _uuid.v4(),
        taskId: task.id,
        type: TaskEventType.created,
        occurredAt: timestamp.toUtc(),
      ),
    );
    await _sideEffectPort.handleTaskMutation(
      task: task,
      kind: TaskMutationKind.created,
    );
    return task;
  }
}
