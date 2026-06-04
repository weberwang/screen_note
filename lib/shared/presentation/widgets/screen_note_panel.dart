import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 通用信息面板，统一承接初始化阶段的卡片层级与边框样式。
class ScreenNotePanel extends StatelessWidget {
  /// 创建通用信息面板。
  const ScreenNotePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
    this.backgroundColor,
  });

  /// 面板内容。
  final Widget child;

  /// 面板内边距。
  final EdgeInsetsGeometry padding;

  /// 自定义背景色；为空时使用主题默认卡片层。
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? palette.surfaceCard,
        borderRadius: ScreenNoteRadii.card,
        border: Border.all(color: palette.lineSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
