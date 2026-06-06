import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 壳层底部导航承托容器，用胶囊底座承接导航而不是裸露 Material 默认条。
class AppShellNavigationSurface extends StatelessWidget {
  /// 创建壳层底部导航承托容器。
  const AppShellNavigationSurface({
    super.key,
    required this.child,
  });

  /// 导航主体。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      key: const Key('app-shell-nav-surface'),
      decoration: BoxDecoration(
        color: palette.surfaceRaised.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: palette.lineSoft.withValues(alpha: 0.85),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
