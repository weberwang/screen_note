import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 快速添加默认值行。
class QuickAddDefaultOptionRow extends StatelessWidget {
  /// 创建快速添加默认值行。
  const QuickAddDefaultOptionRow({
    super.key,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onTap,
  });

  /// 标题。
  final String title;

  /// 说明文案。
  final String body;

  /// 右侧轻动作文案。
  final String actionLabel;

  /// 点击动作。
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: ScreenNoteRadii.card,
      child: Ink(
        padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
        decoration: BoxDecoration(
          color: ScreenNoteColors.surfaceCard,
          borderRadius: ScreenNoteRadii.card,
          border: Border.all(color: ScreenNoteColors.lineSoft),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: const BoxDecoration(
                color: ScreenNoteColors.surfaceMuted,
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              child: Text(
                actionLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: ScreenNoteColors.actionBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
