import 'package:flutter/material.dart';

import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';

/// 设置条目组件，统一管理标题、副标题与跳转反馈。
class SettingsTile extends StatelessWidget {
  /// 创建设置条目组件。
  const SettingsTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailingLabel,
    required this.onTap,
  });

  /// 条目标题。
  final String title;

  /// 条目副标题。
  final String subtitle;

  /// 尾部动作标签。
  final String trailingLabel;

  /// 点击动作。
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: ScreenNoteRadii.card,
      onTap: onTap,
      child: Container(
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
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              trailingLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ScreenNoteColors.actionBlue,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
