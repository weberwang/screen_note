import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/features/history_center/application/providers/history_center_runtime_providers.dart';
import 'package:screen_note/features/history_center/domain/entities/history_center_snapshot.dart';
import 'package:screen_note/features/history_center/presentation/widgets/history_empty_state_panel.dart';
import 'package:screen_note/features/history_center/presentation/widgets/history_section_header.dart';
import 'package:screen_note/features/history_center/presentation/widgets/history_task_row.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 历史中心页面只消费稳定快照与恢复意图，不直接感知数据库或任务真源细节。
class HistoryCenterPage extends HookConsumerWidget {
  /// 创建历史中心页面。
  const HistoryCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<HistoryCenterSnapshot> snapshotAsync = ref.watch(
      historyCenterControllerProvider,
    );

    return SafeArea(
      child: snapshotAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 120.h),
          child: ScreenNotePanel(
            child: Text(
              localizations.historyLoadFailed,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
        data: (HistoryCenterSnapshot snapshot) => CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 120.h),
              sliver: SliverList.list(
                children: <Widget>[
                  Text(
                    localizations.historyTitle,
                    style: theme.textTheme.displaySmall,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    localizations.historySubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF5F6762),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  if (snapshot.isEmpty)
                    HistoryEmptyStatePanel(
                      title: localizations.historyEmptyTitle,
                      body: localizations.historyEmptyBody,
                    )
                  else ...<Widget>[
                    if (snapshot.completedTasks.isNotEmpty) ...<Widget>[
                      HistorySectionHeader.completed(
                        title: localizations.historyCompletedSectionTitle,
                      ),
                      SizedBox(height: 12.h),
                      ..._buildCompletedRows(
                        context: context,
                        tasks: snapshot.completedTasks,
                        localizations: localizations,
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
                      ),
                    ],
                  ],
                ],
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
  }) {
    return tasks
        .map(
          (TaskEntity task) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: HistoryTaskRow.completed(
              task: task,
              metadataText: localizations.historyCompletedAtLabel(
                _formatTimeline(context, task.completedAt ?? task.updatedAt),
              ),
            ),
          ),
        )
        .toList(growable: false);
  }

  /// 生成最近删除分区的事项行，并把恢复动作统一回收到页面控制器。
  List<Widget> _buildDeletedRows({
    required BuildContext context,
    required WidgetRef ref,
    required List<TaskEntity> tasks,
    required AppLocalizations localizations,
  }) {
    return tasks
        .map(
          (TaskEntity task) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: HistoryTaskRow.deleted(
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
          ),
        )
        .toList(growable: false);
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
    return '$date $time';
  }
}
