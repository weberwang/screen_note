import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 事项主流程首页，负责真实展示 active 事项并承接 3 秒内的快速创建。
class TaskFlowHomePage extends HookConsumerWidget {
  /// 创建事项主流程首页。
  const TaskFlowHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AsyncValue<TaskFeedSnapshot> snapshotAsync = ref.watch(
      taskFlowHomeControllerProvider,
    );
    final TextEditingController quickInputController = useTextEditingController();
    final ValueNotifier<bool> defaultPinned = useState(false);
    final ValueNotifier<bool> defaultPrivate = useState(false);

    Future<void> submitQuickTask() async {
      final String title = quickInputController.text.trim();
      if (title.isEmpty) {
        _showMessage(context, localizations.taskTitleRequired);
        return;
      }

      try {
        await ref.read(taskFlowHomeControllerProvider.notifier).createQuickTask(
          CreateTaskInput(
            title: title,
            note: '',
            isPinned: defaultPinned.value,
            isPrivate: defaultPrivate.value,
          ),
        );
        quickInputController.clear();
        if (context.mounted) {
          _showMessage(context, localizations.taskCreateSuccess);
        }
      } catch (_) {
        if (context.mounted) {
          _showMessage(context, localizations.taskCreateFailed);
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        ScreenNoteSpacing.pageHorizontal,
        12,
        ScreenNoteSpacing.pageHorizontal,
        112,
      ),
      children: <Widget>[
        _IntroPanel(
          title: localizations.homePageSubtitle,
          body: localizations.quickInputHelperText,
        ),
        const SizedBox(height: ScreenNoteSpacing.sectionGap),
        _QuickAddCard(
          controller: quickInputController,
          isPinned: defaultPinned.value,
          isPrivate: defaultPrivate.value,
          onPinnedChanged: (bool value) => defaultPinned.value = value,
          onPrivateChanged: (bool value) => defaultPrivate.value = value,
          onSubmit: submitQuickTask,
        ),
        const SizedBox(height: ScreenNoteSpacing.sectionGap),
        snapshotAsync.when(
          data: (TaskFeedSnapshot snapshot) {
            return _TaskFeedContent(snapshot: snapshot);
          },
          loading: () => const _LoadingPanel(),
          error: (Object _, StackTrace __) {
            return _ErrorPanel(
              onRetry: () => ref.invalidate(taskFlowHomeControllerProvider),
            );
          },
        ),
      ],
    );
  }

  /// 统一反馈短提示，避免页面各自复制 SnackBar 配置。
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// 首页开场说明卡，保留冻结后的首屏层级与纸感节奏。
class _IntroPanel extends StatelessWidget {
  /// 创建首页开场说明卡。
  const _IntroPanel({required this.title, required this.body});

  /// 标题。
  final String title;

  /// 正文。
  final String body;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return ScreenNotePanel(
      backgroundColor: palette.surfaceFocusCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(color: palette.inkOnFocus),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: palette.inkOnFocusSecondary),
          ),
        ],
      ),
    );
  }
}

/// 首页快速添加卡片，承接最短输入路径与轻量默认项。
class _QuickAddCard extends StatelessWidget {
  /// 创建快速添加卡片。
  const _QuickAddCard({
    required this.controller,
    required this.isPinned,
    required this.isPrivate,
    required this.onPinnedChanged,
    required this.onPrivateChanged,
    required this.onSubmit,
  });

  /// 输入控制器。
  final TextEditingController controller;

  /// 默认置顶开关。
  final bool isPinned;

  /// 默认隐私开关。
  final bool isPrivate;

  /// 置顶变化回调。
  final ValueChanged<bool> onPinnedChanged;

  /// 隐私变化回调。
  final ValueChanged<bool> onPrivateChanged;

  /// 提交回调。
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.quickInputPlaceholder,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            localizations.quickAddSheetBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmit(),
            decoration: InputDecoration(
              hintText: localizations.quickInputPlaceholder,
              labelText: localizations.quickAddInputLabel,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              FilterChip(
                selected: isPinned,
                onSelected: onPinnedChanged,
                label: Text(localizations.quickAddDefaultPinnedTitle),
              ),
              FilterChip(
                selected: isPrivate,
                onSelected: onPrivateChanged,
                label: Text(localizations.quickAddDefaultPrivacyTitle),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.add_task_rounded),
                  label: Text(localizations.quickInputSubmit),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push(RoutePaths.taskEditor),
                  child: Text(localizations.taskEditorEntry),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 首页任务流内容，负责把快照转换为焦点卡与分组列表。
class _TaskFeedContent extends ConsumerWidget {
  /// 创建任务流内容。
  const _TaskFeedContent({required this.snapshot});

  /// 首页快照。
  final TaskFeedSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final TaskEntity? focusTask = snapshot.pinnedTasks.firstOrNull ??
        snapshot.overdueTasks.firstOrNull ??
        snapshot.todayTasks.firstOrNull ??
        snapshot.otherTasks.firstOrNull;

    if (focusTask == null) {
      return ScreenNotePanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.emptyActiveTasksTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.emptyActiveTasksBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    Future<void> completeTask(String taskId) async {
      await ref.read(taskFlowHomeControllerProvider.notifier).completeTask(taskId);
      if (context.mounted) {
        _showMessage(context, localizations.taskCompleteSuccess);
      }
    }

    Future<void> deleteTask(String taskId) async {
      await ref.read(taskFlowHomeControllerProvider.notifier).deleteTask(taskId);
      if (context.mounted) {
        _showMessage(context, localizations.taskDeleteSuccess);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FocusTaskCard(
          task: focusTask,
          onComplete: () => completeTask(focusTask.id),
          onDelete: () => deleteTask(focusTask.id),
        ),
        const SizedBox(height: ScreenNoteSpacing.sectionGap),
        _TaskSection(
          title: localizations.statusPinned,
          tasks: snapshot.pinnedTasks.where((task) => task.id != focusTask.id).toList(),
          onComplete: completeTask,
          onDelete: deleteTask,
        ),
        _TaskSection(
          title: localizations.statusOverdue,
          tasks: snapshot.overdueTasks.where((task) => task.id != focusTask.id).toList(),
          onComplete: completeTask,
          onDelete: deleteTask,
        ),
        _TaskSection(
          title: localizations.statusToday,
          tasks: snapshot.todayTasks.where((task) => task.id != focusTask.id).toList(),
          onComplete: completeTask,
          onDelete: deleteTask,
        ),
        _TaskSection(
          title: localizations.homeUpNextTitle,
          tasks: snapshot.otherTasks.where((task) => task.id != focusTask.id).toList(),
          onComplete: completeTask,
          onDelete: deleteTask,
        ),
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// 焦点事项卡，优先承接首屏最需要处理的一条任务。
class _FocusTaskCard extends StatelessWidget {
  /// 创建焦点事项卡。
  const _FocusTaskCard({
    required this.task,
    required this.onComplete,
    required this.onDelete,
  });

  /// 焦点事项。
  final TaskEntity task;

  /// 完成回调。
  final VoidCallback onComplete;

  /// 删除回调。
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return ScreenNotePanel(
      backgroundColor: palette.surfaceFocusCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _buildStatusLabels(context, task, onFocus: true),
          ),
          const SizedBox(height: 16),
          Text(
            task.title,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(color: palette.inkOnFocus),
          ),
          if (task.note.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              task.note,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: palette.inkOnFocusSecondary,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            _buildTimeSummary(context, task),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: palette.inkOnFocusSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton(
                  onPressed: onComplete,
                  child: Text(AppLocalizations.of(context).taskCompleteAction),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onDelete,
                  child: Text(AppLocalizations.of(context).taskDeleteAction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 分组任务区块，保证不同优先级任务的扫描顺序稳定。
class _TaskSection extends StatelessWidget {
  /// 创建任务区块。
  const _TaskSection({
    required this.title,
    required this.tasks,
    required this.onComplete,
    required this.onDelete,
  });

  /// 区块标题。
  final String title;

  /// 任务集合。
  final List<TaskEntity> tasks;

  /// 完成回调。
  final Future<void> Function(String taskId) onComplete;

  /// 删除回调。
  final Future<void> Function(String taskId) onDelete;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: ScreenNoteSpacing.sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          ...tasks.map(
            (TaskEntity task) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TaskListCard(
                task: task,
                onComplete: () => onComplete(task.id),
                onDelete: () => onDelete(task.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 任务列表卡片，承接标题、标签和主次动作关系。
class _TaskListCard extends StatelessWidget {
  /// 创建任务列表卡片。
  const _TaskListCard({
    required this.task,
    required this.onComplete,
    required this.onDelete,
  });

  /// 当前任务。
  final TaskEntity task;

  /// 完成回调。
  final VoidCallback onComplete;

  /// 删除回调。
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _buildStatusLabels(context, task),
          ),
          const SizedBox(height: 12),
          Text(task.title, style: Theme.of(context).textTheme.titleLarge),
          if (task.note.isNotEmpty) ...<Widget>[
            const SizedBox(height: 6),
            Text(task.note, style: Theme.of(context).textTheme.bodyMedium),
          ],
          const SizedBox(height: 14),
          Text(
            _buildTimeSummary(context, task),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.tonal(
                  onPressed: onComplete,
                  child: Text(AppLocalizations.of(context).taskCompleteAction),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onDelete,
                  child: Text(AppLocalizations.of(context).taskDeleteAction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 加载态面板，保持首页结构稳定而不是整页闪烁。
class _LoadingPanel extends StatelessWidget {
  /// 创建加载态面板。
  const _LoadingPanel();

  @override
  Widget build(BuildContext context) {
    return const ScreenNotePanel(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

/// 错误态面板，允许用户直接重试而不离开首页。
class _ErrorPanel extends StatelessWidget {
  /// 创建错误态面板。
  const _ErrorPanel({required this.onRetry});

  /// 重试回调。
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.taskLoadFailed,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRetry,
            child: Text(localizations.retryAction),
          ),
        ],
      ),
    );
  }
}

/// 构建任务标签列表，避免不同卡片各自重写相同的状态表达规则。
List<Widget> _buildStatusLabels(
  BuildContext context,
  TaskEntity task, {
  bool onFocus = false,
}) {
  final AppLocalizations localizations = AppLocalizations.of(context);
  final List<_StatusChipData> chips = <_StatusChipData>[];
  if (task.isPinned) {
    chips.add(_StatusChipData(localizations.statusPinned, StatusChipTone.pinned));
  }
  if (_isOverdue(task)) {
    chips.add(_StatusChipData(localizations.statusOverdue, StatusChipTone.overdue));
  } else if (_isDueToday(task)) {
    chips.add(_StatusChipData(localizations.statusToday, StatusChipTone.today));
  }
  if (task.isPrivate) {
    chips.add(_StatusChipData(localizations.statusPrivate, StatusChipTone.private));
  }

  return chips
      .map((chip) => _TaskStatusChip(data: chip, onFocus: onFocus))
      .toList(growable: false);
}

/// 格式化时间摘要，优先输出用户最关心的截止时间，没有就回退到创建时间。
String _buildTimeSummary(BuildContext context, TaskEntity task) {
  final AppLocalizations localizations = AppLocalizations.of(context);
  if (task.dueAt == null) {
    return localizations.quickInputHelperText;
  }

  final DateTime dueAt = task.dueAt!.toLocal();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('M月d日 HH:mm', localizations.localeName);
  if (_isDueToday(task, now: now)) {
    return '${localizations.statusToday} ${formatter.format(dueAt)}';
  }
  if (_isOverdue(task, now: now)) {
    return '${localizations.statusOverdue} ${formatter.format(dueAt)}';
  }
  return formatter.format(dueAt);
}

/// 判定事项是否属于 today 区块；当天到期不直接降级为 overdue。
bool _isDueToday(TaskEntity task, {DateTime? now}) {
  final DateTime? dueAt = task.dueAt?.toLocal();
  if (dueAt == null) {
    return false;
  }

  final DateTime timestamp = now ?? DateTime.now();
  return dueAt.year == timestamp.year &&
      dueAt.month == timestamp.month &&
      dueAt.day == timestamp.day;
}

/// 判定事项是否已过期；以“早于今天零点”为边界避免当天事项过早降级。
bool _isOverdue(TaskEntity task, {DateTime? now}) {
  final DateTime? dueAt = task.dueAt?.toLocal();
  if (dueAt == null) {
    return false;
  }

  final DateTime timestamp = now ?? DateTime.now();
  final DateTime startOfToday = DateTime(
    timestamp.year,
    timestamp.month,
    timestamp.day,
  );
  return dueAt.isBefore(startOfToday);
}

/// 状态标签视觉语义。
enum StatusChipTone { pinned, overdue, today, private }

/// 状态标签数据载体。
class _StatusChipData {
  /// 创建状态标签数据。
  const _StatusChipData(this.label, this.tone);

  /// 文案。
  final String label;

  /// 视觉语义。
  final StatusChipTone tone;
}

/// 状态标签组件。
class _TaskStatusChip extends StatelessWidget {
  /// 创建状态标签。
  const _TaskStatusChip({required this.data, this.onFocus = false});

  /// 标签数据。
  final _StatusChipData data;

  /// 是否在焦点卡上使用。
  final bool onFocus;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final (Color background, Color foreground) = switch (data.tone) {
      StatusChipTone.pinned => (
        onFocus ? palette.surfaceRaised.withValues(alpha: 0.18) : palette.surfaceMuted,
        onFocus ? palette.inkOnFocus : palette.inkPrimary,
      ),
      StatusChipTone.overdue => (
        onFocus ? palette.statusOverdue.withValues(alpha: 0.22) : const Color(0xFFFBE4DC),
        onFocus ? palette.inkOnFocus : palette.statusOverdue,
      ),
      StatusChipTone.today => (
        onFocus ? palette.surfaceRaised.withValues(alpha: 0.18) : palette.surfaceRaised,
        onFocus ? palette.inkOnFocus : palette.accentAmber,
      ),
      StatusChipTone.private => (
        onFocus ? palette.surfaceRaised.withValues(alpha: 0.18) : palette.surfaceMuted,
        onFocus ? palette.inkOnFocus : palette.statusPrivate,
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: ScreenNoteRadii.small,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          data.label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: foreground),
        ),
      ),
    );
  }
}
