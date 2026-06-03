import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/utils/date_time_formatter.dart';
import 'package:screen_note/features/tasks/application/services/task_display_state_resolver.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';
import 'package:screen_note/features/tasks/presentation/widgets/task_surface_panel.dart';

/// 首页事项卡片布局类型。
enum TaskCardVariant {
  /// 首屏焦点事项卡。
  focus,

  /// 焦点卡下方的次级事项行。
  compact,
}

/// 首页事项卡片。
class TaskCard extends ConsumerWidget {
  /// 创建首页事项卡片。
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onComplete,
    required this.onDelete,
    this.variant = TaskCardVariant.focus,
  });

  /// 事项实体。
  final Task task;

  /// 点击卡片动作。
  final VoidCallback onTap;

  /// 完成动作。
  final VoidCallback onComplete;

  /// 删除动作。
  final VoidCallback onDelete;

  /// 当前布局类型。
  final TaskCardVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime now = ref.watch(nowProvider)();
    final TaskDisplayStateResolver resolver = ref.watch(
      taskDisplayStateResolverProvider,
    );
    final TaskDisplayState state = resolver.resolve(task, now: now);

    return switch (variant) {
      TaskCardVariant.focus => _FocusTaskCard(
          task: task,
          state: state,
          onTap: onTap,
          onComplete: onComplete,
          onDelete: onDelete,
        ),
      TaskCardVariant.compact => _CompactTaskCard(
          task: task,
          state: state,
          onTap: onTap,
          onComplete: onComplete,
          onDelete: onDelete,
        ),
    };
  }
}

/// 首页首屏焦点事项卡。
class _FocusTaskCard extends StatelessWidget {
  /// 创建焦点事项卡。
  const _FocusTaskCard({
    required this.task,
    required this.state,
    required this.onTap,
    required this.onComplete,
    required this.onDelete,
  });

  /// 当前事项。
  final Task task;

  /// 展示态。
  final TaskDisplayState state;

  /// 点击卡片动作。
  final VoidCallback onTap;

  /// 完成动作。
  final VoidCallback onComplete;

  /// 删除动作。
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final String title = task.isPrivate
        ? localizations.privateMaskedTitle
        : task.title;
    final String body = task.isPrivate
        ? localizations.taskPrivateMaskedBody
        : (task.note?.trim().isNotEmpty ?? false)
            ? task.note!.trim()
            : localizations.homePageSubtitle;
    final String dueText = task.dueAt == null
        ? localizations.taskDueEmpty
        : ScreenNoteDateTimeFormatter.formatDateTime(task.dueAt!);
    final String badgeLabel = _resolveBadgeLabel(localizations);
    final IconData actionIcon = task.isPrivate
        ? Icons.arrow_forward_rounded
        : Icons.check_rounded;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: ScreenNoteRadii.card,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
          decoration: BoxDecoration(
            color: palette.surfaceFocusCard,
            borderRadius: ScreenNoteRadii.card,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.shadowSoft,
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: ScreenNoteRadii.small,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          _resolveBadgeIcon(),
                          size: 16,
                          color: palette.inkOnFocus,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          badgeLabel,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: palette.inkOnFocus,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<_TaskCardMenuAction>(
                    color: palette.surfaceRaised,
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      color: palette.inkOnFocusSecondary,
                    ),
                    onSelected: (_TaskCardMenuAction action) {
                      switch (action) {
                        case _TaskCardMenuAction.open:
                          onTap();
                        case _TaskCardMenuAction.delete:
                          onDelete();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<_TaskCardMenuAction>>[
                          PopupMenuItem<_TaskCardMenuAction>(
                            value: _TaskCardMenuAction.open,
                            child: Text(localizations.viewTaskDetailAction),
                          ),
                          PopupMenuItem<_TaskCardMenuAction>(
                            value: _TaskCardMenuAction.delete,
                            child: Text(localizations.taskDeleteAction),
                          ),
                        ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: palette.inkOnFocus,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: 42,
                height: 3,
                decoration: BoxDecoration(
                  color: palette.inkOnFocusSecondary,
                  borderRadius: ScreenNoteRadii.circular,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: palette.inkOnFocusSecondary,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _FocusMetaItem(
                      icon: Icons.calendar_today_outlined,
                      label: dueText,
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    borderRadius: ScreenNoteRadii.circular,
                    onTap: task.isPrivate ? onTap : onComplete,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: palette.accentTerracotta,
                        borderRadius: ScreenNoteRadii.circular,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        actionIcon,
                        color: palette.inkOnFocus,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _resolveBadgeLabel(AppLocalizations localizations) {
    if (task.isPrivate) {
      return localizations.statusPrivate;
    }

    if (task.isPinned) {
      return localizations.statusPinned;
    }

    if (state == TaskDisplayState.overdue) {
      return localizations.statusOverdue;
    }

    return localizations.statusToday;
  }

  IconData _resolveBadgeIcon() {
    if (task.isPrivate) {
      return Icons.visibility_off_outlined;
    }

    if (task.isPinned) {
      return Icons.adjust_outlined;
    }

    if (state == TaskDisplayState.overdue) {
      return Icons.alarm_outlined;
    }

    return Icons.track_changes_rounded;
  }
}

/// 焦点事项卡底部信息项。
class _FocusMetaItem extends StatelessWidget {
  /// 创建焦点事项卡底部信息项。
  const _FocusMetaItem({
    required this.icon,
    required this.label,
  });

  /// 图标。
  final IconData icon;

  /// 文案。
  final String label;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: palette.inkOnFocus),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: palette.inkOnFocus,
            ),
          ),
        ),
      ],
    );
  }
}

/// 首页焦点卡下方的次级事项行。
class _CompactTaskCard extends StatelessWidget {
  /// 创建次级事项行。
  const _CompactTaskCard({
    required this.task,
    required this.state,
    required this.onTap,
    required this.onComplete,
    required this.onDelete,
  });

  /// 当前事项。
  final Task task;

  /// 展示态。
  final TaskDisplayState state;

  /// 点击卡片动作。
  final VoidCallback onTap;

  /// 完成动作。
  final VoidCallback onComplete;

  /// 删除动作。
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final String title = task.isPrivate
        ? localizations.privateMaskedTitle
        : task.title;
    final String dueText = task.dueAt == null
        ? localizations.taskDueEmpty
        : ScreenNoteDateTimeFormatter.formatDateTime(task.dueAt!);
    final Color leadingColor = switch (state) {
      TaskDisplayState.overdue => palette.accentTerracotta,
      TaskDisplayState.today => palette.accentAmber,
      _ => palette.lineSoft,
    };

    return TaskSurfacePanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: InkWell(
        borderRadius: ScreenNoteRadii.card,
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: palette.surfaceMuted,
                borderRadius: ScreenNoteRadii.circular,
              ),
              alignment: Alignment.center,
              child: Icon(
                _resolveLeadingIcon(),
                color: leadingColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: palette.inkPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dueText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: state == TaskDisplayState.overdue
                          ? palette.accentTerracotta
                          : palette.inkSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: task.isPrivate ? onTap : onComplete,
              icon: Icon(
                task.isPrivate
                    ? Icons.arrow_forward_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: palette.inkTertiary,
              ),
            ),
            PopupMenuButton<_TaskCardMenuAction>(
              color: palette.surfaceRaised,
              icon: Icon(
                Icons.more_horiz_rounded,
                color: palette.inkTertiary,
              ),
              onSelected: (_TaskCardMenuAction action) {
                switch (action) {
                  case _TaskCardMenuAction.open:
                    onTap();
                  case _TaskCardMenuAction.delete:
                    onDelete();
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<_TaskCardMenuAction>>[
                    PopupMenuItem<_TaskCardMenuAction>(
                      value: _TaskCardMenuAction.open,
                      child: Text(localizations.viewTaskDetailAction),
                    ),
                    PopupMenuItem<_TaskCardMenuAction>(
                      value: _TaskCardMenuAction.delete,
                      child: Text(localizations.taskDeleteAction),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _resolveLeadingIcon() {
    if (task.isPrivate) {
      return Icons.visibility_off_outlined;
    }

    if (task.isPinned) {
      return Icons.push_pin_outlined;
    }

    if (state == TaskDisplayState.overdue) {
      return Icons.schedule_rounded;
    }

    return Icons.description_outlined;
  }
}

/// 事项卡片菜单动作。
enum _TaskCardMenuAction {
  /// 打开详情。
  open,

  /// 删除事项。
  delete,
}
