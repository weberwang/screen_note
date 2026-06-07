import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/infrastructure/settings_preferences_repository_impl.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_bridge_runtime_providers.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';

/// 浏览器运行态取证场景，仅保留当前 parity 验收需要的稳定数据姿态。
enum RuntimeCaptureScenario {
  /// 覆盖首页、编辑、设置、最近删除与 Widget 预览的主场景。
  runtimePack,

  /// 覆盖 Widget 空态。
  widgetEmpty,

  /// 覆盖最近完成空态。
  historyCompletedEmpty;

  /// 从 URL query 读取场景；非法值统一保守回退到主场景。
  static RuntimeCaptureScenario fromBaseUri(Uri baseUri) {
    return switch (baseUri.queryParameters['scenario']) {
      'widget-empty' => RuntimeCaptureScenario.widgetEmpty,
      'history-completed-empty' => RuntimeCaptureScenario.historyCompletedEmpty,
      _ => RuntimeCaptureScenario.runtimePack,
    };
  }
}

/// 运行态取证入口，启动后先灌入固定事实，再挂载正式应用路由树。
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final RuntimeCaptureScenario scenario = RuntimeCaptureScenario.fromBaseUri(
    Uri.base,
  );
  final _RuntimeCaptureTaskRepository repository = await _prepareScenario(
    preferences: preferences,
    scenario: scenario,
  );

  runApp(
    ProviderScope(
      overrides: [
        taskRepositoryProvider.overrideWithValue(repository),
        settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
        widgetLaunchBridgeProvider.overrideWithValue(const _FakeWidgetLaunchBridge()),
        widgetSnapshotStoreProvider.overrideWithValue(
          const _RuntimeCaptureSnapshotStore(),
        ),
      ],
      child: const ScreenNoteApp(),
    ),
  );
}

/// 准备浏览器取证所需的内存事实源和共享偏好，避免 Web 端依赖缺失阻断 UI 证据抓取。
Future<_RuntimeCaptureTaskRepository> _prepareScenario({
  required SharedPreferences preferences,
  required RuntimeCaptureScenario scenario,
}) async {
  final SettingsPreferencesRepositoryImpl settingsRepository =
      SettingsPreferencesRepositoryImpl(preferences: preferences);
  final DateTime now = DateTime.utc(2026, 6, 6, 8);
  final List<TaskEntity> tasks = <TaskEntity>[];

  await settingsRepository.save(
    SettingsPreferences(
      maskPrivateContent: true,
      notificationsEnabled: true,
      widgetDisplayMode: switch (scenario) {
        RuntimeCaptureScenario.widgetEmpty => WidgetDisplayMode.empty,
        _ => WidgetDisplayMode.list3,
      },
    ),
  );

  switch (scenario) {
    case RuntimeCaptureScenario.runtimePack:
      tasks.add(
        _task(
          id: 'pinned',
          title: '先处理置顶',
          createdAt: now,
          isPinned: true,
        ),
      );
      tasks.add(
        _task(
          id: 'private-today',
          title: '不该外露的正文',
          createdAt: now.add(const Duration(minutes: 5)),
          dueAt: DateTime.utc(2026, 6, 6, 18),
          isPrivate: true,
        ),
      );
      tasks.add(
        _task(
          id: 'other',
          title: '普通补充事项',
          createdAt: now.add(const Duration(minutes: 10)),
        ),
      );
      tasks.add(
        _task(
          id: 'deleted-task',
          title: '不该被真正删除',
          createdAt: now.add(const Duration(minutes: 15)),
          isPrivate: true,
          status: TaskStatus.deleted,
          deletedAt: now.add(const Duration(hours: 2)),
        ),
      );
    case RuntimeCaptureScenario.widgetEmpty:
      break;
    case RuntimeCaptureScenario.historyCompletedEmpty:
      tasks.add(
        _task(
          id: 'deleted-only',
          title: '只保留删除态',
          createdAt: now,
          status: TaskStatus.deleted,
          deletedAt: now.add(const Duration(hours: 2)),
        ),
      );
  }

  return _RuntimeCaptureTaskRepository(tasks);
}

/// 构造满足持久化约束的事项事实，保证浏览器取证和测试取证的输入一致。
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

/// 运行态取证时统一关闭 Widget 启动桥接，避免浏览器环境误触平台插件通道。
final class _FakeWidgetLaunchBridge implements WidgetLaunchBridge {
  /// 创建测试用桥接。
  const _FakeWidgetLaunchBridge();

  @override
  Future<Uri?> initiallyLaunchedUri() async => null;

  @override
  Stream<Uri?> get widgetClicked => const Stream<Uri?>.empty();
}

/// 浏览器取证无需真正写入平台共享容器，这里保留成功返回以验证页面动作。
final class _RuntimeCaptureSnapshotStore implements WidgetSnapshotStore {
  /// 创建取证用快照存储。
  const _RuntimeCaptureSnapshotStore();

  @override
  Future<bool> saveSnapshot(WidgetSnapshot snapshot) async => true;
}

/// 运行态取证仓储，只提供当前截图场景所需的内存事实读取能力。
final class _RuntimeCaptureTaskRepository implements TaskRepository {
  /// 创建取证仓储。
  _RuntimeCaptureTaskRepository(List<TaskEntity> tasks)
    : _tasks = <String, TaskEntity>{
        for (final TaskEntity task in tasks) task.id: task,
      };

  final Map<String, TaskEntity> _tasks;

  @override
  Future<void> createTask(TaskEntity task) async {
    _tasks[task.id] = task;
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    _tasks[task.id] = task;
  }

  @override
  Future<TaskEntity?> findTaskById(String id) async => _tasks[id];

  @override
  Future<List<TaskEntity>> loadTasksByStatus(TaskStatus status) async {
    final List<TaskEntity> tasks = _tasks.values
        .where((task) => task.status == status)
        .toList(growable: false);
    tasks.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return tasks;
  }

  @override
  Future<int> countTasksByStatus(TaskStatus status) async {
    return _tasks.values.where((task) => task.status == status).length;
  }

  @override
  Future<void> appendEvent(TaskEventEntity event) async {}
}
