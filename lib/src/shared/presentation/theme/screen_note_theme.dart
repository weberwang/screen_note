import 'package:flutter/material.dart';

/// 屏记阶段一的浅色静态设计 token。
abstract final class ScreenNoteColors {
  /// 纸感页面背景色。
  static const Color surfacePaper = Color(0xFFF8F3EA);

  /// 主卡片背景色。
  static const Color surfaceCard = Color(0xFFFFFBF4);

  /// 次级卡片和弱化区块背景色。
  static const Color surfaceMuted = Color(0xFFEFE7DA);

  /// 主文案颜色。
  static const Color inkPrimary = Color(0xFF211B14);

  /// 次文案颜色。
  static const Color inkSecondary = Color(0xFF6F6254);

  /// 轻分隔线颜色。
  static const Color lineSoft = Color(0xFFE2D6C7);

  /// 主操作强调色。
  static const Color accentAmber = Color(0xFFD9822B);

  /// 过期强调色。
  static const Color statusOverdue = Color(0xFFB94A3A);

  /// 完成强调色。
  static const Color statusDone = Color(0xFF4F8A62);

  /// 隐私强调色。
  static const Color statusPrivate = Color(0xFF6D6A75);

  /// 系统跳转强调色。
  static const Color actionBlue = Color(0xFF3366CC);
}

/// 屏记阶段一共享圆角。
abstract final class ScreenNoteRadii {
  /// 小型按钮圆角。
  static const BorderRadius small = BorderRadius.all(Radius.circular(12));

  /// 事项卡片圆角。
  static const BorderRadius card = BorderRadius.all(Radius.circular(18));

  /// 快速输入卡片圆角。
  static const BorderRadius input = BorderRadius.all(Radius.circular(20));

  /// 底部弹层圆角。
  static const BorderRadius sheet = BorderRadius.vertical(
    top: Radius.circular(28),
  );
}

/// 屏记阶段一共享间距。
abstract final class ScreenNoteSpacing {
  /// 页面左右默认边距。
  static const double pageHorizontal = 20;

  /// 页面上下默认边距。
  static const double pageVertical = 20;

  /// 卡片默认内边距。
  static const double cardPadding = 16;

  /// 组间默认间距。
  static const double sectionGap = 24;

  /// 紧凑元素间距。
  static const double compactGap = 12;
}

/// 运行时主题调色板，承载亮暗模式下的语义色。
@immutable
class ScreenNoteThemePalette extends ThemeExtension<ScreenNoteThemePalette> {
  /// 创建运行时调色板。
  const ScreenNoteThemePalette({
    required this.surfacePaper,
    required this.surfaceCard,
    required this.surfaceMuted,
    required this.inkPrimary,
    required this.inkSecondary,
    required this.lineSoft,
    required this.accentAmber,
    required this.statusOverdue,
    required this.statusDone,
    required this.statusPrivate,
    required this.actionBlue,
    required this.backgroundTop,
    required this.backgroundBottom,
  });

  /// 页面主背景色。
  final Color surfacePaper;

  /// 一级卡片背景色。
  final Color surfaceCard;

  /// 二级卡片背景色。
  final Color surfaceMuted;

  /// 主文字色。
  final Color inkPrimary;

  /// 次文字色。
  final Color inkSecondary;

  /// 分隔线和描边色。
  final Color lineSoft;

  /// 主强调色。
  final Color accentAmber;

  /// 过期强调色。
  final Color statusOverdue;

  /// 完成强调色。
  final Color statusDone;

  /// 隐私强调色。
  final Color statusPrivate;

  /// 系统动作色。
  final Color actionBlue;

  /// 页面背景渐变起始色。
  final Color backgroundTop;

  /// 页面背景渐变结束色。
  final Color backgroundBottom;

  @override
  ScreenNoteThemePalette copyWith({
    Color? surfacePaper,
    Color? surfaceCard,
    Color? surfaceMuted,
    Color? inkPrimary,
    Color? inkSecondary,
    Color? lineSoft,
    Color? accentAmber,
    Color? statusOverdue,
    Color? statusDone,
    Color? statusPrivate,
    Color? actionBlue,
    Color? backgroundTop,
    Color? backgroundBottom,
  }) {
    return ScreenNoteThemePalette(
      surfacePaper: surfacePaper ?? this.surfacePaper,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      inkPrimary: inkPrimary ?? this.inkPrimary,
      inkSecondary: inkSecondary ?? this.inkSecondary,
      lineSoft: lineSoft ?? this.lineSoft,
      accentAmber: accentAmber ?? this.accentAmber,
      statusOverdue: statusOverdue ?? this.statusOverdue,
      statusDone: statusDone ?? this.statusDone,
      statusPrivate: statusPrivate ?? this.statusPrivate,
      actionBlue: actionBlue ?? this.actionBlue,
      backgroundTop: backgroundTop ?? this.backgroundTop,
      backgroundBottom: backgroundBottom ?? this.backgroundBottom,
    );
  }

  @override
  ScreenNoteThemePalette lerp(
    ThemeExtension<ScreenNoteThemePalette>? other,
    double t,
  ) {
    if (other is! ScreenNoteThemePalette) {
      return this;
    }

    return ScreenNoteThemePalette(
      surfacePaper: Color.lerp(surfacePaper, other.surfacePaper, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      inkPrimary: Color.lerp(inkPrimary, other.inkPrimary, t)!,
      inkSecondary: Color.lerp(inkSecondary, other.inkSecondary, t)!,
      lineSoft: Color.lerp(lineSoft, other.lineSoft, t)!,
      accentAmber: Color.lerp(accentAmber, other.accentAmber, t)!,
      statusOverdue: Color.lerp(statusOverdue, other.statusOverdue, t)!,
      statusDone: Color.lerp(statusDone, other.statusDone, t)!,
      statusPrivate: Color.lerp(statusPrivate, other.statusPrivate, t)!,
      actionBlue: Color.lerp(actionBlue, other.actionBlue, t)!,
      backgroundTop: Color.lerp(backgroundTop, other.backgroundTop, t)!,
      backgroundBottom: Color.lerp(backgroundBottom, other.backgroundBottom, t)!,
    );
  }
}

/// 统一维护亮暗两套主题调色板，避免页面直接拼写分散色值。
abstract final class ScreenNotePalettes {
  /// 亮色调色板，对齐“清晨纸片”设计方向。
  static const ScreenNoteThemePalette light = ScreenNoteThemePalette(
    surfacePaper: Color(0xFFF8F3EA),
    surfaceCard: Color(0xFFFFFBF4),
    surfaceMuted: Color(0xFFEFE7DA),
    inkPrimary: Color(0xFF211B14),
    inkSecondary: Color(0xFF6F6254),
    lineSoft: Color(0xFFE2D6C7),
    accentAmber: Color(0xFFD9822B),
    statusOverdue: Color(0xFFB94A3A),
    statusDone: Color(0xFF4F8A62),
    statusPrivate: Color(0xFF6D6A75),
    actionBlue: Color(0xFF3366CC),
    backgroundTop: Color(0xFFF8F3EA),
    backgroundBottom: Color(0xFFFDF8F0),
  );

  /// 暗色调色板，保留纸感层级而不是简单反色。
  static const ScreenNoteThemePalette dark = ScreenNoteThemePalette(
    surfacePaper: Color(0xFF171613),
    surfaceCard: Color(0xFF24211C),
    surfaceMuted: Color(0xFF302B24),
    inkPrimary: Color(0xFFF7EFE3),
    inkSecondary: Color(0xFFBEB0A1),
    lineSoft: Color(0xFF40382F),
    accentAmber: Color(0xFFD9822B),
    statusOverdue: Color(0xFFD56C5C),
    statusDone: Color(0xFF72AE85),
    statusPrivate: Color(0xFFB5ADBE),
    actionBlue: Color(0xFF7EA7FF),
    backgroundTop: Color(0xFF171613),
    backgroundBottom: Color(0xFF1F1C18),
  );
}

/// 运行时读取屏记调色板，避免共享壳层再写死亮色资源。
extension ScreenNoteThemePaletteX on BuildContext {
  /// 返回当前主题下的屏记调色板。
  ScreenNoteThemePalette get screenNotePalette =>
      Theme.of(this).extension<ScreenNoteThemePalette>()!;
}

/// 构建屏记亮色主题。
ThemeData buildScreenNoteLightTheme() {
  return _buildScreenNoteTheme(
    brightness: Brightness.light,
    palette: ScreenNotePalettes.light,
  );
}

/// 构建屏记暗色主题。
ThemeData buildScreenNoteDarkTheme() {
  return _buildScreenNoteTheme(
    brightness: Brightness.dark,
    palette: ScreenNotePalettes.dark,
  );
}

/// 兼容旧调用方式，默认返回亮色主题。
ThemeData buildScreenNoteTheme() => buildScreenNoteLightTheme();

/// 按亮暗模式生成共享 ThemeData。
ThemeData _buildScreenNoteTheme({
  required Brightness brightness,
  required ScreenNoteThemePalette palette,
}) {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: palette.accentAmber,
    brightness: brightness,
  ).copyWith(
    primary: palette.accentAmber,
    onPrimary: Colors.white,
    secondary: palette.actionBlue,
    onSecondary: Colors.white,
    surface: palette.surfacePaper,
    onSurface: palette.inkPrimary,
    outline: palette.lineSoft,
    error: palette.statusOverdue,
    onError: Colors.white,
  );

  final TextTheme baseTextTheme = (brightness == Brightness.dark
          ? Typography.whiteMountainView
          : Typography.blackMountainView)
      .apply(
        bodyColor: palette.inkPrimary,
        displayColor: palette.inkPrimary,
      );

  return ThemeData(
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: palette.surfacePaper,
    cardColor: palette.surfaceCard,
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[palette],
    textTheme: baseTextTheme.copyWith(
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontSize: 32,
        height: 38 / 32,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 24,
        height: 30 / 24,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 18,
        height: 24 / 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16,
        height: 24 / 16,
        color: palette.inkPrimary,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        height: 20 / 14,
        color: palette.inkSecondary,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
        color: palette.inkPrimary,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: palette.inkPrimary,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: palette.surfaceCard,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: ScreenNoteRadii.card),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: palette.accentAmber,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: ScreenNoteRadii.small),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.surfaceCard,
      border: OutlineInputBorder(
        borderRadius: ScreenNoteRadii.input,
        borderSide: BorderSide(color: palette.lineSoft),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: ScreenNoteRadii.input,
        borderSide: BorderSide(color: palette.lineSoft),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: ScreenNoteRadii.input,
        borderSide: BorderSide(color: palette.accentAmber),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: ScreenNoteRadii.input,
        borderSide: BorderSide(color: palette.statusOverdue),
      ),
      contentPadding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
    ),
    dividerTheme: DividerThemeData(
      color: palette.lineSoft,
      thickness: 1,
    ),
  );
}
