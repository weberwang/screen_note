import '../../domain/entities/task.dart';
import '../../domain/entities/task_event.dart';
import '../../domain/repositories/task_event_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../../widget_bridge/application/widget_snapshot_refresher.dart';

/// 完成事项用例。
final class CompleteTaskUseCase {
  /// 创建完成事项用例。
  CompleteTaskUseCase({
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

  /// 执行完成。
  Future<Task> call(String taskId) async {
    final Task existingTask = await _loadExisting(taskId);
    final DateTime timestamp = _now();
    final Task completedTask = existingTask.copyWith(
      status: TaskStatus.completed,
      updatedAt: timestamp,
      completedAt: timestamp,
      deletedAt: null,
    );
    await _taskRepository.save(completedTask);
    await _taskEventRepository.save(
      TaskEvent(
        id: _idGenerator(),
        taskId: taskId,
        action: TaskEventAction.complete,
        createdAt: timestamp,
      ),
    );
    await _widgetSnapshotRefresher.refresh();
    return completedTask;
  }

  Future<Task> _loadExisting(String id) async {
    final Task? task = await _taskRepository.findById(id);
    if (task == null) {
      throw StateError('task_not_found');
    }

    return task;
  }
}
