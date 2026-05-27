import '../../domain/entities/task.dart';
import '../../domain/entities/task_event.dart';
import '../../domain/repositories/task_event_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../../widget_bridge/application/widget_refresh_guard.dart';
import '../../../widget_bridge/application/widget_snapshot_refresher.dart';

/// 删除事项用例。
final class DeleteTaskUseCase {
  /// 创建删除事项用例。
  DeleteTaskUseCase({
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

  /// 执行软删除。
  Future<Task> call(String taskId) async {
    final Task existingTask = await _loadExisting(taskId);
    final DateTime timestamp = _now();
    final Task deletedTask = existingTask.copyWith(
      status: TaskStatus.deleted,
      updatedAt: timestamp,
      deletedAt: timestamp,
    );
    await _taskRepository.save(deletedTask);
    await _taskEventRepository.save(
      TaskEvent(
        id: _idGenerator(),
        taskId: taskId,
        action: TaskEventAction.delete,
        createdAt: timestamp,
      ),
    );
    // 软删除成功后，Widget 刷新异常只允许降级，不能阻断最近删除保留链路。
    await runNonBlockingWidgetRefresh(
      refresher: _widgetSnapshotRefresher,
      actionName: 'delete_task',
    );
    return deletedTask;
  }

  Future<Task> _loadExisting(String id) async {
    final Task? task = await _taskRepository.findById(id);
    if (task == null) {
      throw StateError('task_not_found');
    }

    return task;
  }
}
