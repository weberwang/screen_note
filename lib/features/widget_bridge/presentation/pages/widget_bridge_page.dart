import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// Widget 桥接占位页，用于验证稳定快照、隐私投影与展示模式入口已接好路由。
class WidgetBridgePage extends StatelessWidget {
  /// 创建 Widget 桥接占位页。
  const WidgetBridgePage({super.key});

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
                localizations.widgetSettingsTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                localizations.widgetSettingsSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: ScreenNoteSpacing.sectionGap),
        _WidgetModeCard(
          title: localizations.widgetInstallGuideTitle,
          body: localizations.widgetInstallGuideBody,
          icon: Icons.phone_iphone_outlined,
        ),
        const SizedBox(height: 16),
        _WidgetModeCard(
          title: localizations.widgetFallbackPreviewTitle,
          body: localizations.widgetPreviewFallbackHint,
          icon: Icons.refresh_rounded,
        ),
        const SizedBox(height: 16),
        _WidgetModeCard(
          title: localizations.privacyExplainTitle,
          body: localizations.privacyExplainBody,
          icon: Icons.lock_outline_rounded,
        ),
      ],
    );
  }
}

/// Widget 能力卡片，显式标出快照、容错和隐私三类初始化职责。
class _WidgetModeCard extends StatelessWidget {
  /// 创建 Widget 能力卡片。
  const _WidgetModeCard({
    required this.title,
    required this.body,
    required this.icon,
  });

  /// 标题。
  final String title;

  /// 正文。
  final String body;

  /// 图标。
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
            child: Icon(icon, color: palette.statusPrivate),
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
