import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../services/task_sorting_service.dart';

/// 监听当前事项列表用例。
final class WatchActiveTasksUseCase {
  /// 创建监听当前事项列表用例。
  WatchActiveTasksUseCase({
    required TaskRepository taskRepository,
    required TaskSortingService taskSortingService,
    required DateTime Function() now,
  }) : _taskRepository = taskRepository,
       _taskSortingService = taskSortingService,
       _now = now;

  final TaskRepository _taskRepository;
  final TaskSortingService _taskSortingService;
  final DateTime Function() _now;

  /// 执行监听。
  Stream<List<Task>> call() {
    return _taskRepository.watchAll().map(
      (List<Task> tasks) => _taskSortingService.sortActiveTasks(
        tasks,
        now: _now(),
      ),
    );
  }
}
