import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/utils/date_time_formatter.dart';
import 'package:screen_note/features/tasks/application/services/task_display_state_resolver.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';
import 'package:screen_note/features/tasks/presentation/widgets/task_status_chip.dart';

/// 当前事项卡片。
class TaskCard extends ConsumerWidget {
  /// 创建当前事项卡片。
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onComplete,
    required this.onDelete,
  });

  /// 事项实体。
  final Task task;

  /// 点击卡片动作。
  final VoidCallback onTap;

  /// 完成动作。
  final VoidCallback onComplete;

  /// 删除动作。
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final DateTime now = ref.watch(nowProvider)();
    final TaskDisplayStateResolver resolver = ref.watch(
      taskDisplayStateResolverProvider,
    );
    final TaskDisplayState state = resolver.resolve(task, now: now);
    final List<TaskStatusChipKind> chips = resolver.resolveChips(task, now: now);
    final bool isMasked = task.isPrivate;
    final String title = isMasked ? localizations.privateMaskedTitle : task.title;
    final String? dueText = task.dueAt == null
        ? null
        : ScreenNoteDateTimeFormatter.formatDateTime(task.dueAt!);
    final String? bodyText = isMasked
        ? localizations.taskPrivateMaskedBody
        : task.note;
    final Color accentColor = switch (state) {
      TaskDisplayState.overdue => ScreenNoteColors.statusOverdue,
      TaskDisplayState.completed => ScreenNoteColors.statusDone,
      TaskDisplayState.deleted => ScreenNoteColors.inkSecondary,
      _ => ScreenNoteColors.lineSoft,
    };

    return Material(
      color: ScreenNoteColors.surfaceCard,
      borderRadius: ScreenNoteRadii.card,
      child: InkWell(
        borderRadius: ScreenNoteRadii.card,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
          decoration: BoxDecoration(
            borderRadius: ScreenNoteRadii.card,
            border: Border.all(color: accentColor.withValues(alpha: 0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: state == TaskDisplayState.completed
                                ? ScreenNoteColors.inkSecondary
                                : ScreenNoteColors.inkPrimary,
                            decoration: state == TaskDisplayState.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (dueText != null) ...<Widget>[
                          const SizedBox(height: 8),
                          Text(
                            dueText,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: state == TaskDisplayState.overdue
                                  ? ScreenNoteColors.statusOverdue
                                  : ScreenNoteColors.inkSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_resolvePrimaryBadgeKind(state, task) case final TaskStatusChipKind kind)
                    _TaskCardPrimaryBadge(kind: kind),
                ],
              ),
              if (bodyText != null && bodyText.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  bodyText,
                  maxLines: isMasked ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isMasked
                        ? ScreenNoteColors.inkSecondary
                        : ScreenNoteColors.inkPrimary,
                  ),
                ),
              ],
              if (chips.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: chips
                      .map((TaskStatusChipKind chip) => TaskStatusChip(kind: chip))
                      .toList(growable: false),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      isMasked
                          ? localizations.taskPrivateMaskedBody
                          : localizations.homePageSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  if (!isMasked) ...<Widget>[
                    TextButton(
                      onPressed: onDelete,
                      child: Text(localizations.taskDeleteAction),
                    ),
                    const SizedBox(width: 4),
                  ],
                  TextButton(
                    onPressed: isMasked ? onTap : onComplete,
                    child: Text(
                      isMasked
                          ? localizations.viewTaskDetailAction
                          : localizations.taskCompleteAction,
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

  TaskStatusChipKind? _resolvePrimaryBadgeKind(
    TaskDisplayState state,
    Task task,
  ) {
    if (task.isPrivate) {
      return TaskStatusChipKind.privateItem;
    }

    if (state == TaskDisplayState.overdue) {
      return TaskStatusChipKind.overdue;
    }

    if (task.isPinned) {
      return TaskStatusChipKind.pinned;
    }

    if (state == TaskDisplayState.today) {
      return TaskStatusChipKind.today;
    }

    return null;
  }
}

/// 列表卡片右上角的单一主状态标签，避免和底部标签区重复拥挤。
class _TaskCardPrimaryBadge extends StatelessWidget {
  const _TaskCardPrimaryBadge({required this.kind});

  final TaskStatusChipKind kind;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ({String label, Color color}) config = switch (kind) {
      TaskStatusChipKind.pinned => (
        label: localizations.statusPinned,
        color: ScreenNoteColors.statusDone,
      ),
      TaskStatusChipKind.overdue => (
        label: localizations.statusOverdue,
        color: ScreenNoteColors.statusOverdue,
      ),
      TaskStatusChipKind.today => (
        label: localizations.statusToday,
        color: ScreenNoteColors.accentAmber,
      ),
      TaskStatusChipKind.privateItem => (
        label: localizations.statusPrivate,
        color: ScreenNoteColors.statusPrivate,
      ),
      TaskStatusChipKind.completed => (
        label: localizations.statusCompleted,
        color: ScreenNoteColors.statusDone,
      ),
      TaskStatusChipKind.deleted => (
        label: localizations.statusDeleted,
        color: ScreenNoteColors.inkSecondary,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.12),
        borderRadius: ScreenNoteRadii.small,
      ),
      child: Text(
        config.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: config.color,
        ),
      ),
    );
  }
}
