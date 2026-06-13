import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 共享壳层轻反馈宿主只承接非阻断式提示，
/// 避免把占位反馈升级为打断用户流程的强提醒。
class AppShellFeedbackHost extends StatelessWidget {
  /// 创建共享壳层轻反馈宿主。
  const AppShellFeedbackHost({
    required this.text,
    required this.dismissLabel,
    required this.onClose,
    super.key,
  });

  /// 当前要展示的轻反馈文案。
  final String text;

  /// 关闭反馈按钮文案。
  final String dismissLabel;

  /// 用户主动关闭反馈时触发。
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 12.w, 14.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: theme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            TextButton(
              onPressed: onClose,
              child: Text(dismissLabel),
            ),
          ],
        ),
      ),
    );
  }
}
