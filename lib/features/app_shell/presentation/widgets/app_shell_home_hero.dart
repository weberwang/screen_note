import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 首页壳层情绪头图，只承载问候、标题节奏与景深带，不接管业务卡内容。
class AppShellHomeHero extends StatelessWidget {
  /// 创建首页壳层情绪头图。
  const AppShellHomeHero({
    super.key,
    this.compact = false,
  });

  /// 低可用高度下启用紧凑模式，避免壳层顶部把正文全部挤出视口。
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Padding(
      key: const Key('app-shell-home-hero'),
      padding: const EdgeInsets.fromLTRB(
        ScreenNoteSpacing.pageHorizontal,
        12,
        ScreenNoteSpacing.pageHorizontal,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _ShellBadge(
                child: Icon(
                  Icons.wb_sunny_outlined,
                  color: palette.accentAmber,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      localizations.homeGreetingTitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: palette.inkSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      localizations.appTitle,
                      style: theme.textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const _ShellBadge(
                child: Icon(Icons.person_outline_rounded),
              ),
            ],
          ),
          SizedBox(height: compact ? 18 : 28),
          Text(
            localizations.homePriorityTitle,
            style: theme.textTheme.displayLarge?.copyWith(
              height: 1.02,
              fontSize: compact ? 42 : 56,
            ),
          ),
          SizedBox(height: compact ? 10 : 16),
          const _ShellAccentWave(),
          SizedBox(height: compact ? 10 : 16),
          Text(
            localizations.homePriorityBody,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: palette.inkSecondary,
            ),
          ),
          SizedBox(height: compact ? 14 : 22),
          _LandscapeBand(compact: compact),
        ],
      ),
    );
  }
}

/// 壳层顶部的圆角徽标容器，用于问候图标与头像占位。
class _ShellBadge extends StatelessWidget {
  /// 创建壳层徽标容器。
  const _ShellBadge({required this.child});

  /// 容器内部内容。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceRaised.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SizedBox(
        width: 56,
        height: 56,
        child: Center(child: child),
      ),
    );
  }
}

/// 首页标题下方的细线装饰，用极轻的笔触还原冻结图中的情绪停顿。
class _ShellAccentWave extends StatelessWidget {
  /// 创建标题下方装饰线。
  const _ShellAccentWave();

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return SizedBox(
      width: 64,
      height: 18,
      child: CustomPaint(
        painter: _WavePainter(color: palette.statusDone),
      ),
    );
  }
}

/// 首页景深带，用抽象的山水层次还原壳层的过渡背景语义。
class _LandscapeBand extends StatelessWidget {
  /// 创建景深带。
  const _LandscapeBand({required this.compact});

  /// 紧凑模式下压缩带状高度，优先给正文让位。
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Container(
      key: const Key('app-shell-home-landscape-band'),
      height: compact ? 72 : 114,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            palette.surfaceRaised,
            palette.surfaceCard,
            palette.surfacePaper,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 1.2,
                  colors: <Color>[
                    Colors.white.withValues(alpha: 0.52),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -12,
            right: -12,
            bottom: -12,
            child: _LandscapeLayer(
              height: 54,
              color: palette.surfaceMuted.withValues(alpha: 0.84),
            ),
          ),
          Positioned(
            left: -24,
            right: 44,
            bottom: 6,
            child: _LandscapeLayer(
              height: 38,
              color: palette.surfaceMuted.withValues(alpha: 0.58),
            ),
          ),
          Positioned(
            left: 24,
            right: -18,
            bottom: 22,
            child: _LandscapeLayer(
              height: 24,
              color: palette.surfaceMuted.withValues(alpha: 0.42),
            ),
          ),
          Positioned(
            right: 30,
            top: 42,
            child: Row(
              children: List<Widget>.generate(
                3,
                (int index) => Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                  child: Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    size: 16 - index.toDouble(),
                    color: palette.inkSecondary.withValues(alpha: 0.55),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 景深层形状，保持可复用的抽象山脊轮廓。
class _LandscapeLayer extends StatelessWidget {
  /// 创建景深层。
  const _LandscapeLayer({required this.height, required this.color});

  /// 当前层高度。
  final double height;

  /// 当前层填充色。
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: SizedBox(height: height),
    );
  }
}

/// 细线波浪画笔。
class _WavePainter extends CustomPainter {
  /// 创建波浪画笔。
  const _WavePainter({required this.color});

  /// 线条颜色。
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final Path path = Path()
      ..moveTo(0, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.12,
        size.width * 0.48,
        size.height * 0.56,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height,
        size.width,
        size.height * 0.34,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
