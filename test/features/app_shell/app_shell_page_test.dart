import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/app/app.dart';
import 'package:screen_note/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 验证壳层页面会稳定承接唯一导航宿主，并按当前分支切换标题与新建入口。
void main() {
  testWidgets('壳层切换分支时保持唯一宿主，并按壳层保真规则切换 hero 与 FAB', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    addTearDown(database.close);

    final ProviderContainer container = ProviderContainer(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(database),
        settingsSharedPreferencesProvider.overrideWith(
          (ref) async => preferences,
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ScreenNoteApp(),
      ),
    );
    await tester.pumpAndSettle();

    final AppLocalizations localizations = AppLocalizations.of(
      tester.element(find.byType(AppShellPage)),
    );

    expect(find.byType(AppShellPage), findsOneWidget);
    expect(find.byKey(const Key('app-shell-nav-surface')), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
    expect(
      find.byKey(const Key('task-flow-home-shell-top-action')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('task-flow-home-priority-card')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('task-flow-home-priority-meta-row')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('task-flow-home-priority-status-chip')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('task-flow-home-queue-row-0')), findsOneWidget);
    expect(find.byKey(const Key('task-flow-home-queue-row-1')), findsOneWidget);
    expect(find.byKey(const Key('task-flow-home-queue-row-2')), findsOneWidget);
    expect(find.text(localizations.homeGreetingTitle), findsOneWidget);
    expect(find.text(localizations.homePriorityTitle), findsOneWidget);

    await tester.tap(find.text(localizations.settingsTabLabel));
    await tester.pumpAndSettle();

    expect(find.byType(AppShellPage), findsOneWidget);
    expect(find.byType(SettingsCenterPage), findsOneWidget);
    expect(find.byKey(const Key('app-shell-nav-surface')), findsOneWidget);
     expect(find.byType(AppBar), findsNothing);
     expect(
       find.byKey(const Key('task-flow-home-shell-top-action')),
       findsNothing,
     );
     expect(find.byKey(const Key('task-flow-home-priority-card')), findsNothing);
   });
 }
