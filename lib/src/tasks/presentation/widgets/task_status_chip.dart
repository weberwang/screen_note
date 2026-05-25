import 'package:flutter/material.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/tasks/application/services/task_display_state_resolver.dart';

/// 事项状态标签。
class TaskStatusChip extends StatelessWidget {
  /// 创建事项状态标签。
  const TaskStatusChip({super.key, required this.kind});

  /// 标签类型。
  final TaskStatusChipKind kind;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    final ({String label, Color color}) config = switch (kind) {
      TaskStatusChipKind.pinned => (
        label: localizations.statusPinned,
        color: ScreenNoteColors.accentAmber,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
