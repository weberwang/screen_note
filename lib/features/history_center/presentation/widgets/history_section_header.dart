import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final _HistorySectionToneStyle style = _tone.resolveStyle();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: <Widget>[
          Icon(style.icon, size: 18.sp, color: style.foregroundColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: style.foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _HistorySectionTone { completed, deleted }

/// 分区语义样式只在组件内部使用，避免把轻量视觉常量扩散到页面层。
final class _HistorySectionToneStyle {
  const _HistorySectionToneStyle({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
}

extension on _HistorySectionTone {
  /// 根据分区类型解析最小语义样式，保持完成与删除一眼可辨但不过度喧闹。
  _HistorySectionToneStyle resolveStyle() {
    return switch (this) {
      _HistorySectionTone.completed => const _HistorySectionToneStyle(
        icon: Icons.check_circle_outline_rounded,
        backgroundColor: Color(0xFFEAF4EB),
        foregroundColor: Color(0xFF4D8B52),
      ),
      _HistorySectionTone.deleted => const _HistorySectionToneStyle(
        icon: Icons.restore_from_trash_rounded,
        backgroundColor: Color(0xFFFBEDE9),
        foregroundColor: Color(0xFFE96A5A),
      ),
    };
  }
}
