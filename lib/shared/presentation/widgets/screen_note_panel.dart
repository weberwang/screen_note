import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 共享面板组件用于承接当前 bootstrap 阶段的统一表面语言，
/// 避免各个占位页各自发明容器样式。
class ScreenNotePanel extends StatelessWidget {
  /// 创建共享面板组件。
  const ScreenNotePanel({
    required this.child,
    super.key,
    this.padding,
  });

  /// 面板主体内容。
  final Widget child;

  /// 允许按需覆盖内边距，但默认沿用共享卡片节奏。
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        // 统一把共享卡片圆角收口到 26，和当前冻结原型中的 settings-center 分组表面对齐。
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
