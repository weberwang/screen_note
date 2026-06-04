import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 历史中心占位页，用于承接最近完成、最近删除与恢复入口的路由骨架。
class HistoryCenterPage extends StatelessWidget {
  /// 创建历史中心占位页。
  const HistoryCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        ScreenNoteSpacing.pageHorizontal,
        12,
        ScreenNoteSpacing.pageHorizontal,
        112,
      ),
      children: <Widget>[
        ScreenNotePanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                localizations.historyCompletedTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                localizations.bootstrapPlaceholderBody,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: ScreenNoteSpacing.sectionGap),
        _HistoryEntryCard(
          title: localizations.historyCompletedTitle,
          body: localizations.taskCompleteSuccess,
          icon: Icons.check_circle_outline_rounded,
        ),
        const SizedBox(height: 16),
        _HistoryEntryCard(
          title: localizations.historyDeletedTitle,
          body: localizations.restoreDialogBody,
          icon: Icons.restore_from_trash_outlined,
        ),
      ],
    );
  }
}

/// 历史入口卡片，初始化阶段只强调后续会接入统一状态恢复链路。
class _HistoryEntryCard extends StatelessWidget {
  /// 创建历史入口卡片。
  const _HistoryEntryCard({
    required this.title,
    required this.body,
    required this.icon,
  });

  /// 卡片标题。
  final String title;

  /// 卡片正文。
  final String body;

  /// 卡片图标。
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return ScreenNotePanel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: palette.surfaceRaised,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: palette.accentAmber),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
