import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_error_view.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_loading_view.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_scaffold.dart';
import 'package:screen_note/src/shared/utils/date_time_formatter.dart';
import 'package:screen_note/src/tasks/application/use_cases/update_task_use_case.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/presentation/overlays/delete_task_dialog.dart';
import 'package:screen_note/src/tasks/presentation/overlays/discard_changes_dialog.dart';
import 'package:screen_note/src/tasks/presentation/overlays/due_time_sheet.dart';
import 'package:screen_note/src/tasks/presentation/overlays/privacy_explain_sheet.dart';
import 'package:screen_note/src/tasks/presentation/overlays/restore_task_dialog.dart';
import 'package:screen_note/src/tasks/presentation/providers/task_feature_providers.dart';

/// 事项详情页。
class TaskDetailPage extends ConsumerStatefulWidget {
  /// 创建事项详情页。
  const TaskDetailPage({super.key, required this.taskId});

  /// 事项 ID。
  final String taskId;

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _initialized = false;
  bool _isPinned = false;
  bool _isPrivate = false;
  DateTime? _dueAt;

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AsyncValue<Task?> taskAsync = ref.watch(taskProvider(widget.taskId));

    return taskAsync.when(
      data: (Task? task) {
        if (task == null) {
          return ScreenNoteScaffold(
            title: Text(localizations.taskDetailTitle),
            body: Center(child: Text(localizations.taskDetailMissing)),
          );
        }

        _hydrate(task);
        final NavigatorState navigator = Navigator.of(context);
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (didPop) {
              return;
            }

            final bool shouldPop = await _confirmDiscardIfNeeded();
            if (shouldPop && mounted) {
              navigator.pop(result);
            }
          },
          child: ScreenNoteScaffold(
            title: Text(localizations.taskDetailTitle),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: localizations.taskTitleLabel,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: localizations.taskNoteLabel,
                    ),
                    minLines: 3,
                    maxLines: 6,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(localizations.taskDueLabel),
                    subtitle: Text(
                      _dueAt == null
                          ? localizations.taskDueEmpty
                          : ScreenNoteDateTimeFormatter.formatDateTime(_dueAt!),
                    ),
                    onTap: _pickDueTime,
                  ),
                  SwitchListTile(
                    value: _isPinned,
                    contentPadding: EdgeInsets.zero,
                    title: Text(localizations.taskPinnedLabel),
                    onChanged: (bool value) => setState(() => _isPinned = value),
                  ),
                  SwitchListTile(
                    value: _isPrivate,
                    contentPadding: EdgeInsets.zero,
                    title: Text(localizations.taskPrivateLabel),
                    onChanged: (bool value) => setState(() => _isPrivate = value),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: _showPrivacyExplain,
                      child: Text(localizations.privacyExplainTitle),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => _saveTask(task),
                    child: Text(localizations.taskSaveChanges),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: <Widget>[
                      if (task.status == TaskStatus.active)
                        FilledButton.tonal(
                          onPressed: () => _completeTask(task.id),
                          child: Text(localizations.taskCompleteAction),
                        ),
                      if (task.status != TaskStatus.deleted)
                        TextButton(
                          onPressed: () => _deleteTask(task.id),
                          child: Text(localizations.taskDeleteAction),
                        ),
                      if (task.status != TaskStatus.active)
                        TextButton(
                          onPressed: () => _restoreTask(task.id),
                          child: Text(localizations.taskRestoreAction),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => ScreenNoteScaffold(
        title: Text(localizations.taskDetailTitle),
        body: ScreenNoteLoadingView(message: localizations.taskLoadFailed),
      ),
      error: (Object _, StackTrace __) => ScreenNoteScaffold(
        title: Text(localizations.taskDetailTitle),
        body: ScreenNoteErrorView(
          message: localizations.taskLoadFailed,
          retryLabel: localizations.retryAction,
          onRetry: () => ref.invalidate(taskProvider(widget.taskId)),
        ),
      ),
    );
  }

  void _hydrate(Task task) {
    if (_initialized) {
      return;
    }

    _titleController.text = task.title;
    _noteController.text = task.note ?? '';
    _isPinned = task.isPinned;
    _isPrivate = task.isPrivate;
    _dueAt = task.dueAt;
    _initialized = true;
  }

  Future<void> _pickDueTime() async {
    final DateTime? selectedTime = await showModalBottomSheet<DateTime?>(
      context: context,
      builder: (BuildContext context) => DueTimeSheet(selectedTime: _dueAt),
    );

    if (selectedTime != null || _dueAt != null) {
      setState(() {
        _dueAt = selectedTime;
      });
    }
  }

  Future<void> _showPrivacyExplain() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => const PrivacyExplainSheet(),
    );
  }

  Future<void> _saveTask(Task task) async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    await ref
        .read(updateTaskUseCaseProvider)
        .call(
          UpdateTaskInput(
            id: task.id,
            title: _titleController.text,
            note: _noteController.text,
            dueAt: _dueAt,
            isPinned: _isPinned,
            isPrivate: _isPrivate,
            reminderMode: task.reminderMode,
          ),
        );
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(localizations.taskUpdateSuccess)));
  }

  Future<void> _completeTask(String taskId) async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    await ref.read(completeTaskUseCaseProvider).call(taskId);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(localizations.taskCompleteSuccess)));
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(localizations.taskDeleteSuccess)));
  }

  Future<void> _restoreTask(String taskId) async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => const RestoreTaskDialog(),
    );
    if (confirmed != true) {
      return;
    }

    await ref.read(restoreTaskUseCaseProvider).call(taskId);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(localizations.taskRestoreSuccess)));
  }

  Future<bool> _confirmDiscardIfNeeded() async {
    final AsyncValue<Task?> taskAsync = ref.read(taskProvider(widget.taskId));
    final Task? task = taskAsync.value;
    if (task == null) {
      return true;
    }

    final bool changed =
        _titleController.text != task.title ||
        _noteController.text != (task.note ?? '') ||
        _isPinned != task.isPinned ||
        _isPrivate != task.isPrivate ||
        _dueAt != task.dueAt;

    if (!changed) {
      return true;
    }

    final bool? discard = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => const DiscardChangesDialog(),
    );
    return discard ?? false;
  }
}
