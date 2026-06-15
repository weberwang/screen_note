import 'package:flutter/widgets.dart';

import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot_item.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// Widget 快照投影器，负责把稳定任务快照和设置偏好转换成共享展示合同。
final class WidgetSnapshotProjector {
  /// 创建 Widget 快照投影器。
  const WidgetSnapshotProjector();

  /// 执行投影；这里只消费稳定事实源，不在桥接层引入新的查询或排序规则。
  WidgetSnapshot project({
    required TaskFeedSnapshot taskFeed,
    required SettingsCenterPreferences preferences,
    DateTime? now,
    bool hasFallbackContent = false,
  }) {
    final DateTime timestamp = now ?? DateTime.now();
    final AppLocalizations localizations = lookupAppLocalizations(
      _localeFromPreferences(preferences),
    );
    final List<TaskEntity> orderedTasks = <TaskEntity>[
      ...taskFeed.pinnedTasks,
      ...taskFeed.overdueTasks,
      ...taskFeed.todayTasks,
      ...taskFeed.otherTasks,
    ];
    // 共享快照一次最多输出 3 条，后续各平台只负责按尺寸裁剪前 N 条。
    final List<WidgetSnapshotItem> items = orderedTasks
        .take(3)
        .indexed
        .map(
          ((int, TaskEntity) entry) => _toSnapshotItem(
            task: entry.$2,
            rank: entry.$1 + 1,
            preferences: preferences,
            localizations: localizations,
            now: timestamp,
          ),
        )
        .toList(growable: false);

    return WidgetSnapshot(
      snapshotId: 'widget_${timestamp.toUtc().millisecondsSinceEpoch}',
      generatedAt: timestamp.toUtc(),
      displayMode: preferences.widgetDisplayMode,
      headerTitle: _buildHeaderTitle(
        localizations: localizations,
        displayMode: preferences.widgetDisplayMode,
      ),
      emptyTitle: localizations.widgetSnapshotEmptyTitle,
      emptyBody: localizations.widgetSnapshotEmptyBody,
      fallbackHint: localizations.widgetSnapshotFallbackHint,
      items: items,
      // 该标记只描述本次实际下发给 Widget 的条目里是否含有原始私密事项，
      // 避免被截断到第 4 条之后的任务把当前 payload 语义污染掉。
      hasPrivateContent: items.any((WidgetSnapshotItem item) => item.isPrivate),
      hasFallbackContent: hasFallbackContent,
      version: 2,
    );
  }

  /// 头部标题直接复用当前设置页的展示模式命名，避免 Widget 与设置页说两套语言。
  String _buildHeaderTitle({
    required AppLocalizations localizations,
    required WidgetDisplayMode displayMode,
  }) {
    return switch (displayMode) {
      WidgetDisplayMode.single =>
        localizations.settingsWidgetDisplayFullContent,
      WidgetDisplayMode.list3 =>
        localizations.settingsWidgetDisplayFullContent,
      WidgetDisplayMode.today =>
        localizations.settingsWidgetDisplayFullContent,
      WidgetDisplayMode.private =>
        localizations.settingsWidgetDisplayPreviewOnly,
      WidgetDisplayMode.empty =>
        localizations.settingsWidgetDisplayPreviewOnly,
      WidgetDisplayMode.previewOnly =>
        localizations.settingsWidgetDisplayPreviewOnly,
      WidgetDisplayMode.fullContent =>
        localizations.settingsWidgetDisplayFullContent,
    };
  }

  WidgetSnapshotItem _toSnapshotItem({
    required TaskEntity task,
    required int rank,
    required SettingsCenterPreferences preferences,
    required AppLocalizations localizations,
    required DateTime now,
  }) {
    final bool isOverdue = _isOverdue(task, now);
    final bool isDueToday = _isDueToday(task, now);
    final bool shouldMask =
        task.isPrivate ||
        preferences.privacyModeEnabled ||
        preferences.widgetDisplayMode == WidgetDisplayMode.previewOnly;

    if (shouldMask) {
      final bool isPrivate = task.isPrivate || preferences.privacyModeEnabled;
      return WidgetSnapshotItem(
        taskId: task.id,
        launchTarget: 'task',
        title: isPrivate
            ? localizations.widgetSnapshotPrivateTitle
            : localizations.widgetSnapshotPreviewTitle,
        statusLabel: isPrivate
            ? localizations.widgetSnapshotStatusPrivate
            : localizations.widgetSnapshotStatusPreview,
        dueLabel: localizations.widgetSnapshotOpenInApp,
        isPinned: task.isPinned,
        isOverdue: isOverdue,
        isPrivate: task.isPrivate,
        rank: rank,
      );
    }

    return WidgetSnapshotItem(
      taskId: task.id,
      launchTarget: 'task',
      title: task.title,
      statusLabel: _buildStatusLabel(
        task: task,
        localizations: localizations,
        isOverdue: isOverdue,
        isDueToday: isDueToday,
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
  }) {
    if (isOverdue) {
      return localizations.widgetSnapshotStatusOverdue;
    }
    if (isDueToday) {
      return localizations.widgetSnapshotStatusToday;
    }
    if (task.isPinned) {
      return localizations.widgetSnapshotStatusPinned;
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
      return localizations.widgetSnapshotOpenInApp;
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

  /// Widget 文案跟随用户已保存的语言偏好，避免应用与小组件分属不同语言环境。
  Locale _localeFromPreferences(SettingsCenterPreferences preferences) {
    return switch (preferences.languagePreference) {
      SettingsLanguagePreference.zh => const Locale('zh'),
      SettingsLanguagePreference.en => const Locale('en'),
    };
  }

  /// 手写时钟格式，避免桥接层额外依赖 locale 初始化。
  String _formatClock(DateTime timestamp) {
    final String hour = timestamp.hour.toString().padLeft(2, '0');
    final String minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// 月日+时间采用稳定紧凑格式，兼顾 Widget 的窄宽度和信息密度。
  String _formatMonthDayClock(DateTime timestamp) {
    return '${timestamp.month}/${timestamp.day} ${_formatClock(timestamp)}';
  }
}
