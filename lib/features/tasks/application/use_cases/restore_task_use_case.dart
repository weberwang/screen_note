import '../../domain/entities/task.dart';
import '../../domain/entities/task_event.dart';
import '../../domain/repositories/task_event_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../../widget_bridge/application/widget_refresh_guard.dart';
import '../../../widget_bridge/application/widget_snapshot_refresher.dart';

/// 恢复事项用例。
final class RestoreTaskUseCase {
  /// 创建恢复事项用例。
  RestoreTaskUseCase({
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

  /// 执行恢复。
  Future<Task> call(String taskId) async {
    final Task existingTask = await _loadExisting(taskId);
    final DateTime timestamp = _now();
    final Task restoredTask = existingTask.copyWith(
      status: TaskStatus.active,
      updatedAt: timestamp,
      completedAt: null,
      deletedAt: null,
    );
    await _taskRepository.save(restoredTask);
    await _taskEventRepository.save(
      TaskEvent(
        id: _idGenerator(),
        taskId: taskId,
        action: TaskEventAction.restore,
        createdAt: timestamp,
      ),
    );
    // 恢复成功后必须优先保证事项重新可用，Widget 同步失败只能记录日志。
    await runNonBlockingWidgetRefresh(
      refresher: _widgetSnapshotRefresher,
      actionName: 'restore_task',
    );
    return restoredTask;
  }

  Future<Task> _loadExisting(String id) async {
    final Task? task = await _taskRepository.findById(id);
    if (task == null) {
      throw StateError('task_not_found');
    }

    return task;
  }
}
