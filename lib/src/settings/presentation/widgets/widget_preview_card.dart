import 'package:flutter/material.dart';

import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';

/// Widget 预览卡，只模拟稳定快照展示，不承载真实系统查询逻辑。
class WidgetPreviewCard extends StatelessWidget {
  /// 创建 Widget 预览卡。
  const WidgetPreviewCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.previewTitle,
    required this.previewBody,
  });

  /// 区块标题。
  final String title;

  /// 区块说明。
  final String subtitle;

  /// 预览主标题。
  final String previewTitle;

  /// 预览次说明。
  final String previewBody;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceMuted,
        borderRadius: ScreenNoteRadii.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
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
                  previewTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  previewBody,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
