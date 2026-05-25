import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/shared/utils/date_time_formatter.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';

/// 最近完成卡片。
class HistoryTaskCard extends StatelessWidget {
  /// 创建最近完成卡片。
  const HistoryTaskCard({
    super.key,
    required this.task,
    required this.onRestore,
  });

  /// 已完成事项。
  final Task task;

  /// 恢复动作。
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceCard,
        borderRadius: ScreenNoteRadii.card,
        border: Border.all(color: ScreenNoteColors.lineSoft),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: ScreenNoteColors.inkSecondary,
                  ),
                ),
                if (task.completedAt != null) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    ScreenNoteDateTimeFormatter.formatDateTime(task.completedAt!),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: onRestore,
            child: Text(localizations.taskRestoreAction),
          ),
        ],
      ),
    );
  }
}
