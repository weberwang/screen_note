import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/app/route_paths.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_error_view.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_loading_view.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_scaffold.dart';
import 'package:screen_note/shared/utils/date_time_formatter.dart';
import 'package:screen_note/features/tasks/application/use_cases/update_task_use_case.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/overlays/delete_task_dialog.dart';
import 'package:screen_note/features/tasks/presentation/overlays/discard_changes_dialog.dart';
import 'package:screen_note/features/tasks/presentation/overlays/due_time_sheet.dart';
import 'package:screen_note/features/tasks/presentation/overlays/privacy_explain_sheet.dart';
import 'package:screen_note/features/tasks/presentation/overlays/restore_task_dialog.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';
import 'package:screen_note/features/tasks/presentation/widgets/task_action_footer.dart';
import 'package:screen_note/features/tasks/presentation/widgets/task_meta_row.dart';
import 'package:screen_note/features/tasks/presentation/widgets/task_privacy_preview_card.dart';
import 'package:screen_note/features/tasks/presentation/widgets/task_surface_panel.dart';

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
              padding: const EdgeInsets.fromLTRB(
                ScreenNoteSpacing.pageHorizontal,
                8,
                ScreenNoteSpacing.pageHorizontal,
                ScreenNoteSpacing.pageVertical,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _TaskSummaryHeader(task: task),
                  const SizedBox(height: 20),
                  if (isActive) ...<Widget>[
                    _buildEditableFieldsPanel(localizations),
                    const SizedBox(height: 16),
                    _buildMetaPanel(localizations),
                    const SizedBox(height: 16),
                    TaskPrivacyPreviewCard(
                      title: _titleController.text,
                      isPrivate: _isPrivate,
                      dueAt: _dueAt,
                      reminderMode: task.reminderMode,
                    ),
                    const SizedBox(height: 20),
                    TaskActionFooter(
                      primaryLabel: localizations.taskSaveChanges,
                      onPrimaryPressed: () => _saveTask(task),
                      primaryEnabled: _titleController.text.trim().isNotEmpty,
                      secondaryActions: <Widget>[
                        TextButton(
                          onPressed: () => _completeTask(task.id),
                          child: Text(localizations.taskCompleteAction),
                        ),
                        OutlinedButton(
                          onPressed: () => _deleteTask(task.id),
                          child: Text(localizations.taskDeleteAction),
                        ),
                      ],
                    ),
                  ] else ...<Widget>[
                    _buildReadOnlyMetaPanel(localizations),
                    const SizedBox(height: 16),
                    TaskPrivacyPreviewCard(
                      title: task.title,
                      isPrivate: task.isPrivate,
                      dueAt: task.dueAt,
                      reminderMode: task.reminderMode,
                    ),
                    const SizedBox(height: 20),
                    TaskActionFooter(
                      primaryLabel: localizations.taskRestoreItemAction,
                      onPrimaryPressed: () => _restoreTask(task.id),
                      secondaryActions: <Widget>[
                        TextButton(
                          onPressed: () => context.go(
                            task.status == TaskStatus.completed
                                ? RoutePaths.historyCompleted
                                : RoutePaths.historyDeleted,
                          ),
                          child: Text(
                            task.status == TaskStatus.completed
                                ? localizations.historyCompletedTitle
                                : localizations.historyDeletedTitle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
      loading: () => ScreenNoteScaffold(
        title: Text(localizations.taskDetailTitle),
        body: ScreenNoteLoadingView(message: localizations.homePageSubtitle),
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

  Widget _buildEditableFieldsPanel(AppLocalizations localizations) {
    return TaskSurfacePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: localizations.taskTitleLabel),
            onChanged: (_) => setState(() {}),
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
    );
  }

  Widget _buildMetaPanel(AppLocalizations localizations) {
    return TaskSurfacePanel(
      child: Column(
        children: <Widget>[
          TaskMetaRow(
            icon: Icons.calendar_today_outlined,
            label: localizations.taskDueLabel,
            value: _dueAt == null
                ? localizations.taskDueEmpty
                : ScreenNoteDateTimeFormatter.formatDateTime(_dueAt!),
            onTap: _pickDueTime,
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: 16),
          TaskMetaRow(
            icon: Icons.push_pin_outlined,
            label: localizations.taskPinnedLabel,
            value: _isPinned
                ? localizations.valueEnabled
                : localizations.valueDisabled,
            trailing: Switch.adaptive(
              value: _isPinned,
              onChanged: (bool value) => setState(() => _isPinned = value),
            ),
          ),
          const SizedBox(height: 16),
          TaskMetaRow(
            icon: Icons.visibility_off_outlined,
            label: localizations.taskPrivateLabel,
            value: _isPrivate
                ? localizations.valueEnabled
                : localizations.valueDisabled,
            trailing: Switch.adaptive(
              value: _isPrivate,
              onChanged: (bool value) => setState(() => _isPrivate = value),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _showPrivacyExplain,
              child: Text(localizations.privacyExplainTitle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyMetaPanel(AppLocalizations localizations) {
    return TaskSurfacePanel(
      child: Column(
        children: <Widget>[
          TaskMetaRow(
            icon: Icons.calendar_today_outlined,
            label: localizations.taskDueLabel,
            value: _dueAt == null
                ? localizations.taskDueEmpty
                : ScreenNoteDateTimeFormatter.formatDateTime(_dueAt!),
          ),
          const SizedBox(height: 16),
          TaskMetaRow(
            icon: Icons.push_pin_outlined,
            label: localizations.taskPinnedLabel,
            value: _isPinned
                ? localizations.valueEnabled
                : localizations.valueDisabled,
          ),
          const SizedBox(height: 16),
          TaskMetaRow(
            icon: Icons.visibility_off_outlined,
            label: localizations.taskPrivateLabel,
            value: _isPrivate
                ? localizations.valueEnabled
                : localizations.valueDisabled,
          ),
        ],
      ),
    );
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
    if (task == null || task.status != TaskStatus.active) {
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

/// 详情页头部摘要卡。
class _TaskSummaryHeader extends StatelessWidget {
  /// 创建详情页头部摘要卡。
  const _TaskSummaryHeader({required this.task});

  /// 当前事项。
  final Task task;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final String title = task.isPrivate
        ? localizations.privateMaskedTitle
        : task.title;

    return TaskSurfacePanel(
      backgroundColor: palette.surfaceMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _TaskHeaderChip(
                icon: Icons.push_pin_outlined,
                label: task.isPinned
                    ? localizations.statusPinned
                    : localizations.statusToday,
              ),
              if (task.isPrivate)
                _TaskHeaderChip(
                  icon: Icons.visibility_off_outlined,
                  label: localizations.statusPrivate,
                ),
              if (task.status == TaskStatus.completed)
                _TaskHeaderChip(
                  icon: Icons.check_circle_outline_rounded,
                  label: localizations.statusCompleted,
                ),
              if (task.status == TaskStatus.deleted)
                _TaskHeaderChip(
                  icon: Icons.delete_outline_rounded,
                  label: localizations.statusDeleted,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          if (task.note case final String note when note.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              note,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: palette.inkSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 详情页头部标签。
class _TaskHeaderChip extends StatelessWidget {
  /// 创建详情页头部标签。
  const _TaskHeaderChip({
    required this.icon,
    required this.label,
  });

  /// 图标。
  final IconData icon;

  /// 文案。
  final String label;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: ScreenNoteRadii.small,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: palette.accentAmber),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
