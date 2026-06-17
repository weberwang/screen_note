import 'package:collection/collection.dart';

import 'package:screen_note/features/task_flow/application/ports/task_flow_degradation_hint_source.dart';
import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_flow_degradation_hint.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';

/// 首页任务流加载用例，统一输出稳定分组快照，禁止页面层重复推导。
final class LoadTaskFeedUseCase {
  /// 创建加载用例。
  const LoadTaskFeedUseCase({
    required TaskRepository repository,
    TaskFlowDegradationHintSource? degradationHintSource,
    TaskFlowSideEffectPort? sideEffectPort,
  }) : _repository = repository,
       _degradationHintSource = degradationHintSource,
       _sideEffectPort = sideEffectPort;

  final TaskRepository _repository;
  final TaskFlowDegradationHintSource? _degradationHintSource;
  final TaskFlowSideEffectPort? _sideEffectPort;

  /// 读取首页任务快照。
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
    final List<TaskFlowDegradationHint> degradationHints =
        await _degradationHintSource?.loadHints() ??
        const <TaskFlowDegradationHint>[];

    final List<TaskEntity> pinnedTasks = _sortByDisplayPriority(
      activeTasks.where((TaskEntity task) => task.isPinned).toList(),
    );
    final List<TaskEntity> overdueTasks = _sortByDisplayPriority(
      activeTasks
          .where((TaskEntity task) => _isOverdue(task, timestamp))
          .toList(),
    );
    final List<TaskEntity> todayTasks = _sortByDisplayPriority(
      activeTasks
          .where((TaskEntity task) => _isDueToday(task, timestamp))
          .toList(),
    );
    final List<TaskEntity> otherTasks = _sortByDisplayPriority(
      activeTasks
          .where(
            (TaskEntity task) =>
                !task.isPinned &&
                !_isOverdue(task, timestamp) &&
                !_isDueToday(task, timestamp),
          )
          .toList(),
    );

    final TaskFeedSnapshot snapshot = TaskFeedSnapshot(
      pinnedTasks: pinnedTasks,
      overdueTasks: overdueTasks,
      todayTasks: todayTasks,
      otherTasks: otherTasks,
      activeCount: activeTasks.length,
      completedCount: completedCount,
      deletedCount: deletedCount,
      degradationHints: degradationHints,
    );

    if (_sideEffectPort != null) {
      await _sideEffectPort.onTaskFeedLoaded(snapshot);
    }
    return snapshot;
  }

  /// 首页排序优先考虑更早到期时间，再用最近更新时间打破并列。
  List<TaskEntity> _sortByDisplayPriority(List<TaskEntity> tasks) {
    return tasks.sorted((TaskEntity left, TaskEntity right) {
      final int dueCompare = _compareNullableDate(left.dueAt, right.dueAt);
      if (dueCompare != 0) {
        return dueCompare;
      }
      return right.updatedAt.compareTo(left.updatedAt);
    });
  }

  /// 逾期只按日期派生，避免当天晚些时候的事项被过早打成风险态。
  bool _isOverdue(TaskEntity task, DateTime now) {
    final DateTime? dueAt = task.dueAt;
    if (task.isPinned || dueAt == null) {
      return false;
    }
    final DateTime startOfToday = DateTime(now.year, now.month, now.day);
    return dueAt.isBefore(startOfToday);
  }

  /// 今日事项按自然日归类，不把时间粒度暴露给页面层重复判断。
  bool _isDueToday(TaskEntity task, DateTime now) {
    final DateTime? dueAt = task.dueAt;
    if (task.isPinned || dueAt == null) {
      return false;
    }
    return dueAt.year == now.year &&
        dueAt.month == now.month &&
        dueAt.day == now.day;
  }

  /// 空日期永远排在已设置日期之后，保持明确时间的事项优先出队。
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
