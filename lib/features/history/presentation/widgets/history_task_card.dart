import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/utils/date_time_formatter.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';

/// 最近完成卡片。
class HistoryTaskCard extends StatelessWidget {
  /// 创建最近完成卡片。
  const HistoryTaskCard({
    super.key,
    required this.task,
    required this.onViewDetail,
    this.onRestore,
  });

  /// 已完成事项。
  final Task task;

  /// 查看原记录动作。
  final VoidCallback onViewDetail;

  /// 恢复动作，阶段二最近完成页会显式暴露该入口。
  final VoidCallback? onRestore;

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                if (task.note case final String note when note.trim().isNotEmpty) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    note,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ScreenNoteColors.inkPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (onRestore != null)
                TextButton(
                  onPressed: onRestore,
                  child: Text(localizations.taskRestoreItemAction),
                ),
              TextButton(
                onPressed: onViewDetail,
                child: Text(localizations.viewOriginalRecordAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
