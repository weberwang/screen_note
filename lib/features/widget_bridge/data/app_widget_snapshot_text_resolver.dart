import 'dart:ui';

import 'package:screen_note/l10n/app_localizations.dart';

import 'package:screen_note/features/tasks/application/services/task_display_state_resolver.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/shared/utils/date_time_formatter.dart';
import '../application/widget_snapshot_builder.dart';

/// Widget 快照文案解析器实现。
///
/// Widget 快照需要在无 `BuildContext` 的应用层刷新流程里生成，因此这里用
/// 当前语言环境直接解析本地化资源，再把安全文案写入共享快照。
final class AppWidgetSnapshotTextResolver
    implements WidgetSnapshotTextResolver {
  /// 创建 Widget 快照文案解析器。
  AppWidgetSnapshotTextResolver({
    Locale Function()? localeProvider,
  }) : _localeProvider = localeProvider ?? (() => PlatformDispatcher.instance.locale);

  final Locale Function() _localeProvider;

  @override
  String dueLabelForTask(Task task) {
    final DateTime? dueAt = task.dueAt;
    if (dueAt == null || task.isPrivate) {
      return '';
    }
    return ScreenNoteDateTimeFormatter.formatDateTime(dueAt);
  }

  @override
  String emptyTitle() => _localizations.widgetPreviewEmptyHint;

  @override
  String fallbackHint() => _localizations.widgetPreviewFallbackHint;

  @override
  String privateSummary({required int itemCount}) {
    return _localizations.widgetPreviewPrivateSummary(itemCount);
  }

  @override
  String statusLabelForTask(Task task, {required TaskDisplayState state}) {
    switch (state) {
      case TaskDisplayState.overdue:
        return _localizations.statusOverdue;
      case TaskDisplayState.today:
        return _localizations.statusToday;
      case TaskDisplayState.privateMasked:
        return _localizations.statusPrivate;
      case TaskDisplayState.completed:
        return _localizations.statusCompleted;
      case TaskDisplayState.deleted:
        return _localizations.statusDeleted;
      case TaskDisplayState.active:
        if (task.isPinned) {
          return _localizations.statusPinned;
        }
        return '';
    }
  }

  AppLocalizations get _localizations {
    return lookupAppLocalizations(_localeProvider());
  }
}
