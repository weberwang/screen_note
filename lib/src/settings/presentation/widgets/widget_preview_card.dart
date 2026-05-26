import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/widget_bridge/domain/enums/widget_display_mode.dart';

/// 锁屏小组件预览卡片。
///
/// 预览卡只消费固定的展示模式和安全文案，不读取真实数据库，
/// 这样可以保证 App 内预览与原生 Widget 都围绕同一套稳定快照语义工作。
class WidgetPreviewCard extends StatelessWidget {
  /// 创建锁屏小组件预览卡片。
  const WidgetPreviewCard({
    super.key,
    required this.displayMode,
  });

  /// 当前要模拟的展示模式。
  final WidgetDisplayMode displayMode;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final _WidgetPreviewContent content = _contentForMode(localizations);

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
            localizations.widgetSettingsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            localizations.widgetSettingsSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
            decoration: BoxDecoration(
              color: ScreenNoteColors.surfaceCard,
              borderRadius: ScreenNoteRadii.card,
              border: Border.all(color: ScreenNoteColors.lineSoft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  content.header,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                ...content.rows.map((Widget child) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: child,
                  );
                }),
                if (content.footer case final String footer)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ScreenNoteColors.surfaceMuted,
                      borderRadius: ScreenNoteRadii.small,
                    ),
                    child: Text(
                      footer,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _WidgetPreviewContent _contentForMode(AppLocalizations localizations) {
    return switch (displayMode) {
      WidgetDisplayMode.single => _WidgetPreviewContent(
        header: localizations.widgetDisplayModeSingle,
        rows: <Widget>[
          _PreviewRow(
            title: localizations.widgetPreviewSingleTitle,
            status: localizations.statusPinned,
            dueLabel: localizations.widgetPreviewDueToday,
            rank: '1',
          ),
        ],
      ),
      WidgetDisplayMode.list3 => _WidgetPreviewContent(
        header: localizations.widgetDisplayModeList3,
        rows: <Widget>[
          _PreviewRow(
            title: localizations.widgetPreviewListItemOne,
            status: localizations.statusPinned,
            dueLabel: '',
            rank: '1',
          ),
          _PreviewRow(
            title: localizations.widgetPreviewListItemTwo,
            status: localizations.statusOverdue,
            dueLabel: localizations.widgetPreviewDueYesterday,
            rank: '2',
            emphasizeStatusColor: ScreenNoteColors.statusOverdue,
          ),
          _PreviewRow(
            title: localizations.widgetPreviewListItemThree,
            status: localizations.statusPrivate,
            dueLabel: '',
            rank: '3',
            emphasizeStatusColor: ScreenNoteColors.statusPrivate,
          ),
        ],
      ),
      WidgetDisplayMode.today => _WidgetPreviewContent(
        header: localizations.widgetDisplayModeToday,
        rows: <Widget>[
          _PreviewRow(
            title: localizations.widgetPreviewTodayTitle,
            status: localizations.statusToday,
            dueLabel: localizations.widgetPreviewDueToday,
            rank: '1',
            emphasizeStatusColor: ScreenNoteColors.accentAmber,
          ),
        ],
      ),
      WidgetDisplayMode.private => _WidgetPreviewContent(
        header: localizations.widgetDisplayModePrivate,
        rows: <Widget>[
          _PreviewRow(
            title: localizations.widgetPreviewPrivateSummary(3),
            status: localizations.statusPrivate,
            dueLabel: '',
            rank: '•',
            emphasizeStatusColor: ScreenNoteColors.statusPrivate,
          ),
        ],
      ),
      WidgetDisplayMode.empty => _WidgetPreviewContent(
        header: localizations.widgetDisplayModeEmpty,
        rows: <Widget>[
          _EmptyPreviewCard(
            title: localizations.widgetPreviewEmptyHint,
            body: localizations.widgetPreviewEmptyBody,
          ),
        ],
        footer: localizations.widgetFallbackPreviewTitle,
      ),
    };
  }
}

/// 预览模式内容。
class _WidgetPreviewContent {
  /// 创建预览模式内容。
  const _WidgetPreviewContent({
    required this.header,
    required this.rows,
    this.footer,
  });

  /// 顶部模式标题。
  final String header;

  /// 预览行列表。
  final List<Widget> rows;

  /// 可选底部提示。
  final String? footer;
}

/// 预览行。
class _PreviewRow extends StatelessWidget {
  /// 创建预览行。
  const _PreviewRow({
    required this.title,
    required this.status,
    required this.dueLabel,
    required this.rank,
    this.emphasizeStatusColor,
  });

  /// 标题。
  final String title;

  /// 状态标签。
  final String status;

  /// 截止时间标签。
  final String dueLabel;

  /// 排名或序号。
  final String rank;

  /// 可选状态强调色。
  final Color? emphasizeStatusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceCard,
        borderRadius: ScreenNoteRadii.small,
        border: Border.all(color: ScreenNoteColors.lineSoft),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: <Widget>[
                    Text(
                      status,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: emphasizeStatusColor ?? ScreenNoteColors.accentAmber,
                      ),
                    ),
                    if (dueLabel.isNotEmpty)
                      Text(
                        dueLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            rank,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: ScreenNoteColors.inkSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 空态预览卡。
class _EmptyPreviewCard extends StatelessWidget {
  /// 创建空态预览卡。
  const _EmptyPreviewCard({
    required this.title,
    required this.body,
  });

  /// 空态标题。
  final String title;

  /// 空态说明。
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceCard,
        borderRadius: ScreenNoteRadii.small,
        border: Border.all(color: ScreenNoteColors.lineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
