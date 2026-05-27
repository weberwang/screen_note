import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 快速添加错误提示。
class QuickAddErrorHint extends StatelessWidget {
  /// 创建快速添加错误提示。
  const QuickAddErrorHint({
    super.key,
    required this.message,
  });

  /// 错误提示文案。
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceCard,
        borderRadius: ScreenNoteRadii.card,
        border: Border.all(color: ScreenNoteColors.statusOverdue),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: ScreenNoteColors.statusOverdue,
        ),
      ),
    );
  }
}
