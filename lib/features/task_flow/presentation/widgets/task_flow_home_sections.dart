import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/presentation/models/task_flow_home_display_model.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 首页加载完成后的组合视图，统一承接头部、主卡、队列与历史摘要。
class TaskFlowHomeLoadedView extends StatelessWidget {
  /// 创建首页组合视图。
  const TaskFlowHomeLoadedView({required this.model, super.key});

  /// 当前首页显示模型。
  final TaskFlowHomeDisplayModel model;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final bool shouldShowHistorySummary = _shouldShowHistorySummary();

    return SingleChildScrollView(
      // 用户要求首页内容尽量贴近底部，这里只保留最小底栏安全余量，不再为 FAB 预留大块空白。
      padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TaskFlowHomeHeader(model: model),
          SizedBox(height: 28.h),
          if (model.priorityTask == null) ...<Widget>[
            if (model.priorityBodyOverride == null) ...<Widget>[
              Text(
                localizations.taskFlowEmptyTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                localizations.taskFlowEmptyBody,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: palette.inkSecondary,
                ),
              ),
            ] else ...<Widget>[
              Text(
                model.priorityBodyOverride!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: palette.inkSecondary,
                ),
              ),
            ],
          ] else ...<Widget>[
            TaskFlowHomePriorityCard(model: model),
            SizedBox(height: 36.h),
            TaskFlowHomeUrgentQueue(model: model),
          ],
          if (shouldShowHistorySummary) ...<Widget>[
            SizedBox(height: 32.h),
            TaskFlowHomeHistorySummary(model: model),
          ],
        ],
      ),
    );
  }

  /// 占位态或带有覆盖文案时，不渲染真实历史摘要，避免把降级说明误判成历史为空。
  bool _shouldShowHistorySummary() {
    return !model.isPlaceholder && model.priorityBodyOverride == null;
  }
}

/// 首页头部负责问候区、轻量指标与右上角壳层操作位。
class TaskFlowHomeHeader extends StatelessWidget {
  /// 创建首页头部。
  const TaskFlowHomeHeader({required this.model, super.key});

  /// 当前首页显示模型。
  final TaskFlowHomeDisplayModel model;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final AppLocalizations localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizations.homeGreetingTitle,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    localizations.homeGreetingSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: palette.inkSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Container(
              key: const Key('task-flow-home-shell-top-action'),
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: palette.surfaceRaised,
                shape: BoxShape.circle,
                border: Border.all(color: palette.lineSoft),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: palette.shadowSoft,
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.more_horiz_rounded,
                color: palette.inkPrimary,
                size: 26.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 首页主任务卡片负责恢复冻结稿里的主焦点层级与底部元信息带。
class TaskFlowHomePriorityCard extends StatelessWidget {
  /// 创建首页主任务卡片。
  const TaskFlowHomePriorityCard({required this.model, super.key});

  /// 当前首页显示模型。
  final TaskFlowHomeDisplayModel model;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final AppLocalizations localizations = AppLocalizations.of(context);
    final TaskEntity? task = model.priorityTask;
    final String title = task?.title ?? localizations.homePriorityTitle;
    final String body =
        model.priorityBodyOverride ??
        _visiblePriorityBody(task, localizations) ??
        localizations.homePriorityBody;
    final String dueLabel = _priorityDueLabel(task, localizations);
    final String secondaryMeta = task?.isPinned == true
        ? localizations.taskFlowPinnedLabel
        : localizations.appTitle;
    final String statusLabel = task?.isPinned == true
        ? localizations.taskFlowPinnedLabel
        : localizations.homePriorityLabel;

    return InkWell(
      borderRadius: BorderRadius.circular(36.r),
      // 主卡点击直接进入编辑页，避免用户还要额外找入口。
      onTap: task == null
          ? null
          : () {
              context.push(
                '${RoutePaths.home}${RoutePaths.taskEditor}?taskId=${task.id}',
              );
            },
      child: ScreenNotePanel(
        key: const Key('task-flow-home-priority-card'),
        padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _PriorityLabelChip(
                    text: localizations.homePriorityLabel,
                  ),
                ),
                SizedBox(width: 16.w),
                Container(
                  width: 68.w,
                  height: 68.w,
                  decoration: BoxDecoration(
                    color: palette.surfaceMuted,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.flag_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 26.h),
            Text(
              title,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.06,
                letterSpacing: -0.8,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              body,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: palette.inkSecondary,
                height: 1.55,
              ),
            ),
            SizedBox(height: 28.h),
            Divider(color: palette.lineSoft, height: 1),
            SizedBox(height: 18.h),
            Row(
              key: const Key('task-flow-home-priority-meta-row'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _MetaItem(icon: Icons.event_outlined, text: dueLabel),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _MetaItem(
                    icon: Icons.view_list_rounded,
                    text: secondaryMeta,
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  key: const Key('task-flow-home-priority-status-chip'),
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: palette.surfaceMuted.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    statusLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 私密事项不直接暴露正文，正文为空时退回统一补充文案。
  String? _visiblePriorityBody(
    TaskEntity? task,
    AppLocalizations localizations,
  ) {
    if (task == null) {
      return null;
    }
    if (task.isPrivate) {
      return localizations.taskFlowPrivateTaskHint;
    }
    if (task.note.trim().isEmpty) {
      return localizations.taskFlowPriorityFallbackBody;
    }
    return task.note.trim();
  }

  /// 主任务时间元信息优先展示截止时间，没有时保持稳定降级文案。
  String _priorityDueLabel(TaskEntity? task, AppLocalizations localizations) {
    final DateTime? dueAt = task?.dueAt?.toLocal();
    if (dueAt == null) {
      return localizations.taskFlowNoDueDate;
    }
    return localizations.taskFlowDueAtLabel(_formatDateTime(dueAt));
  }
}

/// 首页紧急队列负责恢复行式扫描结构，而不是旧的胶囊占位卡片。
class TaskFlowHomeUrgentQueue extends StatelessWidget {
  /// 创建首页紧急队列。
  const TaskFlowHomeUrgentQueue({required this.model, super.key});

  /// 当前首页显示模型。
  final TaskFlowHomeDisplayModel model;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final AppLocalizations localizations = AppLocalizations.of(context);
    final List<TaskEntity?> displayTasks = model.queueTasks.isEmpty
        ? List<TaskEntity?>.filled(3, null)
        : <TaskEntity?>[
            ...model.queueTasks,
            ...List<TaskEntity?>.filled(3 - model.queueTasks.length, null),
          ].take(3).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                localizations.homeQueueTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Divider(color: palette.lineSoft, height: 1),
        ...List<Widget>.generate(displayTasks.length, (int index) {
          final TaskEntity? task = displayTasks[index];
          return _QueueRow(
            key: Key('task-flow-home-queue-row-$index'),
            task: task,
            index: index,
          );
        }),
      ],
    );
  }
}

/// 首页历史状态摘要区只承接完成与删除概览，不抢主任务层级。
class TaskFlowHomeHistorySummary extends StatelessWidget {
  /// 创建首页历史状态摘要区。
  const TaskFlowHomeHistorySummary({required this.model, super.key});

  /// 当前首页显示模型。
  final TaskFlowHomeDisplayModel model;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final bool isHistoryEmpty =
        model.completedCount == 0 && model.deletedCount == 0;

    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.homeHistoryTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            isHistoryEmpty
                ? localizations.homeHistoryEmptyBody
                : localizations.homeHistorySummaryBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: palette.inkSecondary,
            ),
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: <Widget>[
              _HeaderMetricChip(
                text: localizations.homeHistoryCompletedCount(
                  model.completedCount,
                ),
              ),
              _HeaderMetricChip(
                text: localizations.homeHistoryDeletedCount(
                  model.deletedCount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 首页头部统计胶囊只承接弱统计信息，避免抢占主任务注意力。
class _HeaderMetricChip extends StatelessWidget {
  /// 创建头部统计胶囊。
  const _HeaderMetricChip({required this.text});

  /// 胶囊文案。
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: palette.lineSoft),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: palette.inkSecondary,
        ),
      ),
    );
  }
}

/// 主任务标签胶囊保持低噪音，但仍要有稳定的焦点入口感。
class _PriorityLabelChip extends StatelessWidget {
  /// 创建主任务标签胶囊。
  const _PriorityLabelChip({required this.text});

  /// 标签文案。
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F0DE),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

/// 主任务底部元信息项统一图标与文字节奏，避免窄屏或大字号场景下出现轻微溢出。
class _MetaItem extends StatelessWidget {
  /// 创建元信息项。
  const _MetaItem({required this.icon, required this.text});

  /// 元信息图标。
  final IconData icon;

  /// 元信息文案。
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20.sp, color: Theme.of(context).colorScheme.primary),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: palette.inkSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// 行式紧急队列项使用轻分隔结构，点击后直接进入编辑页。
class _QueueRow extends StatelessWidget {
  /// 创建紧急队列行。
  const _QueueRow({
    required super.key,
    required this.task,
    required this.index,
  });

  /// 当前队列任务，空时回落到占位显示。
  final TaskEntity? task;

  /// 当前行索引。
  final int index;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final AppLocalizations localizations = AppLocalizations.of(context);
    final String? taskId = task?.id;
    final String title =
        task?.title ?? localizations.homeQueuePlaceholder(index + 1);
    final String meta = _queueMeta(task, localizations);

    return InkWell(
      // 队列行和主卡共用同一跳转目标，减少首页入口分叉。
      onTap: taskId == null
          ? null
          : () {
              context.push(
                '${RoutePaths.home}${RoutePaths.taskEditor}?taskId=$taskId',
              );
            },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: palette.statusPrivate, width: 2),
                  ),
                  child: Center(
                    child: Icon(
                      task == null
                          ? Icons.circle_outlined
                          : Icons.priority_high_rounded,
                      color: palette.statusPrivate,
                      size: task == null ? 22.sp : 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 18.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        meta,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: palette.statusPrivate,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: palette.inkSecondary.withValues(alpha: 0.75),
                  size: 28.sp,
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Divider(color: palette.lineSoft, height: 1),
          ],
        ),
      ),
    );
  }

  /// 紧急队列元信息优先表达逾期或到期时间，没有真实任务时保留占位时间感。
  String _queueMeta(TaskEntity? task, AppLocalizations localizations) {
    if (task == null) {
      return localizations.taskFlowDueAtLabel(_formatDateTime(DateTime.now()));
    }

    final DateTime? dueAt = task.dueAt?.toLocal();
    if (dueAt == null) {
      return localizations.taskFlowNoDueDate;
    }

    final DateTime current = DateTime.now();
    final DateTime startOfToday = DateTime(
      current.year,
      current.month,
      current.day,
    );
    final DateTime taskDay = DateTime(dueAt.year, dueAt.month, dueAt.day);

    if (taskDay.isBefore(startOfToday)) {
      return localizations.taskFlowOverdueAtLabel(_formatDateTime(dueAt));
    }

    return localizations.taskFlowDueAtLabel(_formatDateTime(dueAt));
  }
}

/// 首页时间格式保持轻量可扫读，不在展示层引入复杂日历语义。
String _formatDateTime(DateTime dateTime) {
  return DateFormat('MMM d, h:mm a').format(dateTime);
}
