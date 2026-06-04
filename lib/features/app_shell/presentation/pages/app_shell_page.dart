import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 根壳层页面，统一承接底部导航、全局背景和新建入口。
class AppShellPage extends StatelessWidget {
  /// 创建根壳层页面。
  const AppShellPage({super.key, required this.navigationShell});

  /// 当前壳层托管的导航宿主。
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final AppLocalizations localizations = AppLocalizations.of(context);

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
        appBar: AppBar(
          title: Text(
            _titleForIndex(localizations, navigationShell.currentIndex),
          ),
        ),
        body: SafeArea(top: false, child: navigationShell),
        floatingActionButton: navigationShell.currentIndex == 0
            ? FloatingActionButton.extended(
                onPressed: () => context.push(RoutePaths.taskEditor),
                icon: const Icon(Icons.add_task_rounded),
                label: Text(localizations.taskEditorTitle),
              )
            : null,
        bottomNavigationBar: SafeArea(
          top: false,
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
    );
  }

  /// 根据当前分支索引返回对应标题，避免页面自己重复维护壳层文案。
  String _titleForIndex(AppLocalizations localizations, int index) {
    return switch (index) {
      0 => localizations.appTitle,
      1 => localizations.historyCompletedTitle,
      2 => localizations.widgetSettingsTitle,
      _ => localizations.settingsPageTitle,
    };
  }
}
