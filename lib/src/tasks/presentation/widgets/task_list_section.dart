import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 12),
        ...children.expand<Widget>((Widget child) => <Widget>[
          child,
          const SizedBox(height: 12),
        ]),
      ],
    );
  }
}
