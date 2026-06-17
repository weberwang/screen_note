import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/presentation/widgets/home_history_status_panel.dart';
import 'package:screen_note/features/task_flow/presentation/widgets/priority_task_card.dart';
import 'package:screen_note/features/task_flow/presentation/widgets/task_queue_row.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 首页任务流页面只消费稳定快照，不直接改库也不重复推导业务优先级。
class TaskFlowHomePage extends HookConsumerWidget {
  /// 创建首页页面。
  const TaskFlowHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<TaskFeedSnapshot> snapshotAsync = ref.watch(
      taskFlowHomeControllerProvider,
    );

    return SafeArea(
      child: snapshotAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              localizations.taskFlowHomeLoadFailed,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (TaskFeedSnapshot snapshot) {
          final TaskEntity? priorityTask = _selectPriorityTask(snapshot);
          final List<TaskEntity> urgentQueue = _buildUrgentQueue(
            snapshot: snapshot,
            priorityTask: priorityTask,
          );

          return CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 120.h),
                sliver: SliverList.list(
                  children: <Widget>[
                    Text(
                      localizations.homeGreetingTitle,
                      style: theme.textTheme.displaySmall,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      localizations.homeGreetingSubtitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    PriorityTaskCard(
                      task: priorityTask,
                      onTap: priorityTask == null
                          ? null
                          : () => _openTaskEditor(
                              context,
                              taskId: priorityTask.id,
                            ),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      localizations.homeQueueTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 16.h),
                    ...urgentQueue.map((TaskEntity task) {
                      final bool isOverdue = snapshot.overdueTasks.any(
                        (TaskEntity item) => item.id == task.id,
                      );
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: TaskQueueRow(
                          task: task,
                          isOverdue: isOverdue,
                          onTap: () => _openTaskEditor(
                            context,
                            taskId: task.id,
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 20.h),
                    Text(
                      localizations.homeHistoryTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 16.h),
                    HomeHistoryStatusPanel(
                      completedCount: snapshot.completedCount,
                      deletedCount: snapshot.deletedCount,
                      onTap: () => _openHistoryCenter(context),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 首页主事项优先取置顶，其次回退到逾期、今日和其他事项，保证第一视觉始终有明确焦点。
  TaskEntity? _selectPriorityTask(TaskFeedSnapshot snapshot) {
    return snapshot.pinnedTasks.firstOrNull ??
        snapshot.overdueTasks.firstOrNull ??
        snapshot.todayTasks.firstOrNull ??
        snapshot.otherTasks.firstOrNull;
  }

  /// 紧急队列只展示次级高优先项，并去掉已占据主卡片的那一条，避免首页重复朗读同一事项。
  List<TaskEntity> _buildUrgentQueue({
    required TaskFeedSnapshot snapshot,
    required TaskEntity? priorityTask,
  }) {
    final List<TaskEntity> urgentQueue = <TaskEntity>[
      ...snapshot.overdueTasks,
      ...snapshot.todayTasks,
    ];
    if (priorityTask == null) {
      return urgentQueue;
    }
    return urgentQueue
        .where((TaskEntity task) => task.id != priorityTask.id)
        .toList(growable: false);
  }

  /// 首页入口统一走共享子路由进入编辑页，避免卡片、列表和 quick add 各自拼接不同路径。
  void _openTaskEditor(BuildContext context, {String? taskId}) {
    final String baseLocation = '${RoutePaths.home}${RoutePaths.taskEditor}';
    final String location = taskId == null
        ? baseLocation
        : '$baseLocation?taskId=$taskId';
    context.push(location);
  }

  /// 首页历史状态入口统一切到历史中心分支，避免局部组件各自拼接导航目标。
  void _openHistoryCenter(BuildContext context) {
    context.go(RoutePaths.history);
  }
}
