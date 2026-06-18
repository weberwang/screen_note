import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 全局轻提示入口，统一提供 iOS 风格的居中 HUD 与收口动画，避免各页面各自维护提示浮层。
final class ScreenNoteToast {
  ScreenNoteToast._();

  static OverlayEntry? _activeEntry;
  static VoidCallback? _dismissActiveToast;

  /// 展示全局轻提示；新提示会顶掉旧提示，避免连续操作时堆叠多个浮层。
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    final OverlayState? overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }

    _dismissActiveToast?.call();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return _ScreenNoteToastOverlay(
          message: message,
          duration: duration,
          onDismissReady: (VoidCallback dismiss) {
            if (_activeEntry == entry) {
              _dismissActiveToast = dismiss;
            }
          },
          onDismissed: () {
            if (_activeEntry == entry) {
              _activeEntry = null;
              _dismissActiveToast = null;
            }
            entry.remove();
          },
        );
      },
    );

    _activeEntry = entry;
    overlay.insert(entry);
  }
}

/// Toast 浮层宿主，负责淡入缩放、自动消失和反向收口动画。
class _ScreenNoteToastOverlay extends StatefulWidget {
  /// 创建 Toast 浮层宿主。
  const _ScreenNoteToastOverlay({
    required this.message,
    required this.duration,
    required this.onDismissReady,
    required this.onDismissed,
  });

  /// 当前提示文案。
  final String message;

  /// 提示驻留时长。
  final Duration duration;

  /// 把当前浮层的关闭能力回传给全局入口，便于后续提示覆盖旧提示。
  final ValueChanged<VoidCallback> onDismissReady;

  /// 浮层彻底收口后的统一清理回调。
  final VoidCallback onDismissed;

  @override
  State<_ScreenNoteToastOverlay> createState() =>
      _ScreenNoteToastOverlayState();
}

/// 管理 Toast 的进入、停留与退出动画，确保自动关闭和手动覆盖共用同一条收口路径。
class _ScreenNoteToastOverlayState extends State<_ScreenNoteToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    reverseDuration: const Duration(milliseconds: 180),
  );
  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  late final Animation<double> _scaleAnimation =
      Tween<double>(begin: 0.92, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        ),
      );
  late final Animation<Offset> _offsetAnimation =
      Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
      );

  Timer? _dismissTimer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    widget.onDismissReady(_dismiss);
    _controller.forward();
    // 停留时间由宿主管理，统一保证所有页面的提示节奏一致。
    _dismissTimer = Timer(widget.duration, _dismiss);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// 统一关闭当前浮层，避免计时关闭与新提示覆盖时走出两套不同动画。
  Future<void> _dismiss() async {
    if (_isDismissing) {
      return;
    }
    _isDismissing = true;
    _dismissTimer?.cancel();
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final Color backgroundColor = brightness == Brightness.dark
        ? const Color(0xE6F4F4F5)
        : const Color(0xD9181A1C);
    final Color textColor = brightness == Brightness.dark
        ? const Color(0xFF111315)
        : CupertinoColors.white;

    return IgnorePointer(
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _offsetAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: CupertinoPopupSurface(
                    isSurfacePainted: false,
                    child: ClipRRect(
                      borderRadius: ScreenNoteRadii.panel,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: ScreenNoteRadii.panel,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Text(
                              widget.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
