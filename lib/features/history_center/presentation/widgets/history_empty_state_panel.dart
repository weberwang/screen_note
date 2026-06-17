import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 历史全页空态，强调事项仍然可追溯，而不是回退成卡片式占位。
class HistoryEmptyStatePanel extends StatelessWidget {
  /// 创建历史空态面板。
  const HistoryEmptyStatePanel({
    required this.title,
    required this.body,
    required this.addActionTooltip,
    required this.onAddTap,
    super.key,
  });

  final String title;
  final String body;
  final String addActionTooltip;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 440.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/history_center/history-empty-illustration.png',
              width: 280.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 22.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.displaySmall?.copyWith(
                fontSize: 30.sp,
                height: 1.12,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: palette.inkSecondary,
                height: 1.45,
              ),
            ),
            SizedBox(height: 28.h),
            Tooltip(
              message: addActionTooltip,
              child: InkWell(
                key: const Key('history-empty-add-button'),
                onTap: onAddTap,
                borderRadius: BorderRadius.circular(999.r),
                child: Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                    color: palette.surfaceRaised,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.add_rounded,
                    size: 36.sp,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
