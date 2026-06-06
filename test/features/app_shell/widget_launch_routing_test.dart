import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/router/app_router.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:screen_note/features/history_center/presentation/pages/history_center_page.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 验证系统 Widget 回流会被 ScreenNoteApp 监听并分发到统一 launch 路由。
void main() {
  testWidgets('收到 widget launch URI 后会自动跳到历史中心', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    final _FakeWidgetLaunchBridge bridge = _FakeWidgetLaunchBridge();
    addTearDown(database.close);

    final ProviderContainer container = ProviderContainer(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(database),
        settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
        widgetLaunchBridgeProvider.overrideWithValue(bridge),
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

    bridge.emit(Uri.parse('screennote://launch?source=widget&target=history-deleted'));
    await tester.pumpAndSettle();

    expect(find.byType(AppShellPage), findsOneWidget);
    expect(find.byType(HistoryCenterPage), findsOneWidget);
    expect(container.read(appRouterProvider).routeInformationProvider.value.uri.toString(), '/history?section=deleted');
    expect(_currentSnackBarMessage(tester), contains(_localizations(tester).historyDeletedTitle));
  });
}

/// 测试用 Widget 回流桥接，允许手动发射初始 URI 和点击事件。
final class _FakeWidgetLaunchBridge implements WidgetLaunchBridge {
  final StreamController<Uri?> _controller = StreamController<Uri?>.broadcast();

  @override
  Stream<Uri?> get widgetClicked => _controller.stream;

  @override
  Future<Uri?> initiallyLaunchedUri() async => null;

  void emit(Uri uri) {
    _controller.add(uri);
  }
}

/// 读取当前页面的本地化实例，避免测试里写死特定语言。
AppLocalizations _localizations(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(AppShellPage)));
}

/// 读取壳层当前展示的轻反馈内容，用来验证 widget 回流确实走过统一反馈宿主。
String _currentSnackBarMessage(WidgetTester tester) {
  final SnackBar snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
  final Text content = snackBar.content as Text;
  return content.data ?? '';
}
