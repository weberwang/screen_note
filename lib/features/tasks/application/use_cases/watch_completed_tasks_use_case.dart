import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../services/task_sorting_service.dart';

/// 监听最近完成列表用例。
final class WatchCompletedTasksUseCase {
  /// 创建监听最近完成列表用例。
  WatchCompletedTasksUseCase({
    required TaskRepository taskRepository,
    required TaskSortingService taskSortingService,
  }) : _taskRepository = taskRepository,
       _taskSortingService = taskSortingService;

  final TaskRepository _taskRepository;
  final TaskSortingService _taskSortingService;

  /// 执行监听。
  Stream<List<Task>> call() {
    return _taskRepository.watchAll().map(_taskSortingService.sortCompletedTasks);
  }
}
