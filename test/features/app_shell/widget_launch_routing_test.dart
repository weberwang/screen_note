import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_editor_page.dart';

/// 验证 ScreenNoteApp 会监听运行中的安全回流路线并跳到正式编辑页。
void main() {
  testWidgets('收到安全 task-editor 回流后会自动进入任务编辑页', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1170, 2532);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    addTearDown(database.close);
    final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
      database: database,
    );
    await repository.createTask(
      _task(
        id: 'task-42',
        title: '来自小组件',
        note: '待回流',
        createdAt: DateTime(2026, 6, 14, 9),
      ),
    );

    final StreamController<String> controller = StreamController<String>.broadcast();
    addTearDown(controller.close);

    final ProviderContainer container = ProviderContainer(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(database),
        settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
        widgetLaunchBridgeProvider.overrideWithValue(
          _FakeWidgetLaunchBridge(
            rawLaunchLocation: RoutePaths.home,
            launchLocations: controller.stream,
          ),
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

    controller.add('${RoutePaths.taskEditor}?taskId=task-42');
    await tester.pumpAndSettle();

    expect(find.byType(TaskFlowEditorPage), findsOneWidget);

    final TextField titleField = tester.widget<TextField>(
      find.byType(TextField).first,
    );
    expect(titleField.controller?.text, '来自小组件');
  });
}

/// 假启动桥用于模拟运行中的安全回流流，不重建平台层行为。
final class _FakeWidgetLaunchBridge implements WidgetLaunchBridge {
  const _FakeWidgetLaunchBridge({
    required this.rawLaunchLocation,
    this.launchLocations = const Stream<String>.empty(),
  });

  @override
  final String rawLaunchLocation;

  @override
  final Stream<String> launchLocations;

  @override
  Future<Uri?> initiallyLaunchedUri() async => Uri.tryParse(rawLaunchLocation);

  @override
  Stream<Uri?> get widgetClicked => launchLocations.map(Uri.tryParse);
}

/// 测试任务构造器，统一生成可回流到编辑页的 active 事项。
TaskEntity _task({
  required String id,
  required String title,
  required String note,
  required DateTime createdAt,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: note,
    dueAt: null,
    reminderAt: null,
    isPinned: false,
    isPrivate: false,
    status: TaskStatus.active,
    reminderMode: TaskReminderMode.normal,
    createdAt: createdAt,
    updatedAt: createdAt,
    completedAt: null,
    deletedAt: null,
  );
}
