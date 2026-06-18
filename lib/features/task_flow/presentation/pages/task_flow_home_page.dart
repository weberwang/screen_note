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
import 'package:screen_note/features/task_flow/presentation/widgets/task_flow_home_status_notice.dart';
import 'package:screen_note/features/task_flow/presentation/widgets/task_queue_row.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 首页底部留白只交给外层安全区和壳层导航处理，这里不再额外叠加视觉空隙。
const double _taskFlowHomeBottomInset = 0;

/// 首页任务流页面只消费稳定快照，不直接改库也不重复推导业务优先级。
class TaskFlowHomePage extends HookConsumerWidget {
  /// 创建首页页面。
  const TaskFlowHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final AsyncValue<TaskFeedSnapshot> snapshotAsync = ref.watch(
      taskFlowHomeControllerProvider,
    );

    return SafeArea(
      child: snapshotAsync.when(
        loading: () => _TaskFlowHomeLoadingState(
          greetingTitle: localizations.homeGreetingTitle,
          todayLabel: localizations.homeTodayChip,
        ),
        error: (Object error, StackTrace stackTrace) => Padding(
          padding: EdgeInsets.fromLTRB(
            24.w,
            16.h,
            24.w,
            _taskFlowHomeBottomInset.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _TaskFlowBrandHeader(appTitle: localizations.appTitle),
              SizedBox(height: 28.h),
              Text(
                localizations.homeGreetingTitle,
                style: theme.textTheme.displaySmall,
              ),
              SizedBox(height: 14.h),
              _HomeContextChip(label: localizations.homeTodayChip),
              SizedBox(height: 28.h),
              ScreenNotePanel(
                child: Text(
                  localizations.taskFlowHomeLoadFailed,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: palette.inkSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (TaskFeedSnapshot snapshot) {
          final TaskEntity? priorityTask = _selectPriorityTask(snapshot);
          final List<TaskEntity> overdueTasks = _buildOverdueQueue(
            snapshot: snapshot,
            priorityTask: priorityTask,
          );
          final List<TaskEntity> upcomingTasks = _buildUpcomingQueue(
            snapshot: snapshot,
            priorityTask: priorityTask,
          );

          return CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  24.w,
                  16.h,
                  24.w,
                  _taskFlowHomeBottomInset.h,
                ),
                sliver: SliverList.list(
                  children: <Widget>[
                    _TaskFlowBrandHeader(appTitle: localizations.appTitle),
                    SizedBox(height: 26.h),
                    Text(
                      localizations.homeGreetingTitle,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontSize: 36.sp,
                        height: 1.06,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _HomeContextChip(label: localizations.homeTodayChip),
                    SizedBox(height: 24.h),
                    TaskFlowHomeStatusNotice(hints: snapshot.degradationHints),
                    if (snapshot.degradationHints.isNotEmpty)
                      SizedBox(height: 20.h),
                    PriorityTaskCard(
                      task: priorityTask,
                      onTap: () =>
                          _openTaskEditor(context, taskId: priorityTask?.id),
                    ),
                    if (overdueTasks.isNotEmpty) ...<Widget>[
                      SizedBox(height: 34.h),
                      ..._buildOverdueSection(
                        context: context,
                        tasks: overdueTasks,
                      ),
                    ],
                    if (upcomingTasks.isNotEmpty) ...<Widget>[
                      SizedBox(height: 26.h),
                      ..._buildUpcomingSection(
                        context: context,
                        tasks: upcomingTasks,
                      ),
                    ],
                    SizedBox(height: 28.h),
                    _TaskFlowSecondarySectionTitle(
                      title: localizations.homeHistoryTitle,
                    ),
                    SizedBox(height: 14.h),
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

  /// 逾期队列只保留除主事项外的逾期任务，保证逾期区标题与语义保持单一。
  List<TaskEntity> _buildOverdueQueue({
    required TaskFeedSnapshot snapshot,
    required TaskEntity? priorityTask,
  }) {
    return snapshot.overdueTasks
        .where((TaskEntity task) => task.id != priorityTask?.id)
        .toList(growable: false);
  }

  /// 后续队列汇总今日和普通任务，但去掉已经进入主卡片或逾期区的事项。
  List<TaskEntity> _buildUpcomingQueue({
    required TaskFeedSnapshot snapshot,
    required TaskEntity? priorityTask,
  }) {
    final Set<String> excludedTaskIds = <String>{
      if (priorityTask != null) priorityTask.id,
      ...snapshot.overdueTasks.map((TaskEntity task) => task.id),
    };

    return <TaskEntity>[...snapshot.todayTasks, ...snapshot.otherTasks]
        .where((TaskEntity task) => !excludedTaskIds.contains(task.id))
        .toList(growable: false);
  }

  /// “接下来” 区域收进整块浅白面板，贴近效果图里的单组任务容器。
  List<Widget> _buildUpcomingSection({
    required BuildContext context,
    required List<TaskEntity> tasks,
  }) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return <Widget>[
      _TaskFlowSectionTitle(title: localizations.taskFlowUpNextSectionTitle),
      SizedBox(height: 12.h),
      ScreenNotePanel(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
        child: Column(
          children: _buildQueueRows(
            context: context,
            tasks: tasks,
            isOverdue: false,
            showChevron: false,
          ),
        ),
      ),
    ];
  }

  /// “逾期” 区域保持高风险识别度，每行独立成浅红卡片以拉开层级。
  List<Widget> _buildOverdueSection({
    required BuildContext context,
    required List<TaskEntity> tasks,
  }) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final List<Widget> widgets = <Widget>[
      _TaskFlowSectionTitle(
        title: localizations.taskFlowOverdueSectionTitle,
        color: Theme.of(context).colorScheme.error,
      ),
      SizedBox(height: 12.h),
    ];

    for (var index = 0; index < tasks.length; index += 1) {
      widgets.add(
        _TaskFlowOverdueQueueCard(
          task: tasks[index],
          onTap: () => _openTaskEditor(context, taskId: tasks[index].id),
        ),
      );
      if (index != tasks.length - 1) {
        widgets.add(SizedBox(height: 12.h));
      }
    }
    return widgets;
  }

  /// 队列行之间统一插入轻分隔线，保持行式结构并按区块需要控制箭头强度。
  List<Widget> _buildQueueRows({
    required BuildContext context,
    required List<TaskEntity> tasks,
    required bool isOverdue,
    required bool showChevron,
  }) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final List<Widget> rows = <Widget>[];

    for (var index = 0; index < tasks.length; index += 1) {
      final TaskEntity task = tasks[index];
      rows.add(
        TaskQueueRow(
          task: task,
          isOverdue: isOverdue,
          showChevron: showChevron,
          onTap: () => _openTaskEditor(context, taskId: task.id),
        ),
      );
      if (index != tasks.length - 1) {
        rows.add(Divider(height: 1, color: palette.lineSoft));
      }
    }
    return rows;
  }

  /// 首页入口统一走共享子路由进入编辑页，避免卡片、列表和 quick add 各自拼接不同路径。
  void _openTaskEditor(BuildContext context, {String? taskId}) {
    final String baseLocation = RoutePaths.taskEditor;
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

/// 首页品牌轻头部只负责表达产品归属，不承接额外业务信息。
final class _TaskFlowBrandHeader extends StatelessWidget {
  /// 创建品牌轻头部。
  const _TaskFlowBrandHeader({required this.appTitle});

  /// 应用标题。
  final String appTitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Row(
      children: <Widget>[
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: palette.surfaceMuted,
            borderRadius: ScreenNoteRadii.insetSurface,
          ),
          alignment: Alignment.center,
          child: Icon(
            // 首页品牌锚点改为更接近设计源的便签图标，避免误读成自然/健康类应用。
            Icons.note_alt_rounded,
            color: theme.colorScheme.primary,
            size: 22.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          appTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// 首页顶部上下文胶囊只负责表达当前时间语义，不参与业务状态推导。
final class _HomeContextChip extends StatelessWidget {
  /// 创建顶部上下文胶囊。
  const _HomeContextChip({required this.label});

  /// 胶囊文案。
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.schedule_rounded,
              size: 15.sp,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 首页分区标题统一收口，避免每个分区各自发明层级和颜色节奏。
final class _TaskFlowSectionTitle extends StatelessWidget {
  /// 创建分区标题。
  const _TaskFlowSectionTitle({required this.title, this.color});

  /// 分区标题文案。
  final String title;

  /// 可选强调色。
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.headlineLarge?.copyWith(
        fontSize: 21.sp,
        color: color ?? theme.textTheme.headlineLarge?.color,
      ),
    );
  }
}

/// 首页加载态保留主要结构锚点，避免加载时页面骨架完全换形。
/// 首页历史状态分区维持次级层级，避免和主任务分区争夺第一屏阅读优先级。
final class _TaskFlowSecondarySectionTitle extends StatelessWidget {
  /// 创建次级分区标题。
  const _TaskFlowSecondarySectionTitle({required this.title});

  /// 次级分区标题文案。
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        color: palette.inkPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// 首页逾期行独立成浅色风险卡片，避免和普通“接下来”列表混成同一层级。
final class _TaskFlowOverdueQueueCard extends StatelessWidget {
  /// 创建首页逾期队列卡片。
  const _TaskFlowOverdueQueueCard({required this.task, this.onTap});

  /// 当前逾期事项。
  final TaskEntity task;

  /// 点击后进入事项编辑。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.error.withValues(alpha: 0.12)
            : const Color(0xFFFFF6F2),
        borderRadius: ScreenNoteRadii.largeSurface,
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.12),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        child: TaskQueueRow(task: task, isOverdue: true, onTap: onTap),
      ),
    );
  }
}

final class _TaskFlowHomeLoadingState extends StatelessWidget {
  /// 创建首页加载态。
  const _TaskFlowHomeLoadingState({
    required this.greetingTitle,
    required this.todayLabel,
  });

  /// 问候标题。
  final String greetingTitle;

  /// 顶部时间胶囊文案。
  final String todayLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24.w,
        16.h,
        24.w,
        _taskFlowHomeBottomInset.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _TaskFlowBrandHeader(appTitle: AppLocalizations.of(context).appTitle),
          SizedBox(height: 26.h),
          Text(
            greetingTitle,
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 36.sp,
              height: 1.06,
            ),
          ),
          SizedBox(height: 16.h),
          _HomeContextChip(label: todayLabel),
          SizedBox(height: 24.h),
          ScreenNotePanel(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              child: Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: 26.h),
          Divider(height: 1, color: palette.lineSoft),
        ],
      ),
    );
  }
}
