import 'package:flutter/material.dart';

/// 设置分组组件，统一承载一个分组标题和若干设置条目。
class SettingsGroup extends StatelessWidget {
  /// 创建设置分组组件。
  const SettingsGroup({
    super.key,
    required this.title,
    required this.children,
  });

  /// 分组标题。
  final String title;

  /// 分组内条目。
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}
