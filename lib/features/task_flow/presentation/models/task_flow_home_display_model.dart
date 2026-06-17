import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 首页显示模型只保留展示层真正需要的聚合字段，避免页面直接散用快照分类细节。
class TaskFlowHomeDisplayModel {
  /// 构建首页显示模型。
  const TaskFlowHomeDisplayModel({
    required this.priorityTask,
    required this.queueTasks,
    required this.urgentCount,
    required this.completedCount,
    required this.deletedCount,
    required this.isPlaceholder,
    this.priorityBodyOverride,
  });

  /// 由稳定快照转换首页显示模型。
  factory TaskFlowHomeDisplayModel.fromSnapshot(TaskFeedSnapshot snapshot) {
    final List<TaskEntity> orderedTasks = <TaskEntity>[
      ...snapshot.pinnedTasks,
      ...snapshot.overdueTasks,
      ...snapshot.todayTasks,
      ...snapshot.otherTasks,
    ];
    final TaskEntity? priorityTask = orderedTasks.isEmpty
        ? null
        : orderedTasks.first;
    final List<TaskEntity> queueTasks = orderedTasks
        .where((TaskEntity task) => task.id != priorityTask?.id)
        .take(3)
        .toList(growable: false);

    return TaskFlowHomeDisplayModel(
      priorityTask: priorityTask,
      queueTasks: queueTasks,
      urgentCount: snapshot.overdueTasks.length + snapshot.todayTasks.length,
      completedCount: snapshot.completedCount,
      deletedCount: snapshot.deletedCount,
      isPlaceholder: false,
    );
  }

  /// 当首页还没有真实快照时，使用占位模型保持冻结结构不塌陷。
  factory TaskFlowHomeDisplayModel.placeholder(
    AppLocalizations localizations, {
    String? priorityBodyOverride,
  }) {
    return TaskFlowHomeDisplayModel(
      priorityTask: null,
      queueTasks: const <TaskEntity>[],
      urgentCount: 3,
      completedCount: 0,
      deletedCount: 0,
      isPlaceholder: true,
      priorityBodyOverride: priorityBodyOverride,
    );
  }

  /// 当前主任务。
  final TaskEntity? priorityTask;

  /// 紧急队列任务。
  final List<TaskEntity> queueTasks;

  /// 紧急提醒数。
  final int urgentCount;

  /// 已完成数量。
  final int completedCount;

  /// 已删除数量。
  final int deletedCount;

  /// 是否仍处于占位显示。
  final bool isPlaceholder;

  /// 允许 `loading/error` 时覆写主卡片说明，避免把异常状态拆成独立结构分支。
  final String? priorityBodyOverride;
}
