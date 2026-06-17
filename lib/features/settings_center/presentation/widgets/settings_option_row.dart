import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 设置行组件，统一承接图标、标题、说明和右侧当前值或动作。
class SettingsOptionRow extends StatelessWidget {
  /// 创建设置行组件。
  const SettingsOptionRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.trailing,
    super.key,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        child: Row(
          children: <Widget>[
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F2),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF4D8B52),
                size: 24.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5F6762),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            trailing,
          ],
        ),
      ),
    );
  }
}
