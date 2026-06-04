import 'package:flutter/material.dart';

/// 屏记冻结后的亮色语义色值。
abstract final class ScreenNoteColors {
  /// 纸感页面背景色。
  static const Color surfacePaper = Color(0xFFF8F2E7);

  /// 主容器背景色。
  static const Color surfaceCard = Color(0xFFFFF9F0);

  /// 次级容器背景色。
  static const Color surfaceMuted = Color(0xFFF1E8D9);

  /// 提升层背景色。
  static const Color surfaceRaised = Color(0xFFFFFDF7);

  /// 首页焦点事项卡底色。
  static const Color surfaceFocusCard = Color(0xFF73795A);

  /// 主文案颜色。
  static const Color inkPrimary = Color(0xFF232117);

  /// 次文案颜色。
  static const Color inkSecondary = Color(0xFF6A6458);

  /// 第三级弱化文案颜色。
  static const Color inkTertiary = Color(0xFF978F80);

  /// 深色卡面上的主文案颜色。
  static const Color inkOnFocus = Color(0xFFFBF8EF);

  /// 深色卡面上的次文案颜色。
  static const Color inkOnFocusSecondary = Color(0xFFE8D7C5);

  /// 轻描边颜色。
  static const Color lineSoft = Color(0xFFDED3BE);

  /// 强分隔颜色。
  static const Color lineStrong = Color(0xFFA59673);

  /// 主操作色，冻结为橄榄绿轴。
  static const Color accentAmber = Color(0xFF798155);

  /// 辅助强调色，承担到期和提醒语义。
  static const Color accentTerracotta = Color(0xFFCD7B58);

  /// 过期状态色。
  static const Color statusOverdue = Color(0xFFB95944);

  /// 完成与确认状态色。
  static const Color statusDone = Color(0xFF72814F);

  /// 隐私状态色。
  static const Color statusPrivate = Color(0xFF7B8152);

  /// 系统跳转和文本动作色。
  static const Color actionBlue = Color(0xFF798155);

  /// 统一阴影色。
  static const Color shadowSoft = Color(0x243E311C);
}

/// 屏记共享圆角。
abstract final class ScreenNoteRadii {
  /// 小型标签和次级按钮圆角。
  static const BorderRadius small = BorderRadius.all(Radius.circular(16));

  /// 常规卡片圆角。
  static const BorderRadius card = BorderRadius.all(Radius.circular(24));

  /// 快速输入条圆角。
  static const BorderRadius input = BorderRadius.all(Radius.circular(26));

  /// 底部弹层圆角。
  static const BorderRadius sheet = BorderRadius.vertical(
    top: Radius.circular(32),
  );

  /// 焦点事项圆形动作按钮圆角。
  static const BorderRadius circular = BorderRadius.all(Radius.circular(999));
}

/// 屏记共享间距。
abstract final class ScreenNoteSpacing {
  /// 页面左右默认边距。
  static const double pageHorizontal = 24;

  /// 页面上下默认边距。
  static const double pageVertical = 24;

  /// 卡片默认内边距。
  static const double cardPadding = 20;

  /// 大区块间距。
  static const double sectionGap = 28;

  /// 紧凑元素间距。
  static const double compactGap = 12;
}

/// 运行时主题调色板，统一承载亮暗模式下的语义色。
@immutable
class ScreenNoteThemePalette extends ThemeExtension<ScreenNoteThemePalette> {
  /// 创建运行时调色板。
  const ScreenNoteThemePalette({
    required this.surfacePaper,
    required this.surfaceCard,
    required this.surfaceMuted,
    required this.surfaceRaised,
    required this.surfaceFocusCard,
    required this.inkPrimary,
    required this.inkSecondary,
    required this.inkTertiary,
    required this.inkOnFocus,
    required this.inkOnFocusSecondary,
    required this.lineSoft,
    required this.lineStrong,
    required this.accentAmber,
    required this.accentTerracotta,
    required this.statusOverdue,
    required this.statusDone,
    required this.statusPrivate,
    required this.actionBlue,
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.shadowSoft,
  });

  /// 页面主背景色。
  final Color surfacePaper;

  /// 一级卡片背景色。
  final Color surfaceCard;

  /// 二级卡片背景色。
  final Color surfaceMuted;

  /// 提升层背景色。
  final Color surfaceRaised;

  /// 首页焦点事项卡背景色。
  final Color surfaceFocusCard;

  /// 主文字色。
  final Color inkPrimary;

  /// 次文字色。
  final Color inkSecondary;

  /// 第三级文案色。
  final Color inkTertiary;

  /// 深色卡面主文字色。
  final Color inkOnFocus;

  /// 深色卡面次文字色。
  final Color inkOnFocusSecondary;

  /// 分隔线和描边色。
  final Color lineSoft;

  /// 强分隔或选中描边色。
  final Color lineStrong;

  /// 主强调色。
  final Color accentAmber;

  /// 辅助强调色。
  final Color accentTerracotta;

  /// 过期状态色。
  final Color statusOverdue;

  /// 完成状态色。
  final Color statusDone;

  /// 隐私状态色。
  final Color statusPrivate;

  /// 文本动作色。
  final Color actionBlue;

  /// 页面背景渐变起始色。
  final Color backgroundTop;

  /// 页面背景渐变结束色。
  final Color backgroundBottom;

  /// 统一阴影色。
  final Color shadowSoft;

  @override
  ScreenNoteThemePalette copyWith({
    Color? surfacePaper,
    Color? surfaceCard,
    Color? surfaceMuted,
    Color? surfaceRaised,
    Color? surfaceFocusCard,
    Color? inkPrimary,
    Color? inkSecondary,
    Color? inkTertiary,
    Color? inkOnFocus,
    Color? inkOnFocusSecondary,
    Color? lineSoft,
    Color? lineStrong,
    Color? accentAmber,
    Color? accentTerracotta,
    Color? statusOverdue,
    Color? statusDone,
    Color? statusPrivate,
    Color? actionBlue,
    Color? backgroundTop,
    Color? backgroundBottom,
    Color? shadowSoft,
  }) {
    return ScreenNoteThemePalette(
      surfacePaper: surfacePaper ?? this.surfacePaper,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceFocusCard: surfaceFocusCard ?? this.surfaceFocusCard,
      inkPrimary: inkPrimary ?? this.inkPrimary,
      inkSecondary: inkSecondary ?? this.inkSecondary,
      inkTertiary: inkTertiary ?? this.inkTertiary,
      inkOnFocus: inkOnFocus ?? this.inkOnFocus,
      inkOnFocusSecondary: inkOnFocusSecondary ?? this.inkOnFocusSecondary,
      lineSoft: lineSoft ?? this.lineSoft,
      lineStrong: lineStrong ?? this.lineStrong,
      accentAmber: accentAmber ?? this.accentAmber,
      accentTerracotta: accentTerracotta ?? this.accentTerracotta,
      statusOverdue: statusOverdue ?? this.statusOverdue,
      statusDone: statusDone ?? this.statusDone,
      statusPrivate: statusPrivate ?? this.statusPrivate,
      actionBlue: actionBlue ?? this.actionBlue,
      backgroundTop: backgroundTop ?? this.backgroundTop,
      backgroundBottom: backgroundBottom ?? this.backgroundBottom,
      shadowSoft: shadowSoft ?? this.shadowSoft,
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
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceFocusCard: Color.lerp(
        surfaceFocusCard,
        other.surfaceFocusCard,
        t,
      )!,
      inkPrimary: Color.lerp(inkPrimary, other.inkPrimary, t)!,
      inkSecondary: Color.lerp(inkSecondary, other.inkSecondary, t)!,
      inkTertiary: Color.lerp(inkTertiary, other.inkTertiary, t)!,
      inkOnFocus: Color.lerp(inkOnFocus, other.inkOnFocus, t)!,
      inkOnFocusSecondary: Color.lerp(
        inkOnFocusSecondary,
        other.inkOnFocusSecondary,
        t,
      )!,
      lineSoft: Color.lerp(lineSoft, other.lineSoft, t)!,
      lineStrong: Color.lerp(lineStrong, other.lineStrong, t)!,
      accentAmber: Color.lerp(accentAmber, other.accentAmber, t)!,
      accentTerracotta: Color.lerp(
        accentTerracotta,
        other.accentTerracotta,
        t,
      )!,
      statusOverdue: Color.lerp(statusOverdue, other.statusOverdue, t)!,
      statusDone: Color.lerp(statusDone, other.statusDone, t)!,
      statusPrivate: Color.lerp(statusPrivate, other.statusPrivate, t)!,
      actionBlue: Color.lerp(actionBlue, other.actionBlue, t)!,
      backgroundTop: Color.lerp(backgroundTop, other.backgroundTop, t)!,
      backgroundBottom: Color.lerp(
        backgroundBottom,
        other.backgroundBottom,
        t,
      )!,
      shadowSoft: Color.lerp(shadowSoft, other.shadowSoft, t)!,
    );
  }
}

/// 统一维护亮暗两套调色板。
abstract final class ScreenNotePalettes {
  /// 亮色调色板，对齐冻结后的暖纸感设计。
  static const ScreenNoteThemePalette light = ScreenNoteThemePalette(
    surfacePaper: ScreenNoteColors.surfacePaper,
    surfaceCard: ScreenNoteColors.surfaceCard,
    surfaceMuted: ScreenNoteColors.surfaceMuted,
    surfaceRaised: ScreenNoteColors.surfaceRaised,
    surfaceFocusCard: ScreenNoteColors.surfaceFocusCard,
    inkPrimary: ScreenNoteColors.inkPrimary,
    inkSecondary: ScreenNoteColors.inkSecondary,
    inkTertiary: ScreenNoteColors.inkTertiary,
    inkOnFocus: ScreenNoteColors.inkOnFocus,
    inkOnFocusSecondary: ScreenNoteColors.inkOnFocusSecondary,
    lineSoft: ScreenNoteColors.lineSoft,
    lineStrong: ScreenNoteColors.lineStrong,
    accentAmber: ScreenNoteColors.accentAmber,
    accentTerracotta: ScreenNoteColors.accentTerracotta,
    statusOverdue: ScreenNoteColors.statusOverdue,
    statusDone: ScreenNoteColors.statusDone,
    statusPrivate: ScreenNoteColors.statusPrivate,
    actionBlue: ScreenNoteColors.actionBlue,
    backgroundTop: Color(0xFFF8F2E7),
    backgroundBottom: Color(0xFFFFF8EF),
    shadowSoft: ScreenNoteColors.shadowSoft,
  );

  /// 暗色调色板，保留暖暗纸面的层级关系。
  static const ScreenNoteThemePalette dark = ScreenNoteThemePalette(
    surfacePaper: Color(0xFF181A14),
    surfaceCard: Color(0xFF1E221A),
    surfaceMuted: Color(0xFF252A21),
    surfaceRaised: Color(0xFF2D3328),
    surfaceFocusCard: Color(0xFF4D553E),
    inkPrimary: Color(0xFFF4EDDE),
    inkSecondary: Color(0xFFC7C0AB),
    inkTertiary: Color(0xFF9A937E),
    inkOnFocus: Color(0xFFF8F2E7),
    inkOnFocusSecondary: Color(0xFFE4B59B),
    lineSoft: Color(0xFF34392F),
    lineStrong: Color(0xFF5B644F),
    accentAmber: Color(0xFF8D9863),
    accentTerracotta: Color(0xFFD58A64),
    statusOverdue: Color(0xFFCF6D58),
    statusDone: Color(0xFF90A86B),
    statusPrivate: Color(0xFFA5B174),
    actionBlue: Color(0xFF8D9863),
    backgroundTop: Color(0xFF181A14),
    backgroundBottom: Color(0xFF1F241B),
    shadowSoft: Color(0x75000000),
  );
}

/// 运行时读取屏记调色板。
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
  const List<String> serifFallback = <String>[
    'Georgia',
    'Times New Roman',
    'serif',
  ];
  final ColorScheme colorScheme =
      ColorScheme.fromSeed(
        seedColor: palette.accentAmber,
        brightness: brightness,
      ).copyWith(
        primary: palette.accentAmber,
        onPrimary: palette.inkOnFocus,
        secondary: palette.accentTerracotta,
        onSecondary: palette.inkOnFocus,
        surface: palette.surfaceCard,
        onSurface: palette.inkPrimary,
        outline: palette.lineSoft,
        error: palette.statusOverdue,
        onError: palette.inkOnFocus,
      );

  final TextTheme baseTextTheme =
      (brightness == Brightness.dark
              ? Typography.whiteMountainView
              : Typography.blackMountainView)
          .apply(
            bodyColor: palette.inkPrimary,
            displayColor: palette.inkPrimary,
          );

  final TextTheme textTheme = baseTextTheme.copyWith(
    displayLarge: baseTextTheme.displayLarge?.copyWith(
      fontSize: 42,
      height: 1.05,
      fontWeight: FontWeight.w600,
      letterSpacing: -1.2,
      fontFamily: serifFallback.first,
      fontFamilyFallback: serifFallback,
    ),
    displayMedium: baseTextTheme.displayMedium?.copyWith(
      fontSize: 34,
      height: 1.08,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.9,
      fontFamily: serifFallback.first,
      fontFamilyFallback: serifFallback,
    ),
    displaySmall: baseTextTheme.displaySmall?.copyWith(
      fontSize: 28,
      height: 1.1,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.8,
      fontFamily: serifFallback.first,
      fontFamilyFallback: serifFallback,
    ),
    headlineMedium: baseTextTheme.headlineMedium?.copyWith(
      fontSize: 22,
      height: 1.15,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
      fontFamily: serifFallback.first,
      fontFamilyFallback: serifFallback,
    ),
    titleLarge: baseTextTheme.titleLarge?.copyWith(
      fontSize: 20,
      height: 1.2,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      fontFamily: serifFallback.first,
      fontFamilyFallback: serifFallback,
    ),
    titleMedium: baseTextTheme.titleMedium?.copyWith(
      fontSize: 17,
      height: 1.28,
      fontWeight: FontWeight.w600,
      color: palette.inkPrimary,
    ),
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(
      fontSize: 16,
      height: 1.45,
      color: palette.inkPrimary,
    ),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(
      fontSize: 14,
      height: 1.45,
      color: palette.inkSecondary,
    ),
    labelLarge: baseTextTheme.labelLarge?.copyWith(
      fontSize: 15,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: palette.inkPrimary,
    ),
    labelMedium: baseTextTheme.labelMedium?.copyWith(
      fontSize: 13,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: palette.inkSecondary,
    ),
    labelSmall: baseTextTheme.labelSmall?.copyWith(
      fontSize: 11,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      color: palette.inkPrimary,
    ),
  );

  return ThemeData(
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: palette.surfacePaper,
    cardColor: palette.surfaceCard,
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[palette],
    textTheme: textTheme,
    iconTheme: IconThemeData(color: palette.inkPrimary),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: palette.inkPrimary,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.headlineMedium,
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
        foregroundColor: palette.inkOnFocus,
        textStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        shape: const RoundedRectangleBorder(
          borderRadius: ScreenNoteRadii.small,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: palette.actionBlue,
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.inkPrimary,
        side: BorderSide(color: palette.lineSoft),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: ScreenNoteRadii.small,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.surfaceRaised,
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
        borderSide: BorderSide(color: palette.accentAmber, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: ScreenNoteRadii.input,
        borderSide: BorderSide(color: palette.statusOverdue),
      ),
      contentPadding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
      hintStyle: textTheme.bodyMedium?.copyWith(color: palette.inkTertiary),
      labelStyle: textTheme.labelMedium,
    ),
    dividerTheme: DividerThemeData(color: palette.lineSoft, thickness: 1),
    chipTheme: ChipThemeData(
      backgroundColor: palette.surfaceMuted,
      side: BorderSide.none,
      shape: const RoundedRectangleBorder(borderRadius: ScreenNoteRadii.small),
      labelStyle: textTheme.labelSmall ?? const TextStyle(),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: palette.surfaceFocusCard,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: palette.inkOnFocus,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
