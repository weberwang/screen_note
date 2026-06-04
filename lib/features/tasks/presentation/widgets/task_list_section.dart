import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 事项列表分组容器。
class TaskListSection extends StatelessWidget {
  /// 创建事项列表分组容器。
  const TaskListSection({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
  });

  /// 分组标题。
  final String title;

  /// 分组子节点。
  final List<Widget> children;

  /// 标题尾部操作。
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: palette.inkPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                color: palette.lineSoft,
              ),
            ),
            if (trailing != null) ...<Widget>[
              const SizedBox(width: 12),
              trailing!,
            ],
          ],
        ),
        const SizedBox(height: 14),
        ...children.expand<Widget>((Widget child) => <Widget>[
          child,
          const SizedBox(height: 12),
        ]),
      ],
    );
  }
}
