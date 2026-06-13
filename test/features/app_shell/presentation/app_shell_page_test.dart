import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:screen_note/features/app_shell/presentation/widgets/app_shell_quick_add_sheet.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

const _quickAddFeedback = 'Quick add will be connected in the task-flow stage.';
const _historyTabLabel = 'History';
const _settingsTabLabel = 'Settings';
const _historyTitle = 'History center';
const _settingsTitle = 'Settings center';
const _historyRootTitle = 'History root';
const _historyDetailTitle = 'History detail';

void main() {
  group('AppShellPage', () {
    testWidgets('reselecting the current tab resets that branch to root', (
      tester,
    ) async {
      await _pumpNestedHistoryShell(tester);

      expect(find.text(_historyDetailTitle), findsOneWidget);
      expect(find.text(_historyRootTitle), findsNothing);

      await tester.tap(find.text(_historyTabLabel));
      await tester.pumpAndSettle();

      expect(find.text(_historyRootTitle), findsOneWidget);
      expect(find.text(_historyDetailTitle), findsNothing);
    });

    testWidgets('switches shell tabs through the shared navigation bar', (
      tester,
    ) async {
      await _pumpAppShell(tester);

      expect(find.text(_historyTitle), findsNothing);
      expect(find.text(_settingsTitle), findsNothing);

      await tester.tap(find.text(_historyTabLabel));
      await tester.pumpAndSettle();

      expect(find.text(_historyTitle), findsOneWidget);

      await tester.tap(find.text(_settingsTabLabel));
      await tester.pumpAndSettle();

      expect(find.text(_settingsTitle), findsOneWidget);
    });

    testWidgets('does not stack quick add sheets on repeated fab trigger', (
      tester,
    ) async {
      await _pumpAppShell(tester);

      expect(find.byType(AppShellQuickAddSheet), findsNothing);
      expect(find.text(_quickAddFeedback), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsOneWidget);

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      fab.onPressed!.call();
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsOneWidget);
    });

    testWidgets('shows feedback after quick add sheet closes and clears it', (
      tester,
    ) async {
      await _pumpAppShell(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsOneWidget);

      await tester.ensureVisible(find.byType(FilledButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsNothing);
      expect(find.text(_quickAddFeedback), findsOneWidget);

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.text(_quickAddFeedback), findsNothing);
    });

    testWidgets('shows feedback when sheet is dismissed through modal barrier', (
      tester,
    ) async {
      await _pumpAppShell(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsOneWidget);

      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsNothing);
      expect(find.text(_quickAddFeedback), findsOneWidget);
    });
  });
}

Future<void> _pumpAppShell(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1440, 2000);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        widgetLaunchBridgeProvider.overrideWithValue(
          const _FakeWidgetLaunchBridge(rawLaunchLocation: RoutePaths.home),
        ),
      ],
      child: const ScreenNoteApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpNestedHistoryShell(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1440, 2000);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/history/detail',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) => const _TestShellLeaf('Home root'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.history,
                builder: (context, state) =>
                    const _TestShellLeaf(_historyRootTitle),
                routes: [
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) =>
                        const _TestShellLeaf(_historyDetailTitle),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.settings,
                builder: (context, state) =>
                    const _TestShellLeaf('Settings root'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      child: ScreenNoteScreenUtilContract(
        designSize: screenNoteDesignSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ScreenNoteTheme.light(),
            darkTheme: ScreenNoteTheme.dark(),
            routerConfig: router,
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

final class _FakeWidgetLaunchBridge implements WidgetLaunchBridge {
  const _FakeWidgetLaunchBridge({required this.rawLaunchLocation});

  @override
  final String rawLaunchLocation;
}

final class _TestShellLeaf extends StatelessWidget {
  const _TestShellLeaf(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
