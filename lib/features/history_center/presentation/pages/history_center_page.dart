import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/history_center/application/providers/history_center_runtime_providers.dart';
import 'package:screen_note/features/history_center/domain/entities/history_center_snapshot.dart';
import 'package:screen_note/features/history_center/presentation/widgets/history_empty_state_panel.dart';
import 'package:screen_note/features/history_center/presentation/widgets/history_section_header.dart';
import 'package:screen_note/features/history_center/presentation/widgets/history_task_row.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 历史中心页面只消费稳定快照与恢复意图，不直接感知数据库或任务真源细节。
class HistoryCenterPage extends HookConsumerWidget {
  /// 创建历史中心页面。
  const HistoryCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final AsyncValue<HistoryCenterSnapshot> snapshotAsync = ref.watch(
      historyCenterControllerProvider,
    );

    return SafeArea(
      child: snapshotAsync.when(
        loading: () => const _HistoryCenterLoadingState(),
        error: (Object error, StackTrace stackTrace) => Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                localizations.historyTitle,
                style: theme.textTheme.displaySmall?.copyWith(fontSize: 40.sp),
              ),
              SizedBox(height: 24.h),
              ScreenNotePanel(
                child: Text(
                  localizations.historyLoadFailed,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: palette.inkSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (HistoryCenterSnapshot snapshot) => CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, snapshot.isEmpty ? 0 : 36.h),
              sliver: SliverList.list(
                children: <Widget>[
                  Text(
                    localizations.historyTitle,
                    style: theme.textTheme.displaySmall?.copyWith(fontSize: 40.sp),
                  ),
                  if (!snapshot.isEmpty) ...<Widget>[
                    SizedBox(height: 24.h),
                    if (snapshot.completedTasks.isNotEmpty) ...<Widget>[
                      HistorySectionHeader.completed(
                        title: localizations.historyCompletedSectionTitle,
                      ),
                      SizedBox(height: 12.h),
                      ..._buildCompletedRows(
                        context: context,
                        tasks: snapshot.completedTasks,
                        localizations: localizations,
                        dividerColor: palette.lineSoft,
                      ),
                      SizedBox(height: 24.h),
                    ],
                    if (snapshot.deletedTasks.isNotEmpty) ...<Widget>[
                      HistorySectionHeader.deleted(
                        title: localizations.historyDeletedSectionTitle,
                      ),
                      SizedBox(height: 12.h),
                      ..._buildDeletedRows(
                        context: context,
                        ref: ref,
                        tasks: snapshot.deletedTasks,
                        localizations: localizations,
                        dividerColor: palette.lineSoft,
                      ),
                    ],
                  ],
                ],
              ),
            ),
            if (snapshot.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 56.h),
                  child: HistoryEmptyStatePanel(
                    title: localizations.historyEmptyTitle,
                    body: localizations.historyEmptyBody,
                    addActionTooltip: localizations.historyEmptyAddAction,
                    onAddTap: () => context.push(RoutePaths.taskEditor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 生成最近完成分区的只读事项行，保持时间线线索清楚但不引入额外操作。
  List<Widget> _buildCompletedRows({
    required BuildContext context,
    required List<TaskEntity> tasks,
    required AppLocalizations localizations,
    required Color dividerColor,
  }) {
    final List<Widget> rows = <Widget>[];
    for (var index = 0; index < tasks.length; index += 1) {
      final TaskEntity task = tasks[index];
      rows.add(
        HistoryTaskRow.completed(
          task: task,
          metadataText: localizations.historyCompletedAtLabel(
            _formatTimeline(context, task.completedAt ?? task.updatedAt),
          ),
        ),
      );
      if (index != tasks.length - 1) {
        rows.add(Divider(height: 1, color: dividerColor));
      }
    }
    return rows;
  }

  /// 生成最近删除分区的事项行，并把恢复动作统一回收到页面控制器。
  List<Widget> _buildDeletedRows({
    required BuildContext context,
    required WidgetRef ref,
    required List<TaskEntity> tasks,
    required AppLocalizations localizations,
    required Color dividerColor,
  }) {
    final List<Widget> rows = <Widget>[];
    for (var index = 0; index < tasks.length; index += 1) {
      final TaskEntity task = tasks[index];
      rows.add(
        HistoryTaskRow.deleted(
          task: task,
          metadataText: localizations.historyDeletedAtLabel(
            _formatTimeline(context, task.deletedAt ?? task.updatedAt),
          ),
          restoreLabel: localizations.historyRestoreAction,
          onRestore: () => ref
              .read(historyCenterControllerProvider.notifier)
              .restoreTask(
                taskId: task.id,
                successMessage: localizations.historyRestoreSuccess,
              ),
        ),
      );
      if (index != tasks.length - 1) {
        rows.add(Divider(height: 1, color: dividerColor));
      }
    }
    return rows;
  }

  /// 统一格式化历史页时间元信息，避免完成与删除分区各自拼接日期字符串。
  String _formatTimeline(BuildContext context, DateTime dateTime) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final String date = localizations.formatMediumDate(dateTime);
    final String time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(dateTime),
      alwaysUse24HourFormat: false,
    );
    return '$date • $time';
  }
}

/// 历史页加载态保留标题和分区锚点，避免加载中整体骨架完全换形。
final class _HistoryCenterLoadingState extends StatelessWidget {
  /// 创建历史页加载态。
  const _HistoryCenterLoadingState();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).historyTitle,
            style: theme.textTheme.displaySmall?.copyWith(fontSize: 40.sp),
          ),
          SizedBox(height: 24.h),
          HistorySectionHeader.completed(
            title: AppLocalizations.of(context).historyCompletedSectionTitle,
          ),
          SizedBox(height: 12.h),
          ScreenNotePanel(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Divider(height: 1, color: palette.lineSoft),
        ],
      ),
    );
  }
}
