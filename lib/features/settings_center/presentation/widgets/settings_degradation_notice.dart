import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 设置降级提示组件，统一表达权限或平台能力不足，但不把页面升级成错误页。
class SettingsDegradationNotice extends StatelessWidget {
  /// 创建设置降级提示组件。
  const SettingsDegradationNotice({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });

  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4EE),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFECE4),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: const Color(0xFFE96A5A),
              size: 26.sp,
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
                    color: const Color(0xFFE96A5A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFB45447),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          OutlinedButton(
            onPressed: onAction,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE96A5A),
              side: const BorderSide(color: Color(0x66E96A5A)),
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
