import 'package:flutter/material.dart';

/// 设置区块标题组件，统一承接分组标题的层级与间距语义。
class SettingsSectionHeader extends StatelessWidget {
  /// 创建设置区块标题组件。
  const SettingsSectionHeader({
    super.key,
    required this.title,
  });

  /// 分组标题文案。
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
