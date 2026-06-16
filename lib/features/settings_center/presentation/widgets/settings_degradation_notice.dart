import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 设置降级提示组件，统一承接权限受限或能力降级时的轻量提示与操作入口。
class SettingsDegradationNotice extends StatelessWidget {
  /// 创建设置降级提示组件。
  const SettingsDegradationNotice({
    super.key,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  /// 提示标题。
  final String title;

  /// 提示正文。
  final String body;

  /// 操作文案。
  final String actionLabel;

  /// 操作回调。
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6ED),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFF2D5B4)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6E6258),
              ),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
