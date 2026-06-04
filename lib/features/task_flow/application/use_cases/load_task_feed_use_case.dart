import 'package:collection/collection.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';

/// 首页任务流加载用例，负责把 active/completed/deleted 稳定整理成展示快照。
final class LoadTaskFeedUseCase {
  /// 创建加载用例。
  const LoadTaskFeedUseCase({required TaskRepository repository})
    : _repository = repository;

  final TaskRepository _repository;

  /// 读取当前首页快照。
  Future<TaskFeedSnapshot> execute({DateTime? now}) async {
    final DateTime timestamp = now ?? DateTime.now();
    final List<TaskEntity> activeTasks = await _repository.loadTasksByStatus(
      TaskStatus.active,
    );
    final int completedCount = await _repository.countTasksByStatus(
      TaskStatus.completed,
    );
    final int deletedCount = await _repository.countTasksByStatus(
      TaskStatus.deleted,
    );

    final List<TaskEntity> pinnedTasks = <TaskEntity>[];
    final List<TaskEntity> overdueTasks = <TaskEntity>[];
    final List<TaskEntity> todayTasks = <TaskEntity>[];
    final List<TaskEntity> otherTasks = <TaskEntity>[];

    for (final TaskEntity task in activeTasks) {
      if (task.isPinned) {
        pinnedTasks.add(task);
      } else if (_isOverdue(task, timestamp)) {
        overdueTasks.add(task);
      } else if (_isDueToday(task, timestamp)) {
        todayTasks.add(task);
      } else {
        otherTasks.add(task);
      }
    }

    return TaskFeedSnapshot(
      pinnedTasks: _sortByDisplayPriority(pinnedTasks),
      overdueTasks: _sortByDisplayPriority(overdueTasks),
      todayTasks: _sortByDisplayPriority(todayTasks),
      otherTasks: _sortByDisplayPriority(otherTasks),
      activeCount: activeTasks.length,
      completedCount: completedCount,
      deletedCount: deletedCount,
    );
  }

  /// 统一排序规则：先看截止时间，再回退到更新时间，保证列表扫描顺序稳定。
  List<TaskEntity> _sortByDisplayPriority(List<TaskEntity> tasks) {
    return tasks.sorted(
      (TaskEntity left, TaskEntity right) =>
          _compareNullableDate(left.dueAt, right.dueAt) != 0
              ? _compareNullableDate(left.dueAt, right.dueAt)
              : right.updatedAt.compareTo(left.updatedAt),
    );
  }

  /// 判定是否已过期；同一天的事项仍归类为 today，而不是直接算 overdue。
  bool _isOverdue(TaskEntity task, DateTime now) {
    final DateTime? dueAt = task.dueAt?.toLocal();
    if (dueAt == null) {
      return false;
    }

    final DateTime startOfToday = DateTime(now.year, now.month, now.day);
    return dueAt.isBefore(startOfToday);
  }

  /// 判定是否属于今天，用于维持 today 区块的稳定显著性。
  bool _isDueToday(TaskEntity task, DateTime now) {
    final DateTime? dueAt = task.dueAt?.toLocal();
    if (dueAt == null) {
      return false;
    }

    return dueAt.year == now.year &&
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
