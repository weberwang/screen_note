import '../../domain/entities/task.dart';
import '../../domain/entities/task_event.dart';
import '../../domain/repositories/task_event_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../../widget_bridge/application/widget_snapshot_refresher.dart';

/// 创建事项入参。
final class CreateTaskInput {
  /// 创建事项入参。
  const CreateTaskInput({
    required this.title,
    this.note,
    this.dueAt,
    this.isPinned = false,
    this.isPrivate = false,
    this.reminderMode = TaskReminderMode.normal,
  });

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

/// 创建事项用例。
final class CreateTaskUseCase {
  /// 创建事项用例。
  CreateTaskUseCase({
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

  /// 执行创建。
  Future<Task> call(CreateTaskInput input) async {
    final String normalizedTitle = input.title.trim();
    if (normalizedTitle.isEmpty) {
      throw StateError('empty_title');
    }

    final DateTime timestamp = _now();
    final Task task = Task(
      id: _idGenerator(),
      title: normalizedTitle,
      note: input.note?.trim().isEmpty ?? true ? null : input.note?.trim(),
      status: TaskStatus.active,
      dueAt: input.dueAt,
      isPinned: input.isPinned,
      isPrivate: input.isPrivate,
      reminderMode: input.reminderMode,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
    await _taskRepository.save(task);
    await _taskEventRepository.save(
      TaskEvent(
        id: _idGenerator(),
        taskId: task.id,
        action: TaskEventAction.create,
        createdAt: timestamp,
      ),
    );
    await _widgetSnapshotRefresher.refresh();
    return task;
  }
}
