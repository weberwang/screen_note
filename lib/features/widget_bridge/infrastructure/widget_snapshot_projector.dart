import 'package:flutter/widgets.dart';

import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot_item.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 小组件快照投影器，负责把任务事实源和设置偏好转换成共享锁屏合同。
final class WidgetSnapshotProjector {
  /// 创建投影器。
  const WidgetSnapshotProjector();

  /// 执行快照投影；这里固定只消费稳定事实源，不重新查询数据库或引入额外业务状态。
  WidgetSnapshot project({
    required TaskFeedSnapshot taskFeed,
    required SettingsPreferences preferences,
    required Locale locale,
    DateTime? now,
    bool hasFallbackContent = false,
  }) {
    final DateTime timestamp = now ?? DateTime.now();
    final AppLocalizations localizations = lookupAppLocalizations(
      _resolveSupportedLocale(locale),
    );
    final List<TaskEntity> orderedTasks = <TaskEntity>[
      ...taskFeed.pinnedTasks,
      ...taskFeed.overdueTasks,
      ...taskFeed.todayTasks,
      ...taskFeed.otherTasks,
    ];
    final List<TaskEntity> privateTasks = orderedTasks
        .where((TaskEntity task) => task.isPrivate)
        .toList(growable: false);

    final List<WidgetSnapshotItem> items = switch (preferences.widgetDisplayMode) {
      WidgetDisplayMode.single => _projectGeneralItems(
        orderedTasks: orderedTasks,
        localizations: localizations,
        preferences: preferences,
        now: timestamp,
        limit: 1,
      ),
      WidgetDisplayMode.list3 => _projectGeneralItems(
        orderedTasks: orderedTasks,
        localizations: localizations,
        preferences: preferences,
        now: timestamp,
        limit: 3,
      ),
      WidgetDisplayMode.today => _projectTodayItems(
        taskFeed: taskFeed,
        orderedTasks: orderedTasks,
        localizations: localizations,
        preferences: preferences,
        now: timestamp,
      ),
      WidgetDisplayMode.private => _projectPrivateSummary(
        localizations: localizations,
        privateCount: privateTasks.length,
      ),
      WidgetDisplayMode.empty => const <WidgetSnapshotItem>[],
    };

    return WidgetSnapshot(
      snapshotId: 'widget_${timestamp.toUtc().millisecondsSinceEpoch}',
      generatedAt: timestamp.toUtc(),
      displayMode: preferences.widgetDisplayMode,
      items: items,
      hasPrivateContent: privateTasks.isNotEmpty,
      hasFallbackContent: hasFallbackContent,
      version: 1,
    );
  }

  List<WidgetSnapshotItem> _projectGeneralItems({
    required List<TaskEntity> orderedTasks,
    required AppLocalizations localizations,
    required SettingsPreferences preferences,
    required DateTime now,
    required int limit,
  }) {
    return orderedTasks
        .take(limit)
        .toList(growable: false)
        .asMap()
        .entries
        .map(
          (entry) => _toSnapshotItem(
            task: entry.value,
            localizations: localizations,
            preferences: preferences,
            now: now,
            rank: entry.key + 1,
          ),
        )
        .toList(growable: false);
  }

  List<WidgetSnapshotItem> _projectTodayItems({
    required TaskFeedSnapshot taskFeed,
    required List<TaskEntity> orderedTasks,
    required AppLocalizations localizations,
    required SettingsPreferences preferences,
    required DateTime now,
  }) {
    final TaskEntity? selectedTask = taskFeed.todayTasks.isNotEmpty
        ? taskFeed.todayTasks.first
        : orderedTasks.isNotEmpty
        ? orderedTasks.first
        : null;
    if (selectedTask == null) {
      return const <WidgetSnapshotItem>[];
    }

    return <WidgetSnapshotItem>[
      _toSnapshotItem(
        task: selectedTask,
        localizations: localizations,
        preferences: preferences,
        now: now,
        rank: 1,
      ),
    ];
  }

  List<WidgetSnapshotItem> _projectPrivateSummary({
    required AppLocalizations localizations,
    required int privateCount,
  }) {
    return <WidgetSnapshotItem>[
      WidgetSnapshotItem(
        title: localizations.widgetPreviewPrivateState,
        statusLabel: localizations.statusPrivate,
        dueLabel: localizations.widgetPreviewPrivateSummary(privateCount),
        isPinned: false,
        isOverdue: false,
        isPrivate: true,
        rank: 1,
      ),
    ];
  }

  WidgetSnapshotItem _toSnapshotItem({
    required TaskEntity task,
    required AppLocalizations localizations,
    required SettingsPreferences preferences,
    required DateTime now,
    required int rank,
  }) {
    final bool isOverdue = _isOverdue(task, now);
    final bool isDueToday = _isDueToday(task, now);
    final bool maskPrivateContent = preferences.maskPrivateContent && task.isPrivate;

    return WidgetSnapshotItem(
      title: maskPrivateContent ? localizations.privateMaskedTitle : task.title,
      statusLabel: _buildStatusLabel(
        task: task,
        localizations: localizations,
        isOverdue: isOverdue,
        isDueToday: isDueToday,
        maskPrivateContent: maskPrivateContent,
      ),
      dueLabel: _buildDueLabel(
        task: task,
        localizations: localizations,
        isDueToday: isDueToday,
      ),
      isPinned: task.isPinned,
      isOverdue: isOverdue,
      isPrivate: task.isPrivate,
      rank: rank,
    );
  }

  String _buildStatusLabel({
    required TaskEntity task,
    required AppLocalizations localizations,
    required bool isOverdue,
    required bool isDueToday,
    required bool maskPrivateContent,
  }) {
    if (isOverdue) {
      return localizations.statusOverdue;
    }
    if (isDueToday) {
      return localizations.statusToday;
    }
    if (task.isPinned) {
      return localizations.statusPinned;
    }
    if (maskPrivateContent) {
      return localizations.statusPrivate;
    }
    return '';
  }

  String _buildDueLabel({
    required TaskEntity task,
    required AppLocalizations localizations,
    required bool isDueToday,
  }) {
    final DateTime? dueAt = task.dueAt?.toLocal();
    if (dueAt == null) {
      return '';
    }

    if (isDueToday) {
      return _formatClock(dueAt);
    }

    return _formatMonthDayClock(dueAt);
  }

  bool _isDueToday(TaskEntity task, DateTime now) {
    final DateTime? dueAt = task.dueAt?.toLocal();
    if (dueAt == null) {
      return false;
    }

    final DateTime timestamp = now.toLocal();
    return dueAt.year == timestamp.year &&
        dueAt.month == timestamp.month &&
        dueAt.day == timestamp.day;
  }

  bool _isOverdue(TaskEntity task, DateTime now) {
    final DateTime? dueAt = task.dueAt?.toLocal();
    if (dueAt == null) {
      return false;
    }

    final DateTime timestamp = now.toLocal();
    final DateTime startOfToday = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );
    return dueAt.isBefore(startOfToday);
  }

  Locale _resolveSupportedLocale(Locale locale) {
    return AppLocalizations.supportedLocales.any(
          (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
        )
        ? Locale(locale.languageCode)
        : AppLocalizations.supportedLocales.first;
  }

  /// 手写时间格式，避免锁屏快照投影依赖额外的 locale 数据初始化。
  String _formatClock(DateTime timestamp) {
    final String hour = timestamp.hour.toString().padLeft(2, '0');
    final String minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// 月日+时间采用稳定中文格式，与现有冻结预览里的信息密度保持一致。
  String _formatMonthDayClock(DateTime timestamp) {
    return '${timestamp.month}月${timestamp.day}日 ${_formatClock(timestamp)}';
  }
}
