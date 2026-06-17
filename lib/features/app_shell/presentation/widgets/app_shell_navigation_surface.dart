import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 共享底栏只承接三个一级目的地，
/// 不把快速添加混入导航结构。
class AppShellNavigationSurface extends StatelessWidget {
  /// 创建共享底栏组件。
  const AppShellNavigationSurface({required this.navigationShell, super.key});

  /// 当前根级分支宿主。
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return NavigationBar(
      key: const Key('app-shell-nav-surface'),
      height: 86.h,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) {
        // 中文注释：重复点击当前 tab 时复位到该分支根页面，避免壳层状态分叉。
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home_rounded),
          label: localizations.homeTabLabel,
        ),
        NavigationDestination(
          icon: const Icon(Icons.history_outlined),
          selectedIcon: const Icon(Icons.history_rounded),
          label: localizations.historyTabLabel,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings_rounded),
          label: localizations.settingsTabLabel,
        ),
      ],
    );
  }
}
