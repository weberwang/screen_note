import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/router/app_router.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/history_center/presentation/pages/history_center_page.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_home_page.dart';
import 'package:drift/native.dart';

/// 验证 app-shell 能把外部回流目标稳定分发到正确模块，并在异常参数下回退首页。
void main() {
  testWidgets('launch 路由会把 widget 设置回流分发到设置页', (
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
        settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ScreenNoteApp(),
      ),
    );

    final router = container.read(appRouterProvider);
    router.go('/launch?source=widget&target=settings');
    await tester.pumpAndSettle();

    expect(find.byType(SettingsCenterPage), findsOneWidget);
  });

  testWidgets('launch 路由会把最近删除回流收口到历史中心', (
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
        settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ScreenNoteApp(),
      ),
    );

    final router = container.read(appRouterProvider);
    router.go('/launch?source=notification&target=history-deleted');
    await tester.pumpAndSettle();

    expect(find.byType(HistoryCenterPage), findsOneWidget);
  });

  testWidgets('launch 路由在目标非法时回退首页', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    addTearDown(database.close);
    final ProviderContainer container = ProviderContainer(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(database),
        settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ScreenNoteApp(),
      ),
    );

    final router = container.read(appRouterProvider);
    router.go('/launch?source=shortcut&target=unknown-target');
    await tester.pumpAndSettle();

    expect(find.byType(TaskFlowHomePage), findsOneWidget);
  });
}
