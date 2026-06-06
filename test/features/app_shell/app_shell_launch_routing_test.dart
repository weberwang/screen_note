import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/router/app_router.dart';
import 'package:screen_note/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/history_center/presentation/pages/history_center_page.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_home_page.dart';
import 'package:screen_note/l10n/app_localizations.dart';
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

    expect(find.byType(AppShellPage), findsOneWidget);
    expect(find.byType(SettingsCenterPage), findsOneWidget);
    expect(_currentSnackBarMessage(tester), contains(_localizations(tester).settingsPageTitle));
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

    expect(find.byType(AppShellPage), findsOneWidget);
    expect(find.byType(HistoryCenterPage), findsOneWidget);
    expect(_currentSnackBarMessage(tester), contains(_localizations(tester).historyDeletedTitle));
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

    expect(find.byType(AppShellPage), findsOneWidget);
    expect(find.byType(TaskFlowHomePage), findsOneWidget);
    expect(_currentSnackBarMessage(tester), contains(_localizations(tester).taskFlowTabLabel));
  });
}

/// 读取当前页面的本地化实例，避免测试中硬编码语言文案。
AppLocalizations _localizations(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(AppShellPage)));
}

/// 读取壳层当前展示的轻反馈文案，验证 GlobalFeedbackHost 是否真正输出内容。
String _currentSnackBarMessage(WidgetTester tester) {
  final SnackBar snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
  final Text content = snackBar.content as Text;
  return content.data ?? '';
}
