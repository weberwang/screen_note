import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 任务模块统一面板容器。
///
/// 这个容器负责收口纸面背景、圆角、描边和轻阴影，
/// 避免首页、详情页和编辑页各自重新解释共享质感。
class TaskSurfacePanel extends StatelessWidget {
  /// 创建任务模块统一面板容器。
  const TaskSurfacePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
    this.backgroundColor,
    this.borderColor,
  });

  /// 面板内容。
  final Widget child;

  /// 内边距。
  final EdgeInsetsGeometry padding;

  /// 背景色，可按上下文覆写。
  final Color? backgroundColor;

  /// 描边色，可按上下文覆写。
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? palette.surfaceCard,
        borderRadius: ScreenNoteRadii.card,
        border: Border.all(color: borderColor ?? palette.lineSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
