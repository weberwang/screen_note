import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/utils/date_time_formatter.dart';
import 'package:screen_note/features/tasks/application/use_cases/watch_deleted_tasks_use_case.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';

/// 最近删除卡片。
class DeletedTaskCard extends ConsumerWidget {
  /// 创建最近删除卡片。
  const DeletedTaskCard({
    super.key,
    required this.task,
    required this.onRestore,
  });

  /// 已删除事项。
  final Task task;

  /// 恢复动作。
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final WatchDeletedTasksUseCase deletedUseCase = ref.watch(
      watchDeletedTasksUseCaseProvider,
    );
    final int remainingDays = deletedUseCase.remainingDays(
      task,
      now: ref.watch(nowProvider)(),
    );

    return Container(
      padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceMuted,
        borderRadius: ScreenNoteRadii.card,
        border: Border.all(color: ScreenNoteColors.lineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            task.title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: ScreenNoteColors.inkPrimary,
            ),
          ),
          const SizedBox(height: 8),
          if (task.deletedAt != null)
            Text(
              ScreenNoteDateTimeFormatter.formatDateTime(task.deletedAt!),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: ScreenNoteColors.surfaceCard,
              borderRadius: ScreenNoteRadii.small,
            ),
            child: Text(localizations.remainingDaysLabel(remainingDays)),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onRestore,
              child: Text(localizations.taskRestoreAction),
            ),
          ),
        ],
      ),
    );
  }
}
