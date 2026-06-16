import 'dart:ui';

import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/router/app_router.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/infrastructure/settings_preferences_repository_impl.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_bridge_runtime_providers.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';

/// 运行态证据测试场景，只保留当前 parity 验收真正需要的三类数据姿态。
enum RuntimeCaptureFixture {
  /// 覆盖首页、编辑、设置、最近删除与 Widget 预览的主场景。
  runtimePack,

  /// 覆盖 Widget 空态的降级场景。
  widgetEmpty,

  /// 覆盖最近完成空态的降级场景。
  historyCompletedEmpty,
}

/// 运行态证据测试夹具，统一承接数据库、偏好和路由容器。
final class RuntimeCaptureHarness {
  /// 创建测试夹具。
  RuntimeCaptureHarness({
    required this.container,
    required this.database,
    required this.preferences,
  });

  /// Riverpod 容器。
  final ProviderContainer container;

  /// 内存数据库。
  final TaskFlowDatabase database;

  /// 共享偏好实例。
  final SharedPreferences preferences;

  /// 当前应用路由器，供测试驱动真实页面切换。
  GoRouter get router => container.read(appRouterProvider);
}

/// 创建运行态证据测试夹具，并按指定场景预灌入真实领域数据。
Future<RuntimeCaptureHarness> pumpRuntimeCaptureHarness(
  WidgetTester tester, {
  required RuntimeCaptureFixture fixture,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(430, 932);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  SharedPreferences.setMockInitialValues(<String, Object>{});
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final TaskFlowDatabase database = TaskFlowDatabase.test(
    NativeDatabase.memory(),
  );
  final ProviderContainer container = ProviderContainer(
    overrides: [
      taskFlowDatabaseProvider.overrideWithValue(database),
      settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
      widgetLaunchBridgeProvider.overrideWithValue(const _FakeWidgetLaunchBridge()),
      widgetSnapshotStoreProvider.overrideWithValue(const _FakeWidgetSnapshotStore()),
    ],
  );
  addTearDown(container.dispose);
  addTearDown(database.close);

  await _seedFixture(
    database: database,
    preferences: preferences,
    fixture: fixture,
  );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const ScreenNoteApp(),
    ),
  );
  await tester.pumpAndSettle();

  return RuntimeCaptureHarness(
    container: container,
    database: database,
    preferences: preferences,
  );
}

/// 按真实仓储路径灌入测试数据，避免 golden 只验证假模型而非真实状态投影。
Future<void> _seedFixture({
  required TaskFlowDatabase database,
  required SharedPreferences preferences,
  required RuntimeCaptureFixture fixture,
}) async {
  final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
    database: database,
  );
  final SettingsPreferencesRepositoryImpl settingsRepository =
      SettingsPreferencesRepositoryImpl(preferences: preferences);
  final DateTime now = DateTime.utc(2026, 6, 6, 8);

  await settingsRepository.savePreferences(
    SettingsCenterPreferences(
      privacyModeEnabled: true,
      widgetDisplayMode: switch (fixture) {
        RuntimeCaptureFixture.widgetEmpty => WidgetDisplayMode.empty,
        _ => WidgetDisplayMode.list3,
      },
    ),
  );

  await database.delete(database.taskEventRecords).go();
  await database.delete(database.taskRecords).go();

  switch (fixture) {
    case RuntimeCaptureFixture.runtimePack:
      await repository.createTask(
        _task(
          id: 'pinned',
          title: '先处理置顶',
          createdAt: now,
          isPinned: true,
        ),
      );
      await repository.createTask(
        _task(
          id: 'private-today',
          title: '不该外露的正文',
          createdAt: now.add(const Duration(minutes: 5)),
          dueAt: DateTime.utc(2026, 6, 6, 18),
          isPrivate: true,
        ),
      );
      await repository.createTask(
        _task(
          id: 'other',
          title: '普通补充事项',
          createdAt: now.add(const Duration(minutes: 10)),
        ),
      );
      await repository.createTask(
        _task(
          id: 'deleted-task',
          title: '不该被真正删除',
          createdAt: now.add(const Duration(minutes: 15)),
          isPrivate: true,
          status: TaskStatus.deleted,
          deletedAt: now.add(const Duration(hours: 2)),
        ),
      );
    case RuntimeCaptureFixture.widgetEmpty:
      break;
    case RuntimeCaptureFixture.historyCompletedEmpty:
      await repository.createTask(
        _task(
          id: 'deleted-only',
          title: '只保留删除态',
          createdAt: now,
          status: TaskStatus.deleted,
          deletedAt: now.add(const Duration(hours: 2)),
        ),
      );
  }
}

/// 统一驱动真实应用路由并输出金丝雀，避免每个测试散落相同的导航样板。
Future<void> expectRouteGolden(
  WidgetTester tester, {
  required RuntimeCaptureHarness harness,
  required String route,
  required String goldenPath,
}) async {
  harness.router.go(route);
  await tester.pumpAndSettle();
  await expectCurrentGolden(tester, goldenPath: goldenPath);
}

/// 对当前整棵应用树做金丝雀比对，供需要先断言再截图的场景复用。
Future<void> expectCurrentGolden(
  WidgetTester tester, {
  required String goldenPath,
}) async {
  await expectLater(
    find.byType(ScreenNoteApp),
    matchesGoldenFile(goldenPath),
  );
}

/// 构造满足持久化约束的任务实体，避免每个场景复制字段清单。
TaskEntity _task({
  required String id,
  required String title,
  required DateTime createdAt,
  DateTime? dueAt,
  bool isPinned = false,
  bool isPrivate = false,
  TaskStatus status = TaskStatus.active,
  DateTime? deletedAt,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: '',
    dueAt: dueAt,
    reminderAt: null,
    isPinned: isPinned,
    isPrivate: isPrivate,
    status: status,
    reminderMode: TaskReminderMode.normal,
    createdAt: createdAt,
    updatedAt: createdAt,
    completedAt: status == TaskStatus.completed ? createdAt : null,
    deletedAt: deletedAt,
  );
}

/// 内存版快照存储，保证手动同步动作不依赖平台插件。
final class _FakeWidgetSnapshotStore implements WidgetSnapshotStore {
  /// 创建测试用假存储。
  const _FakeWidgetSnapshotStore();

  @override
  Future<bool> saveSnapshot(WidgetSnapshot snapshot) async => true;
}

/// 测试版 Widget 启动桥接，统一阻断插件通道调用，避免运行态证据测试受平台能力影响。
final class _FakeWidgetLaunchBridge implements WidgetLaunchBridge {
  /// 创建测试用启动桥接。
  const _FakeWidgetLaunchBridge();

  @override
  String get rawLaunchLocation => RoutePaths.home;

  @override
  Stream<String> get launchLocations => const Stream<String>.empty();

  @override
  Future<Uri?> initiallyLaunchedUri() async => null;

  @override
  Stream<Uri?> get widgetClicked => const Stream<Uri?>.empty();
}
