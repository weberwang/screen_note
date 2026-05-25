import '../../domain/entities/task.dart';
import '../../domain/entities/task_event.dart';
import '../../domain/repositories/task_event_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../../widget_bridge/application/widget_snapshot_refresher.dart';

/// 更新事项入参。
final class UpdateTaskInput {
  /// 更新事项入参。
  const UpdateTaskInput({
    required this.id,
    required this.title,
    this.note,
    this.dueAt,
    required this.isPinned,
    required this.isPrivate,
    required this.reminderMode,
  });

  /// 事项 ID。
  final String id;

  /// 标题。
  final String title;

  /// 备注。
  final String? note;

  /// 截止时间。
  final DateTime? dueAt;

  /// 是否置顶。
  final bool isPinned;

  /// 是否隐私事项。
  final bool isPrivate;

  /// 提醒模式。
  final TaskReminderMode reminderMode;
}

/// 更新事项用例。
final class UpdateTaskUseCase {
  /// 创建更新事项用例。
  UpdateTaskUseCase({
    required TaskRepository taskRepository,
    required TaskEventRepository taskEventRepository,
    required WidgetSnapshotRefresher widgetSnapshotRefresher,
    required DateTime Function() now,
    required String Function() idGenerator,
  }) : _taskRepository = taskRepository,
       _taskEventRepository = taskEventRepository,
       _widgetSnapshotRefresher = widgetSnapshotRefresher,
       _now = now,
       _idGenerator = idGenerator;

  final TaskRepository _taskRepository;
  final TaskEventRepository _taskEventRepository;
  final WidgetSnapshotRefresher _widgetSnapshotRefresher;
  final DateTime Function() _now;
  final String Function() _idGenerator;

  /// 执行更新。
  Future<Task> call(UpdateTaskInput input) async {
    final Task existingTask = await _loadExisting(input.id);
    final String normalizedTitle = input.title.trim();
    if (normalizedTitle.isEmpty) {
      throw StateError('empty_title');
    }

    final DateTime timestamp = _now();
    final Task updatedTask = existingTask.copyWith(
      title: normalizedTitle,
      note: input.note?.trim().isEmpty ?? true ? null : input.note?.trim(),
      dueAt: input.dueAt,
      isPinned: input.isPinned,
      isPrivate: input.isPrivate,
      reminderMode: input.reminderMode,
      updatedAt: timestamp,
    );
    await _taskRepository.save(updatedTask);
    await _taskEventRepository.save(
      TaskEvent(
        id: _idGenerator(),
        taskId: updatedTask.id,
        action: TaskEventAction.update,
        createdAt: timestamp,
      ),
    );
    await _widgetSnapshotRefresher.refresh();
    return updatedTask;
  }

  Future<Task> _loadExisting(String id) async {
    final Task? task = await _taskRepository.findById(id);
    if (task == null) {
      throw StateError('task_not_found');
    }

    return task;
  }
}
