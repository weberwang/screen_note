import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_error_view.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_loading_view.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_scaffold.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/presentation/overlays/restore_task_dialog.dart';
import 'package:screen_note/src/tasks/presentation/providers/task_feature_providers.dart';
import '../widgets/deleted_task_card.dart';

/// 最近删除页。
class DeletedHistoryPage extends ConsumerWidget {
  /// 创建最近删除页。
  const DeletedHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AsyncValue<List<Task>> tasksAsync = ref.watch(deletedTasksProvider);

    return ScreenNoteScaffold(
      title: Text(localizations.historyDeletedTitle),
      body: tasksAsync.when(
        data: (List<Task> tasks) {
          if (tasks.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
              child: _DeletedEmptyState(
                title: localizations.emptyDeletedTasksTitle,
                body: localizations.emptyDeletedTasksBody,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
            itemBuilder: (BuildContext context, int index) {
              final Task task = tasks[index];
              return DeletedTaskCard(
                task: task,
                onRestore: () => _restoreTask(context, ref, task.id),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemCount: tasks.length,
          );
        },
        loading: () => ScreenNoteLoadingView(
          message: localizations.taskHistoryLoadFailed,
        ),
        error: (Object _, StackTrace __) => ScreenNoteErrorView(
          message: localizations.taskHistoryLoadFailed,
          retryLabel: localizations.retryAction,
          onRetry: () => ref.invalidate(deletedTasksProvider),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Text(
          localizations.deletedRetentionHint,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Future<void> _restoreTask(BuildContext context, WidgetRef ref, String taskId) async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => const RestoreTaskDialog(),
    );
    if (confirmed != true) {
      return;
    }

    await ref.read(restoreTaskUseCaseProvider).call(taskId);
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(localizations.taskRestoreSuccess)));
  }
}

class _DeletedEmptyState extends StatelessWidget {
  const _DeletedEmptyState({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceMuted,
        borderRadius: ScreenNoteRadii.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(body),
        ],
      ),
    );
  }
}
