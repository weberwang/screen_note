import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 统一展示初始化指标或能力开关的轻量统计块。
class ScreenNoteStatTile extends StatelessWidget {
  /// 创建统计块。
  const ScreenNoteStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  /// 指标标签。
  final String label;

  /// 指标值。
  final String value;

  /// 指标图标。
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: ScreenNoteRadii.small,
        border: Border.all(color: palette.lineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: palette.accentAmber, size: 20),
            const SizedBox(height: 10),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: palette.inkPrimary),
            ),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
