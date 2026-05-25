import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/shared/utils/date_time_formatter.dart';
import 'package:screen_note/src/tasks/application/services/task_display_state_resolver.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/presentation/providers/task_feature_providers.dart';
import 'package:screen_note/src/tasks/presentation/widgets/task_status_chip.dart';

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

    final String title = task.isPrivate
        ? localizations.privateMaskedTitle
        : task.title;
    final String? subtitle = task.dueAt == null
        ? task.note
        : ScreenNoteDateTimeFormatter.formatDateTime(task.dueAt!);
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
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: state == TaskDisplayState.completed
                                ? ScreenNoteColors.inkSecondary
                                : ScreenNoteColors.inkPrimary,
                            decoration: state == TaskDisplayState.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (subtitle != null && subtitle.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
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
                  Column(
                    children: <Widget>[
                      FilledButton.tonal(
                        onPressed: onComplete,
                        child: Text(localizations.taskCompleteAction),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: onDelete,
                        child: Text(localizations.taskDeleteAction),
                      ),
                    ],
                  ),
                ],
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
