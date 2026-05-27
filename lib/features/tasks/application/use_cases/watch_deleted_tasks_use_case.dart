import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../services/task_sorting_service.dart';

/// 最近删除保留天数。
const int deletedRetentionDays = 30;

/// 监听最近删除列表用例。
final class WatchDeletedTasksUseCase {
  /// 创建监听最近删除列表用例。
  WatchDeletedTasksUseCase({
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
    return _taskRepository.watchAll().map((List<Task> tasks) {
      final DateTime now = _now();
      final Iterable<Task> retained = tasks.where(
        (Task task) => _isWithinRetention(task, now),
      );
      return _taskSortingService.sortDeletedTasks(retained);
    });
  }

  /// 计算剩余保留天数。
  int remainingDays(Task task, {required DateTime now}) {
    final DateTime? deletedAt = task.deletedAt;
    if (deletedAt == null) {
      return deletedRetentionDays;
    }

    final DateTime expireAt = deletedAt.add(
      const Duration(days: deletedRetentionDays),
    );
    final Duration difference = expireAt.difference(now);
    if (difference.isNegative) {
      return 0;
    }

    return difference.inDays + (difference.inHours % 24 == 0 ? 0 : 1);
  }

  bool _isWithinRetention(Task task, DateTime now) {
    final DateTime? deletedAt = task.deletedAt;
    if (task.status != TaskStatus.deleted || deletedAt == null) {
      return false;
    }

    return deletedAt.add(const Duration(days: deletedRetentionDays)).isAfter(now);
  }
}
