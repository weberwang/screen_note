import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/history_center/application/providers/history_center_runtime_providers.dart';
import 'package:screen_note/features/history_center/domain/entities/history_section.dart';
import 'package:screen_note/features/history_center/domain/entities/history_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 历史中心正式页，负责展示最近完成、最近删除与恢复主链路。
class HistoryCenterPage extends ConsumerWidget {
  /// 创建历史中心页。
  const HistoryCenterPage({
    super.key,
    this.initialSection = HistorySection.completed,
  });

  /// 首次进入时的分区；路由 query 会把它稳定映射成最近完成或最近删除。
  final HistorySection initialSection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HistorySnapshot> snapshotAsync = ref.watch(
      historyCenterControllerProvider,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        ScreenNoteSpacing.pageHorizontal,
        12,
        ScreenNoteSpacing.pageHorizontal,
        112,
      ),
      children: <Widget>[
        _HeaderCard(section: initialSection),
        const SizedBox(height: 16),
        _SectionSwitcher(section: initialSection),
        const SizedBox(height: ScreenNoteSpacing.sectionGap),
        snapshotAsync.when(
          data: (HistorySnapshot snapshot) {
            return _HistoryContent(
              section: initialSection,
              snapshot: snapshot,
            );
          },
          loading: () => const _LoadingCard(),
          error: (Object _, StackTrace __) => _ErrorCard(
            onRetry: () => ref.invalidate(historyCenterControllerProvider),
          ),
        ),
      ],
    );
  }
}

/// 历史页头部卡片，固定当前分区标题和说明，避免用户误判自己所在上下文。
class _HeaderCard extends StatelessWidget {
  /// 创建历史页头部卡片。
  const _HeaderCard({required this.section});

  /// 当前分区。
  final HistorySection section;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_title(localizations), style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 12),
          Text(
            _subtitle(localizations),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  String _title(AppLocalizations localizations) {
    return switch (section) {
      HistorySection.completed => localizations.historyCompletedTitle,
      HistorySection.deleted => localizations.historyDeletedTitle,
    };
  }

  String _subtitle(AppLocalizations localizations) {
    return switch (section) {
      HistorySection.completed => localizations.emptyCompletedTasksBody,
      HistorySection.deleted => localizations.deletedRetentionHint,
    };
  }
}

/// 分区切换器，统一把最近完成和最近删除收口到同一路由而不拆双页面。
class _SectionSwitcher extends StatelessWidget {
  /// 创建分区切换器。
  const _SectionSwitcher({required this.section});

  /// 当前分区。
  final HistorySection section;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return SegmentedButton<HistorySection>(
      segments: <ButtonSegment<HistorySection>>[
        ButtonSegment<HistorySection>(
          value: HistorySection.completed,
          label: Text(localizations.historyCompletedTitle),
          icon: const Icon(Icons.check_circle_outline_rounded),
        ),
        ButtonSegment<HistorySection>(
          value: HistorySection.deleted,
          label: Text(localizations.historyDeletedTitle),
          icon: const Icon(Icons.restore_from_trash_outlined),
        ),
      ],
      selected: <HistorySection>{section},
      onSelectionChanged: (Set<HistorySection> selection) {
        final HistorySection nextSection = selection.first;
        context.go(
          '${RoutePaths.historyCenter}?section=${nextSection.queryValue}',
        );
      },
      showSelectedIcon: false,
    );
  }
}

/// 历史页主体内容，负责在不同分区下复用同一套列表与空态骨架。
class _HistoryContent extends ConsumerWidget {
  /// 创建历史页主体内容。
  const _HistoryContent({required this.section, required this.snapshot});

  /// 当前分区。
  final HistorySection section;

  /// 历史快照。
  final HistorySnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final List<TaskEntity> tasks = switch (section) {
      HistorySection.completed => snapshot.completedTasks,
      HistorySection.deleted => snapshot.deletedTasks,
    };

    if (tasks.isEmpty) {
      return _EmptyCard(section: section);
    }

    Future<void> restoreTask(String taskId) async {
      await ref.read(historyCenterControllerProvider.notifier).restoreTask(taskId);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(localizations.taskRestoreSuccess)),
          );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (section == HistorySection.deleted) ...<Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              localizations.deletedRetentionHint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
        ...tasks.map(
          (TaskEntity task) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _HistoryRecordCard(
              section: section,
              task: task,
              onRestore: section == HistorySection.deleted
                  ? () => restoreTask(task.id)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

/// 历史记录卡片，统一承接标题、时间和恢复动作层级。
class _HistoryRecordCard extends StatelessWidget {
  /// 创建历史记录卡片。
  const _HistoryRecordCard({
    required this.section,
    required this.task,
    this.onRestore,
  });

  /// 当前分区。
  final HistorySection section;

  /// 当前任务。
  final TaskEntity task;

  /// 恢复动作；仅最近删除分区会传入。
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _buildStatusChips(context, section, task),
          ),
          const SizedBox(height: 12),
          Text(
            _displayTitle(localizations),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            _displayBody(localizations),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Text(
            _timeSummary(context),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          if (onRestore != null) ...<Widget>[
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onRestore,
              icon: const Icon(Icons.restore_rounded),
              label: Text(localizations.taskRestoreAction),
            ),
          ],
        ],
      ),
    );
  }

  /// 历史页默认优先保护隐私事项正文，避免回看页把受控内容重新暴露到外层列表。
  String _displayTitle(AppLocalizations localizations) {
    return task.isPrivate ? localizations.privateMaskedTitle : task.title;
  }

  String _displayBody(AppLocalizations localizations) {
    if (task.isPrivate) {
      return localizations.taskPrivateMaskedBody;
    }
    if (task.note.trim().isNotEmpty) {
      return task.note.trim();
    }
    return switch (section) {
      HistorySection.completed => localizations.taskCompleteSuccess,
      HistorySection.deleted => localizations.restoreDialogBody,
    };
  }

  String _timeSummary(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final DateTime? timestamp = switch (section) {
      HistorySection.completed => task.completedAt,
      HistorySection.deleted => task.deletedAt,
    };
    final DateFormat formatter = DateFormat(
      'M月d日 HH:mm',
      localizations.localeName,
    );
    final String prefix = switch (section) {
      HistorySection.completed => localizations.statusCompleted,
      HistorySection.deleted => localizations.statusDeleted,
    };
    if (timestamp == null) {
      return prefix;
    }
    return '$prefix ${formatter.format(timestamp.toLocal())}';
  }
}

/// 空态卡片，在没有历史记录时保持低压力反馈。
class _EmptyCard extends StatelessWidget {
  /// 创建空态卡片。
  const _EmptyCard({required this.section});

  /// 当前分区。
  final HistorySection section;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_title(localizations), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            _body(localizations),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _title(AppLocalizations localizations) {
    return switch (section) {
      HistorySection.completed => localizations.emptyCompletedTasksTitle,
      HistorySection.deleted => localizations.emptyDeletedTasksTitle,
    };
  }

  String _body(AppLocalizations localizations) {
    return switch (section) {
      HistorySection.completed => localizations.emptyCompletedTasksBody,
      HistorySection.deleted => localizations.emptyDeletedTasksBody,
    };
  }
}

/// 加载态卡片，避免历史页切换时整页闪烁。
class _LoadingCard extends StatelessWidget {
  /// 创建加载态卡片。
  const _LoadingCard();

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

/// 错误态卡片，允许用户停留当前分区直接重试。
class _ErrorCard extends StatelessWidget {
  /// 创建错误态卡片。
  const _ErrorCard({required this.onRetry});

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
            localizations.taskHistoryLoadFailed,
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

/// 构建历史状态标签，避免完成/删除列表分别维护一套重复视觉规则。
List<Widget> _buildStatusChips(
  BuildContext context,
  HistorySection section,
  TaskEntity task,
) {
  final AppLocalizations localizations = AppLocalizations.of(context);
  final List<String> labels = <String>[
    switch (section) {
      HistorySection.completed => localizations.statusCompleted,
      HistorySection.deleted => localizations.statusDeleted,
    },
  ];
  if (task.isPrivate) {
    labels.add(localizations.statusPrivate);
  }
  if (section == HistorySection.deleted) {
    labels.add(localizations.remainingDaysLabel(_remainingDays(task)));
  }

  return labels
      .map((String label) => _StatusChip(label: label))
      .toList(growable: false);
}

/// 计算删除保留剩余天数；负数统一截断为 0，避免历史异常数据展示出负天数。
int _remainingDays(TaskEntity task) {
  final DateTime? deletedAt = task.deletedAt;
  if (deletedAt == null) {
    return 0;
  }
  final DateTime expiresAt = deletedAt.toLocal().add(const Duration(days: 30));
  final DateTime today = DateTime.now();
  final DateTime startOfToday = DateTime(today.year, today.month, today.day);
  final DateTime endOfToday = DateTime(
    expiresAt.year,
    expiresAt.month,
    expiresAt.day,
  );
  final int difference = endOfToday.difference(startOfToday).inDays;
  return difference < 0 ? 0 : difference;
}

/// 弱化状态标签，保证恢复动作仍比辅助标签更显眼。
class _StatusChip extends StatelessWidget {
  /// 创建状态标签。
  const _StatusChip({required this.label});

  /// 标签文案。
  final String label;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: ScreenNoteRadii.small,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(label, style: Theme.of(context).textTheme.labelSmall),
      ),
    );
  }
}
