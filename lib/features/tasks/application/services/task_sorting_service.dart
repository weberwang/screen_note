import '../../domain/entities/task.dart';

/// 事项排序服务。
final class TaskSortingService {
  /// 对当前事项进行展示排序。
  ///
  /// 这里把排序规则统一固化在应用层，避免页面、小组件或通知各自实现一套顺序。
  List<Task> sortActiveTasks(Iterable<Task> tasks, {required DateTime now}) {
    final List<Task> activeTasks = tasks
        .where((Task task) => task.status == TaskStatus.active)
        .toList(growable: false);
    final List<Task> sorted = List<Task>.of(activeTasks);

    sorted.sort((Task left, Task right) {
      final int priorityCompare = _priority(left, now).compareTo(
        _priority(right, now),
      );
      if (priorityCompare != 0) {
        return priorityCompare;
      }

      final int dueCompare = _compareNullableDate(left.dueAt, right.dueAt);
      if (dueCompare != 0) {
        return dueCompare;
      }

      return right.createdAt.compareTo(left.createdAt);
    });

    return List<Task>.unmodifiable(sorted);
  }

  /// 对最近完成列表做倒序排序。
  List<Task> sortCompletedTasks(Iterable<Task> tasks) {
    final List<Task> completedTasks = tasks
        .where((Task task) => task.status == TaskStatus.completed)
        .toList();

    completedTasks.sort((Task left, Task right) {
      final DateTime leftTime = left.completedAt ?? left.updatedAt;
      final DateTime rightTime = right.completedAt ?? right.updatedAt;
      return rightTime.compareTo(leftTime);
    });

    return List<Task>.unmodifiable(completedTasks);
  }

  /// 对最近删除列表做倒序排序。
  List<Task> sortDeletedTasks(Iterable<Task> tasks) {
    final List<Task> deletedTasks = tasks
        .where((Task task) => task.status == TaskStatus.deleted)
        .toList();

    deletedTasks.sort((Task left, Task right) {
      final DateTime leftTime = left.deletedAt ?? left.updatedAt;
      final DateTime rightTime = right.deletedAt ?? right.updatedAt;
      return rightTime.compareTo(leftTime);
    });

    return List<Task>.unmodifiable(deletedTasks);
  }

  int _priority(Task task, DateTime now) {
    if (task.isPinned) {
      return 0;
    }

    if (_isOverdue(task, now)) {
      return 1;
    }

    if (_isDueToday(task, now)) {
      return 2;
    }

    // PRD 中“无截止但手动置顶”与全局置顶存在语义重叠，这里统一并入最高优先级桶，
    // 避免在 UI 层继续人为分叉。
    return 4;
  }

  bool _isOverdue(Task task, DateTime now) {
    final DateTime? dueAt = task.dueAt;
    if (dueAt == null) {
      return false;
    }

    return task.status == TaskStatus.active && dueAt.isBefore(now);
  }

  bool _isDueToday(Task task, DateTime now) {
    final DateTime? dueAt = task.dueAt;
    if (dueAt == null || task.status != TaskStatus.active) {
      return false;
    }

    return !_isOverdue(task, now) &&
        dueAt.year == now.year &&
        dueAt.month == now.month &&
        dueAt.day == now.day;
  }

  int _compareNullableDate(DateTime? left, DateTime? right) {
    if (left == null && right == null) {
      return 0;
    }

    if (left == null) {
      return 1;
    }

    if (right == null) {
      return -1;
    }

    return left.compareTo(right);
  }
}
