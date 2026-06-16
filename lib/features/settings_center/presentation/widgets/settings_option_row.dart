import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 设置项行组件，统一封装图标、说明和右侧操作区域的布局骨架。
class SettingsOptionRow extends StatelessWidget {
  /// 创建设置项行组件。
  const SettingsOptionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.trailing,
    this.onTap,
  });

  /// 左侧图标。
  final IconData icon;

  /// 设置项标题。
  final String title;

  /// 设置项说明。
  final String description;

  /// 右侧附加控件。
  final Widget? trailing;

  /// 点击回调。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(
              icon,
              size: 22.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF5F6762),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...<Widget>[
            SizedBox(width: 12.w),
            Flexible(child: trailing!),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: content,
    );
  }
}
