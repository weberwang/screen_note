import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/app_shell/presentation/widgets/app_shell_feedback_host.dart';
import 'package:screen_note/features/app_shell/presentation/widgets/app_shell_home_hero.dart';
import 'package:screen_note/features/app_shell/presentation/widgets/app_shell_navigation_surface.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 根壳层页面，统一承接底部导航、首页壳层情绪区和全局反馈宿主。
class AppShellPage extends StatelessWidget {
  /// 创建根壳层页面。
  const AppShellPage({super.key, required this.navigationShell});

  /// 当前壳层托管的导航宿主。
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool isHomeBranch = navigationShell.currentIndex == 0;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[palette.backgroundTop, palette.backgroundBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool compactShell = constraints.maxHeight < 640;

                return SafeArea(
                  bottom: false,
                  child: Column(
                    children: <Widget>[
                      if (isHomeBranch)
                        AppShellHomeHero(compact: compactShell),
                      Expanded(child: navigationShell),
                      if (isHomeBranch)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            ScreenNoteSpacing.pageHorizontal,
                            0,
                            ScreenNoteSpacing.pageHorizontal,
                            18,
                          ),
                          child: FilledButton(
                            key: const Key('app-shell-home-cta'),
                            onPressed: () => context.push(RoutePaths.taskEditor),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0E3A70),
                              foregroundColor: Colors.white,
                              minimumSize: Size.fromHeight(compactShell ? 58 : 68),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: compactShell ? 38 : 44,
                                  height: compactShell ? 38 : 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.66),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.explore_outlined),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Text(
                                    localizations.appShellHomeCta,
                                    style: Theme.of(context).textTheme.titleLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontFamily: null,
                                          fontFamilyFallback: null,
                                        ),
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, size: 30),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            const AppShellFeedbackHost(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: AppShellNavigationSurface(
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                height: 86,
                indicatorColor: palette.surfaceMuted,
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
                  Set<WidgetState> states,
                ) {
                  final TextStyle baseStyle =
                      Theme.of(context).textTheme.labelLarge ??
                      const TextStyle();
                  if (states.contains(WidgetState.selected)) {
                    return baseStyle.copyWith(color: palette.inkPrimary);
                  }
                  return baseStyle.copyWith(color: palette.inkSecondary);
                }),
                iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return IconThemeData(
                      color: palette.actionBlue,
                      size: 24,
                    );
                  }
                  return IconThemeData(
                    color: palette.inkSecondary,
                    size: 24,
                  );
                }),
              ),
              child: NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (int index) {
                  // 重复点击当前 tab 时回到该分支根路径，保持壳层导航行为一致。
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                },
                destinations: <NavigationDestination>[
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home_rounded),
                    label: localizations.taskFlowTabLabel,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.history_outlined),
                    selectedIcon: const Icon(Icons.history_rounded),
                    label: localizations.historyCenterTabLabel,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.widgets_outlined),
                    selectedIcon: const Icon(Icons.widgets_rounded),
                    label: localizations.widgetBridgeTabLabel,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings_rounded),
                    label: localizations.settingsCenterTabLabel,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
