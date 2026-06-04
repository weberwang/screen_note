import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/utils/date_time_formatter.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/widgets/task_surface_panel.dart';

/// 任务详情与编辑页共用的锁屏预览卡。
///
/// 这里把“显示内容 / 隐藏内容”的结果直接可视化，
/// 避免用户切换隐私后还要靠想象判断锁屏会展示什么。
class TaskPrivacyPreviewCard extends StatelessWidget {
  /// 创建锁屏预览卡。
  const TaskPrivacyPreviewCard({
    super.key,
    required this.title,
    required this.isPrivate,
    required this.dueAt,
    this.reminderMode = TaskReminderMode.normal,
  });

  /// 当前事项标题。
  final String title;

  /// 是否启用隐私模式。
  final bool isPrivate;

  /// 当前截止时间。
  final DateTime? dueAt;

  /// 当前提醒模式。
  final TaskReminderMode reminderMode;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final String previewTitle = title.trim().isEmpty
        ? localizations.quickInputPlaceholder
        : title.trim();
    final String dueText = dueAt == null
        ? localizations.taskDueEmpty
        : ScreenNoteDateTimeFormatter.formatDateTime(dueAt!);

    return TaskSurfacePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.taskPreviewTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            localizations.widgetPreviewDefaultBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: palette.surfaceFocusCard,
                    borderRadius: ScreenNoteRadii.card,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        isPrivate
                            ? Icons.lock_outline_rounded
                            : Icons.notifications_none_rounded,
                        color: palette.inkOnFocus,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dueText,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: palette.inkOnFocusSecondary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        isPrivate
                            ? localizations.widgetPreviewPrivateSummary(1)
                            : previewTitle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: palette.inkOnFocus,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        reminderMode == TaskReminderMode.persistent
                            ? localizations.taskReminderModePersistent
                            : localizations.taskReminderModeNormal,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: palette.inkOnFocusSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 5,
                child: Column(
                  children: <Widget>[
                    _PreviewOptionCard(
                      icon: Icons.visibility_off_outlined,
                      title: localizations.taskPreviewHideContentTitle,
                      body: localizations.taskPreviewHideContentBody,
                      selected: isPrivate,
                    ),
                    const SizedBox(height: 12),
                    _PreviewOptionCard(
                      icon: Icons.visibility_outlined,
                      title: localizations.taskPreviewShowContentTitle,
                      body: localizations.taskPreviewShowContentBody,
                      selected: !isPrivate,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.surfaceMuted,
              borderRadius: ScreenNoteRadii.small,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: palette.surfaceFocusCard,
                    borderRadius: ScreenNoteRadii.small,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.verified_user_outlined,
                    color: palette.inkOnFocus,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        localizations.taskPreviewPrivateOnlyTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localizations.taskPreviewPrivateOnlyBody,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 锁屏预览选项卡。
class _PreviewOptionCard extends StatelessWidget {
  /// 创建锁屏预览选项卡。
  const _PreviewOptionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.selected,
  });

  /// 图标。
  final IconData icon;

  /// 标题。
  final String title;

  /// 说明文案。
  final String body;

  /// 是否选中。
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: ScreenNoteRadii.small,
        border: Border.all(
          color: selected ? palette.accentAmber : palette.lineSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: palette.inkSecondary, size: 20),
              const Spacer(),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  color: palette.accentAmber,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
