import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 任务详情和编辑页共用的信息行。
class TaskMetaRow extends StatelessWidget {
  /// 创建任务信息行。
  const TaskMetaRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
  });

  /// 左侧图标。
  final IconData icon;

  /// 标签。
  final String label;

  /// 值文案。
  final String value;

  /// 点击动作。
  final VoidCallback? onTap;

  /// 右侧尾部控件。
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: palette.surfaceMuted,
            borderRadius: ScreenNoteRadii.small,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: palette.accentAmber),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: palette.inkSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: palette.inkPrimary,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: 12),
          trailing!,
        ],
      ],
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      borderRadius: ScreenNoteRadii.small,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: content,
      ),
    );
  }
}
