import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/app/route_paths.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_error_view.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_loading_view.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_scaffold.dart';
import 'package:screen_note/src/shared/utils/date_time_formatter.dart';
import 'package:screen_note/src/tasks/application/services/task_display_state_resolver.dart';
import 'package:screen_note/src/tasks/application/use_cases/update_task_use_case.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/presentation/widgets/task_status_chip.dart';
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
        final bool isActive = task.status == TaskStatus.active;
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
                  const SizedBox(height: 16),
                  _TaskDetailSummaryCard(task: task),
                  const SizedBox(height: 16),
                  if (isActive) ...<Widget>[
                    _buildEditableContent(localizations),
                    const SizedBox(height: 16),
                    _buildActiveActions(localizations, task),
                  ] else ...<Widget>[
                    _TaskDetailMetaCard(
                      dueText: _dueAt == null
                          ? localizations.taskDueEmpty
                          : ScreenNoteDateTimeFormatter.formatDateTime(_dueAt!),
                      pinnedLabel: _isPinned
                          ? localizations.valueEnabled
                          : localizations.valueDisabled,
                      privateLabel: _isPrivate
                          ? localizations.valueEnabled
                          : localizations.valueDisabled,
                    ),
                    const SizedBox(height: 16),
                    _buildReadOnlyActions(localizations, task),
                  ],
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

  Widget _buildEditableContent(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
          decoration: BoxDecoration(
            color: ScreenNoteColors.surfaceCard,
            borderRadius: ScreenNoteRadii.card,
            border: Border.all(color: ScreenNoteColors.lineSoft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: localizations.taskTitleLabel),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(labelText: localizations.taskNoteLabel),
                minLines: 3,
                maxLines: 6,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
          decoration: BoxDecoration(
            color: ScreenNoteColors.surfaceCard,
            borderRadius: ScreenNoteRadii.card,
            border: Border.all(color: ScreenNoteColors.lineSoft),
          ),
          child: Column(
            children: <Widget>[
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveActions(AppLocalizations localizations, Task task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: FilledButton(
                onPressed: () => _saveTask(task),
                child: Text(localizations.taskSaveChanges),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.tonal(
              onPressed: () => _deleteTask(task.id),
              child: Text(localizations.taskDeleteAction),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => _completeTask(task.id),
            child: Text(localizations.taskCompleteAction),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyActions(AppLocalizations localizations, Task task) {
    final String secondaryLabel = task.status == TaskStatus.completed
        ? localizations.historyCompletedTitle
        : localizations.historyDeletedTitle;
    final String secondaryPath = task.status == TaskStatus.completed
        ? RoutePaths.historyCompleted
        : RoutePaths.historyDeleted;

    return Row(
      children: <Widget>[
        Expanded(
          child: FilledButton(
            onPressed: () => _restoreTask(task.id),
            child: Text(localizations.taskRestoreItemAction),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.tonal(
          onPressed: () => context.go(secondaryPath),
          child: Text(secondaryLabel),
        ),
      ],
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

/// 详情页头部摘要卡，统一承载状态、标题和主说明。
class _TaskDetailSummaryCard extends StatelessWidget {
  const _TaskDetailSummaryCard({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final TaskStatusChipKind? statusKind = switch (task.status) {
      TaskStatus.active => task.isPrivate ? TaskStatusChipKind.privateItem : null,
      TaskStatus.completed => TaskStatusChipKind.completed,
      TaskStatus.deleted => TaskStatusChipKind.deleted,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
      decoration: BoxDecoration(
        color: task.status == TaskStatus.deleted
            ? ScreenNoteColors.surfaceMuted
            : ScreenNoteColors.surfaceCard,
        borderRadius: ScreenNoteRadii.card,
        border: Border.all(color: ScreenNoteColors.lineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (statusKind != null) ...<Widget>[
            TaskStatusChip(kind: statusKind),
            const SizedBox(height: 12),
          ],
          Text(task.title, style: Theme.of(context).textTheme.titleMedium),
          if (task.note case final String note when note.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(note, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

/// 详情页只读信息卡，避免完成态和删除态仍暴露可编辑控件。
class _TaskDetailMetaCard extends StatelessWidget {
  const _TaskDetailMetaCard({
    required this.dueText,
    required this.pinnedLabel,
    required this.privateLabel,
  });

  final String dueText;
  final String pinnedLabel;
  final String privateLabel;

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
      child: Column(
        children: <Widget>[
          _TaskDetailMetaRow(label: localizations.taskDueLabel, value: dueText),
          const SizedBox(height: 12),
          _TaskDetailMetaRow(
            label: localizations.taskPinnedLabel,
            value: pinnedLabel,
          ),
          const SizedBox(height: 12),
          _TaskDetailMetaRow(
            label: localizations.taskPrivateLabel,
            value: privateLabel,
          ),
        ],
      ),
    );
  }
}

/// 详情页信息行。
class _TaskDetailMetaRow extends StatelessWidget {
  const _TaskDetailMetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        const SizedBox(width: 12),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
