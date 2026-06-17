import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/router/app_router.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 根应用组件负责承接路由、主题、国际化和尺寸适配基线。
///
/// 业务模块不应直接改写这里的公共装配，只能消费这里提供的稳定宿主环境。
class ScreenNoteApp extends HookConsumerWidget {
  /// 创建根应用组件。
  const ScreenNoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final SettingsCenterPreferences preferences = ref.watch(
      currentSettingsCenterPreferencesProvider,
    );

    return ScreenNoteScreenUtilContract(
      designSize: screenNoteDesignSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ScreenNoteTheme.light(),
          darkTheme: ScreenNoteTheme.dark(),
          themeMode: _themeModeFromPreference(preferences.themeModePreference),
          locale: _localeFromPreference(preferences.languagePreference),
          routerConfig: router,
          builder: (BuildContext context, Widget? child) {
            // 系统栏样式统一收口在根应用，避免 feature 页面各自决定图标明暗与透明背景。
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: _systemUiOverlayStyleForBrightness(
                Theme.of(context).brightness,
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }

  /// 根应用只在这里把设置偏好映射成 MaterialApp 所需的 ThemeMode，避免页面层重复判断。
  ThemeMode _themeModeFromPreference(SettingsThemeModePreference mode) {
    return switch (mode) {
      SettingsThemeModePreference.system => ThemeMode.system,
      SettingsThemeModePreference.light => ThemeMode.light,
      SettingsThemeModePreference.dark => ThemeMode.dark,
    };
  }

  /// 根应用 locale 映射统一收口到这里，避免 feature 页面直接感知 Locale 组装细节。
  Locale _localeFromPreference(SettingsLanguagePreference language) {
    return switch (language) {
      SettingsLanguagePreference.zh => const Locale('zh'),
      SettingsLanguagePreference.en => const Locale('en'),
    };
  }

  /// 根应用统一根据当前主题亮度映射系统栏图标颜色，保证 edge-to-edge 下的可读性稳定。
  SystemUiOverlayStyle _systemUiOverlayStyleForBrightness(
    Brightness brightness,
  ) {
    final bool isDark = brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
    );
  }
}
