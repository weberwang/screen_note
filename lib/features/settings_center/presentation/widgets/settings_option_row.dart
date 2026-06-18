import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 设置行组件，统一承接图标、标题和右侧当前值或动作。
class SettingsOptionRow extends StatelessWidget {
  /// 创建设置行组件。
  const SettingsOptionRow({
    required this.icon,
    required this.title,
    required this.trailing,
    super.key,
    this.onTap,
  });

  /// 左侧图标。
  final IconData icon;

  /// 主标题。
  final String title;

  /// 右侧状态值或动作。
  final Widget trailing;

  /// 点击动作。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: ScreenNoteRadii.queueRow,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        child: Row(
          children: <Widget>[
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F2),
                borderRadius: ScreenNoteRadii.compactSurface,
              ),
              child: Icon(icon, color: const Color(0xFF4D8B52), size: 24.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
