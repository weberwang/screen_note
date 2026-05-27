import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/app/route_paths.dart';
import 'package:screen_note/features/quick_add/application/quick_add_flow_result.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_error_view.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_loading_view.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_scaffold.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/overlays/delete_task_dialog.dart';
import 'package:screen_note/features/tasks/presentation/overlays/quick_add_sheet.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';
import 'package:screen_note/features/tasks/presentation/widgets/quick_input_card.dart';
import 'package:screen_note/features/tasks/presentation/widgets/task_card.dart';
import 'package:screen_note/features/tasks/presentation/widgets/task_list_section.dart';

/// 阶段二首页。
class HomePage extends ConsumerStatefulWidget {
  /// 创建阶段二首页。
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? _draftValue;
  String? _inlineError;
  final bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AsyncValue<List<Task>> tasksAsync = ref.watch(activeTasksProvider);

    return ScreenNoteScaffold(
      title: Text(localizations.appTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.homePageTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.homePageSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                TextButton(
                  onPressed: () => context.go(RoutePaths.settings),
                  child: Text(localizations.settingsEntry),
                ),
              ],
            ),
            const SizedBox(height: 12),
            QuickInputCard(
              isSubmitting: _isSubmitting,
              initialValue: _draftValue,
              errorText: _inlineError,
              onSubmit: _openQuickAddSheet,
              onSecondaryAction: () => context.push(RoutePaths.taskNew),
              onCancel: _clearQuickInputDraft,
              secondaryActionLabel: localizations.taskEditorEntry,
            ),
            const SizedBox(height: 24),
            TaskListSection(
              title: localizations.activeTasksSectionTitle,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    onPressed: () => context.go(RoutePaths.historyCompleted),
                    child: Text(localizations.completedHistoryEntry),
                  ),
                  TextButton(
                    onPressed: () => context.go(RoutePaths.historyDeleted),
                    child: Text(localizations.deletedHistoryEntry),
                  ),
                ],
              ),
              children: <Widget>[tasksAsync.when(
                data: _buildTaskContent,
                loading: () => ScreenNoteLoadingView(
                  message: localizations.taskLoadFailed,
                ),
                error: (Object _, StackTrace __) => ScreenNoteErrorView(
                  message: localizations.taskLoadFailed,
                  retryLabel: localizations.retryAction,
                  onRetry: () => ref.invalidate(activeTasksProvider),
                ),
              )],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskContent(List<Task> tasks) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    if (tasks.isEmpty) {
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
            Text(
              localizations.emptyActiveTasksTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(localizations.emptyActiveTasksBody),
          ],
        ),
      );
    }

    return Column(
      children: tasks
          .map(
            (Task task) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TaskCard(
                task: task,
                onTap: () => context.go(RoutePaths.taskDetailPath(task.id)),
                onComplete: () => _completeTask(task.id),
                onDelete: () => _deleteTask(task.id),
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  Future<void> _openQuickAddSheet(String value) async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    setState(() {
      _draftValue = value;
      _inlineError = null;
    });

    if (value.trim().isEmpty) {
      setState(() {
        _inlineError = localizations.taskTitleRequired;
      });
      return;
    }

    final QuickAddFlowResult? result =
        await showModalBottomSheet<QuickAddFlowResult>(
          context: context,
          isScrollControlled: true,
          showDragHandle: false,
          backgroundColor: ScreenNoteColors.surfacePaper,
          builder: (BuildContext context) => QuickAddSheet(initialText: value),
        );
    if (!mounted || result == null) {
      return;
    }

    switch (result.status) {
      case QuickAddFlowStatus.createdTask:
        setState(() {
          _draftValue = '';
          _inlineError = null;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizations.taskCreateSuccess)));
      case QuickAddFlowStatus.savedDraft:
        setState(() {
          _draftValue = result.draft?.draftText ?? value;
        });
      case QuickAddFlowStatus.failedButRecovered:
        setState(() {
          _draftValue = result.draft?.draftText ?? value;
          _inlineError = localizations.taskCreateFailed;
        });
      case QuickAddFlowStatus.openedQuickAdd ||
            QuickAddFlowStatus.returnedToApp:
        break;
    }
  }

  void _clearQuickInputDraft() {
    setState(() {
      _draftValue = '';
      _inlineError = null;
    });
  }

  Future<void> _completeTask(String taskId) async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    await ref.read(completeTaskUseCaseProvider).call(taskId);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localizations.taskCompleteSuccess)),
    );
  }

  Future<void> _deleteTask(String taskId) async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => const DeleteTaskDialog(),
    );
    if (confirmed != true) {
      return;
    }

    await ref.read(deleteTaskUseCaseProvider).call(taskId);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localizations.taskDeleteSuccess)),
    );
  }
}
