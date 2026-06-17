import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 设置分区头组件，统一承接低噪音小节标签，避免页面层重复手写层级样式。
class SettingsSectionHeader extends StatelessWidget {
  /// 创建设置分区头组件。
  const SettingsSectionHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontSize: 11.sp,
        color: const Color(0xFF7B837E),
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
