import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 历史分区头组件，统一收口最近完成与最近删除的语义色和结构。
class HistorySectionHeader extends StatelessWidget {
  /// 创建最近完成分区头。
  const HistorySectionHeader.completed({
    required this.title,
    super.key,
  }) : _tone = _HistorySectionTone.completed;

  /// 创建最近删除分区头。
  const HistorySectionHeader.deleted({
    required this.title,
    super.key,
  }) : _tone = _HistorySectionTone.deleted;

  final String title;
  final _HistorySectionTone _tone;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _HistorySectionToneStyle style = _tone.resolveStyle(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            style.backgroundColor,
            style.backgroundColor.withValues(alpha: 0.35),
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: <Widget>[
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: style.iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(style.icon, size: 18.sp, color: style.foregroundColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 17.sp,
                  color: style.foregroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _HistorySectionTone { completed, deleted }

/// 分区语义样式只在组件内部使用，避免把视觉常量扩散到页面层。
final class _HistorySectionToneStyle {
  const _HistorySectionToneStyle({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconBackgroundColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color iconBackgroundColor;
}

extension on _HistorySectionTone {
  /// 根据分区类型解析语义样式，保持完成与删除一眼可辨但不过度喧闹。
  _HistorySectionToneStyle resolveStyle(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    return switch (this) {
      _HistorySectionTone.completed => _HistorySectionToneStyle(
        icon: Icons.check_rounded,
        backgroundColor: const Color(0xFFEAF4EB),
        foregroundColor: palette.statusDone,
        iconBackgroundColor: palette.statusDone.withValues(alpha: 0.16),
      ),
      _HistorySectionTone.deleted => _HistorySectionToneStyle(
        icon: Icons.delete_outline_rounded,
        backgroundColor: const Color(0xFFFBEDE9),
        foregroundColor: palette.statusPrivate,
        iconBackgroundColor: palette.statusPrivate.withValues(alpha: 0.12),
      ),
    };
  }
}
