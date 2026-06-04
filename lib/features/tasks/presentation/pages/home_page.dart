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
import 'package:screen_note/features/tasks/presentation/widgets/task_surface_panel.dart';

/// 首页。
class HomePage extends ConsumerStatefulWidget {
  /// 创建首页。
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
      title: Text(
        localizations.appTitle,
        style: Theme.of(context).textTheme.displayMedium,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () => context.go(RoutePaths.settings),
          icon: const Icon(Icons.settings_outlined),
          tooltip: localizations.settingsEntry,
        ),
      ],
      body: tasksAsync.when(
        data: (List<Task> tasks) => _HomeContent(
          tasks: tasks,
          draftValue: _draftValue,
          inlineError: _inlineError,
          isSubmitting: _isSubmitting,
          onSubmit: _openQuickAddSheet,
          onOpenEditor: () => context.push(RoutePaths.taskNew),
          onClearDraft: _clearQuickInputDraft,
          onOpenCompletedHistory: () => context.go(RoutePaths.historyCompleted),
          onOpenDeletedHistory: () => context.go(RoutePaths.historyDeleted),
          onOpenTask: (Task task) => context.go(RoutePaths.taskDetailPath(task.id)),
          onCompleteTask: _completeTask,
          onDeleteTask: _deleteTask,
        ),
        loading: () => ScreenNoteScaffoldBodyState(
          child: ScreenNoteLoadingView(message: localizations.homePageSubtitle),
        ),
        error: (Object _, StackTrace __) => ScreenNoteScaffoldBodyState(
          child: ScreenNoteErrorView(
            message: localizations.taskLoadFailed,
            retryLabel: localizations.retryAction,
            onRetry: () => ref.invalidate(activeTasksProvider),
          ),
        ),
      ),
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

/// 首页主体内容。
class _HomeContent extends StatelessWidget {
  /// 创建首页主体内容。
  const _HomeContent({
    required this.tasks,
    required this.draftValue,
    required this.inlineError,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onOpenEditor,
    required this.onClearDraft,
    required this.onOpenCompletedHistory,
    required this.onOpenDeletedHistory,
    required this.onOpenTask,
    required this.onCompleteTask,
    required this.onDeleteTask,
  });

  /// 当前事项集合。
  final List<Task> tasks;

  /// 当前快速录入草稿。
  final String? draftValue;

  /// 内联错误。
  final String? inlineError;

  /// 是否正在提交。
  final bool isSubmitting;

  /// 提交动作。
  final Future<void> Function(String value) onSubmit;

  /// 打开完整编辑页。
  final VoidCallback onOpenEditor;

  /// 清理草稿。
  final VoidCallback onClearDraft;

  /// 打开最近完成页。
  final VoidCallback onOpenCompletedHistory;

  /// 打开最近删除页。
  final VoidCallback onOpenDeletedHistory;

  /// 打开任务详情。
  final void Function(Task task) onOpenTask;

  /// 完成任务。
  final Future<void> Function(String taskId) onCompleteTask;

  /// 删除任务。
  final Future<void> Function(String taskId) onDeleteTask;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final List<Task> remainingTasks = tasks.length > 1
        ? tasks.sublist(1)
        : const <Task>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        ScreenNoteSpacing.pageHorizontal,
        8,
        ScreenNoteSpacing.pageHorizontal,
        ScreenNoteSpacing.pageVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.homePageSubtitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: () => context.go(RoutePaths.settings),
            child: Text(localizations.settingsEntry),
          ),
          const SizedBox(height: 24),
          QuickInputCard(
            isSubmitting: isSubmitting,
            initialValue: draftValue,
            errorText: inlineError,
            onSubmit: onSubmit,
            onSecondaryAction: onOpenEditor,
            onCancel: onClearDraft,
            secondaryActionLabel: localizations.taskEditorEntry,
          ),
          const SizedBox(height: ScreenNoteSpacing.sectionGap),
          if (tasks.isEmpty) ...<Widget>[
            _HomeEmptyState(onOpenEditor: onOpenEditor),
          ] else ...<Widget>[
            TaskCard(
              task: tasks.first,
              onTap: () => onOpenTask(tasks.first),
              onComplete: () => onCompleteTask(tasks.first.id),
              onDelete: () => onDeleteTask(tasks.first.id),
            ),
            if (remainingTasks.isNotEmpty) ...<Widget>[
              const SizedBox(height: ScreenNoteSpacing.sectionGap),
              TaskListSection(
                title: localizations.homeUpNextTitle,
                trailing: Wrap(
                  spacing: 4,
                  children: <Widget>[
                    TextButton(
                      onPressed: onOpenCompletedHistory,
                      child: Text(localizations.completedHistoryEntry),
                    ),
                    TextButton(
                      onPressed: onOpenDeletedHistory,
                      child: Text(localizations.deletedHistoryEntry),
                    ),
                  ],
                ),
                children: remainingTasks
                    .map(
                      (Task task) => TaskCard(
                        task: task,
                        variant: TaskCardVariant.compact,
                        onTap: () => onOpenTask(task),
                        onComplete: () => onCompleteTask(task.id),
                        onDelete: () => onDeleteTask(task.id),
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// 首页空态。
class _HomeEmptyState extends StatelessWidget {
  /// 创建首页空态。
  const _HomeEmptyState({required this.onOpenEditor});

  /// 打开完整新建页。
  final VoidCallback onOpenEditor;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TaskSurfacePanel(
          backgroundColor: palette.surfaceMuted,
          borderColor: palette.lineSoft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                localizations.emptyActiveTasksTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(localizations.emptyActiveTasksBody),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: onOpenEditor,
                child: Text(localizations.taskEditorTitle),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.go(RoutePaths.historyCompleted),
          child: Text(localizations.completedHistoryEntry),
        ),
      ],
    );
  }
}

/// 为首页 loading / error 壳层补统一布局，避免直接把状态组件贴到 Scaffold 顶层。
class ScreenNoteScaffoldBodyState extends StatelessWidget {
  /// 创建骨架状态页。
  const ScreenNoteScaffoldBodyState({super.key, required this.child});

  /// 状态内容。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
      child: Center(child: child),
    );
  }
}
