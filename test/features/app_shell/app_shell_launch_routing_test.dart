import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_editor_page.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_home_page.dart';

/// 验证 ScreenNoteApp 会把启动桥提供的安全初始落点分发到正确页面。
void main() {
  testWidgets('启动桥给出 settings 落点时会稳定进入设置页', (
    WidgetTester tester,
  ) async {
    final _LaunchTestHarness harness = await _createHarness(
      rawLaunchLocation: RoutePaths.settings,
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: harness.container,
        child: const ScreenNoteApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppShellPage), findsOneWidget);
    expect(find.byType(SettingsCenterPage), findsOneWidget);
  });

  testWidgets('启动桥给出 task-editor 安全落点时会进入任务编辑页', (
    WidgetTester tester,
  ) async {
    final _LaunchTestHarness harness = await _createHarness(
      rawLaunchLocation: '${RoutePaths.home}${RoutePaths.taskEditor}?taskId=task-42',
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: harness.container,
        child: const ScreenNoteApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppShellPage), findsOneWidget);
    expect(find.byType(TaskFlowEditorPage), findsOneWidget);
  });

  testWidgets('启动桥给出非法落点时会保守回退到首页', (WidgetTester tester) async {
    final _LaunchTestHarness harness = await _createHarness(
      rawLaunchLocation: '/launch?source=shortcut&target=unknown-target',
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: harness.container,
        child: const ScreenNoteApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppShellPage), findsOneWidget);
    expect(find.byType(TaskFlowHomePage), findsOneWidget);
  });
}

/// 创建带安全启动桥覆写的测试装配，统一复用最小依赖并负责释放数据库。
Future<_LaunchTestHarness> _createHarness({
  required String rawLaunchLocation,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final TaskFlowDatabase database = TaskFlowDatabase.test(NativeDatabase.memory());
  final ProviderContainer container = ProviderContainer(
    overrides: [
      taskFlowDatabaseProvider.overrideWithValue(database),
      settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
      widgetLaunchBridgeProvider.overrideWithValue(
        _FakeWidgetLaunchBridge(rawLaunchLocation: rawLaunchLocation),
      ),
    ],
  );

  return _LaunchTestHarness(
    container: container,
    database: database,
  );
}

/// 启动桥测试装配，统一封装容器与数据库释放，避免多数据库告警污染输出。
final class _LaunchTestHarness {
  const _LaunchTestHarness({
    required this.container,
    required this.database,
  });

  final ProviderContainer container;
  final TaskFlowDatabase database;

  Future<void> dispose() async {
    container.dispose();
    await database.close();
  }
}

/// 假启动桥只提供当前测试需要的初始安全落点，不额外模拟运行中回流。
final class _FakeWidgetLaunchBridge implements WidgetLaunchBridge {
  const _FakeWidgetLaunchBridge({required this.rawLaunchLocation});

  @override
  final String rawLaunchLocation;

  @override
  Stream<String> get launchLocations => const Stream<String>.empty();

  @override
  Future<Uri?> initiallyLaunchedUri() async => Uri.tryParse(rawLaunchLocation);

  @override
  Stream<Uri?> get widgetClicked => const Stream<Uri?>.empty();
}
