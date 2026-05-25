import '../../domain/entities/task.dart';

/// 事项主显示态。
enum TaskDisplayState {
  /// 普通未完成事项。
  active,

  /// 已过期未完成事项。
  overdue,

  /// 今天到期事项。
  today,

  /// 已完成事项。
  completed,

  /// 已删除事项。
  deleted,

  /// 需要遮罩正文的隐私事项。
  privateMasked,
}

/// 事项标签显示类型。
enum TaskStatusChipKind {
  /// 置顶标签。
  pinned,

  /// 过期标签。
  overdue,

  /// 今天标签。
  today,

  /// 隐私标签。
  privateItem,

  /// 已完成标签。
  completed,

  /// 已删除标签。
  deleted,
}

/// 事项显示态解析器。
final class TaskDisplayStateResolver {
  /// 解析事项主显示态。
  TaskDisplayState resolve(
    Task task, {
    required DateTime now,
    bool maskPrivate = false,
  }) {
    if (task.status == TaskStatus.deleted) {
      return TaskDisplayState.deleted;
    }

    if (task.status == TaskStatus.completed) {
      return TaskDisplayState.completed;
    }

    if (maskPrivate && task.isPrivate) {
      return TaskDisplayState.privateMasked;
    }

    if (isOverdue(task, now: now)) {
      return TaskDisplayState.overdue;
    }

    if (isDueToday(task, now: now)) {
      return TaskDisplayState.today;
    }

    return TaskDisplayState.active;
  }

  /// 解析事项标签列表。
  ///
  /// 列表态默认限制最多两个标签，避免卡片视觉信息拥挤。
  List<TaskStatusChipKind> resolveChips(
    Task task, {
    required DateTime now,
    int maxCount = 2,
  }) {
    final List<TaskStatusChipKind> chips = <TaskStatusChipKind>[];
    if (task.isPinned) {
      chips.add(TaskStatusChipKind.pinned);
    }

    if (task.status == TaskStatus.deleted) {
      chips.add(TaskStatusChipKind.deleted);
    } else if (task.status == TaskStatus.completed) {
      chips.add(TaskStatusChipKind.completed);
    } else if (isOverdue(task, now: now)) {
      chips.add(TaskStatusChipKind.overdue);
    } else if (isDueToday(task, now: now)) {
      chips.add(TaskStatusChipKind.today);
    }

    if (task.isPrivate) {
      chips.add(TaskStatusChipKind.privateItem);
    }

    if (chips.length <= maxCount) {
      return List<TaskStatusChipKind>.unmodifiable(chips);
    }

    return List<TaskStatusChipKind>.unmodifiable(chips.take(maxCount));
  }

  /// 是否为已过期未完成事项。
  bool isOverdue(Task task, {required DateTime now}) {
    final DateTime? dueAt = task.dueAt;
    if (dueAt == null || task.status != TaskStatus.active) {
      return false;
    }

    return dueAt.isBefore(now);
  }

  /// 是否为今天到期事项。
  bool isDueToday(Task task, {required DateTime now}) {
    final DateTime? dueAt = task.dueAt;
    if (dueAt == null || task.status != TaskStatus.active) {
      return false;
    }

    return !isOverdue(task, now: now) &&
        dueAt.year == now.year &&
        dueAt.month == now.month &&
        dueAt.day == now.day;
  }
}
