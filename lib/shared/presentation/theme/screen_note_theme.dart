import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 共享主题直接映射当前冻结的浅色/深色主题角色，
/// 后续 feature 只能在此基线之上消费，不应各自发明新视觉体系。
final class ScreenNoteTheme {
  /// 创建主题工具类。
  const ScreenNoteTheme._();

  /// 浅色主题。
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF4D8B52),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF6E7B6F),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFE96A5A),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFFBFAF7),
      onSurface: Color(0xFF1F2328),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFFBFAF7),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          fontSize: 38.sp,
          height: 1.08,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        headlineLarge: TextStyle(
          fontSize: 34.sp,
          height: 1.12,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 20.sp,
          height: 1.25,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 18.sp,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          height: 1.5,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          height: 1.45,
          color: const Color(0xFF5F6762),
        ),
        labelLarge: TextStyle(
          fontSize: 15.sp,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF7C8580),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.r),
          side: const BorderSide(color: Color(0xFFE4E8E0)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.96),
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: const Color(0xFF8C958F),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      dividerColor: const Color(0xFFE8ECE5),
    );
  }

  /// 深色主题。
  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF6FAE73),
      onPrimary: Color(0xFF102214),
      secondary: Color(0xFFA7B4A9),
      onSecondary: Color(0xFF102214),
      error: Color(0xFFF08A7B),
      onError: Color(0xFF2A0F0B),
      surface: Color(0xFF111513),
      onSurface: Color(0xFFF2F4EF),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF111513),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          fontSize: 38.sp,
          height: 1.08,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        headlineLarge: TextStyle(
          fontSize: 34.sp,
          height: 1.12,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 20.sp,
          height: 1.25,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 18.sp,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          height: 1.5,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          height: 1.45,
          color: const Color(0xFFC4CBC5),
        ),
        labelLarge: TextStyle(
          fontSize: 15.sp,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFB7C0B9),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF171D1A),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.r),
          side: const BorderSide(color: Color(0xFF28302B)),
        ),
      ),
      dividerColor: const Color(0xFF2D3530),
    );
  }
}

