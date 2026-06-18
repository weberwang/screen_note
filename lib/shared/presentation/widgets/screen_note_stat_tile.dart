import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 统一展示轻量指标或能力状态的统计卡，避免各页面重复拼装相同的视觉骨架。
class ScreenNoteStatTile extends StatelessWidget {
  /// 创建统计卡。
  const ScreenNoteStatTile({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
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
        borderRadius: ScreenNoteRadii.compactSurface,
        border: Border.all(color: palette.lineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: palette.accentAmber, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: palette.inkPrimary),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
