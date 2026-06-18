import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 共享壳层反馈宿主统一映射为 iOS 风格轻提示，避免设置页与其他页面出现两套反馈视觉。
class AppShellFeedbackHost extends StatefulWidget {
  /// 创建共享壳层反馈宿主。
  const AppShellFeedbackHost({
    required this.text,
    required this.dismissLabel,
    required this.onClose,
    this.duration = const Duration(seconds: 2),
    super.key,
  });

  /// 当前要展示的反馈文案。
  final String text;

  /// 保留关闭文案入参，避免壳层反馈链路改样式时同步扩大页面调用面。
  final String dismissLabel;

  /// 提示关闭后回写壳层状态的回调。
  final VoidCallback onClose;

  /// 提示驻留时长。
  final Duration duration;

  @override
  State<AppShellFeedbackHost> createState() => _AppShellFeedbackHostState();
}

/// 管理壳层反馈的进入、停留与退出动画，确保自动消失和状态回写共用一条收口路径。
class _AppShellFeedbackHostState extends State<AppShellFeedbackHost>
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
      Tween<Offset>(begin: const Offset(0, -0.05), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
      );

  Timer? _dismissTimer;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _restartDismissTimer();
  }

  @override
  void didUpdateWidget(covariant AppShellFeedbackHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == widget.text &&
        oldWidget.duration == widget.duration) {
      return;
    }
    _isClosing = false;
    _restartDismissTimer();
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// 每次提示内容变化时重置自动关闭计时，避免上一条反馈的定时器误关新提示。
  void _restartDismissTimer() {
    _dismissTimer?.cancel();
    _dismissTimer = Timer(widget.duration, _close);
  }

  /// 壳层反馈统一按动画收口后再回写状态，避免提示闪退或残留。
  Future<void> _close() async {
    if (_isClosing) {
      return;
    }
    _isClosing = true;
    _dismissTimer?.cancel();
    await _controller.reverse();
    if (mounted) {
      widget.onClose();
    }
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

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(top: 12.h),
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
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 280.w),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          child: Text(
                            widget.text,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: textColor,
                                  fontSize: 15.sp,
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
    );
  }
}
