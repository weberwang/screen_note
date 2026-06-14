import 'dart:ui';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/application/services/widget_snapshot_sync_service.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/widget_snapshot_projector.dart';

/// 验证 widget-bridge 会把任务快照和设置偏好投影成稳定的共享展示合同。
void main() {
  late TaskFlowDatabase database;
  late TaskFlowRepositoryImpl repository;
  late _FakeSettingsPreferencesRepository settingsRepository;
  late _FakeWidgetSnapshotStore snapshotStore;
  late WidgetSnapshotSyncService syncService;

  setUp(() {
    database = TaskFlowDatabase.test(NativeDatabase.memory());
    repository = TaskFlowRepositoryImpl(database: database);
    settingsRepository = _FakeSettingsPreferencesRepository(
      preferences: const SettingsCenterPreferences(
        privacyModeEnabled: false,
        widgetDisplayMode: WidgetDisplayMode.fullContent,
      ),
    );
    snapshotStore = _FakeWidgetSnapshotStore();
    syncService = WidgetSnapshotSyncService(
      taskRepository: repository,
      settingsRepository: settingsRepository,
      snapshotStore: snapshotStore,
      projector: const WidgetSnapshotProjector(),
      locale: const Locale('zh'),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('fullContent 模式会把最高优先级事项投影成可读快照', () async {
    final DateTime now = DateTime(2026, 6, 6, 8);
    await repository.createTask(
      _task(id: 'normal', title: '普通事项', createdAt: now),
    );
    await repository.createTask(
      _task(
        id: 'pinned',
        title: '先处理置顶',
        createdAt: now,
        isPinned: true,
        dueAt: DateTime(2026, 6, 6, 18),
      ),
    );

    final WidgetSnapshot snapshot = await syncService.loadSnapshot(now: now);

    expect(snapshot.displayMode, WidgetDisplayMode.fullContent);
    expect(snapshot.items, hasLength(1));
    expect(snapshot.items.single.title, '先处理置顶');
    expect(snapshot.items.single.statusLabel, '今天');
    expect(snapshot.items.single.dueLabel, '18:00');
    expect(snapshot.hasPrivateContent, isFalse);
  });

  test('previewOnly 模式会隐藏正文并保留安全回流提示', () async {
    final DateTime now = DateTime(2026, 6, 6, 8);
    settingsRepository.preferences = const SettingsCenterPreferences(
      privacyModeEnabled: false,
      widgetDisplayMode: WidgetDisplayMode.previewOnly,
    );
    await repository.createTask(
      _task(id: 'task-1', title: '不该直接外露的正文', createdAt: now),
    );

    final WidgetSnapshot snapshot = await syncService.loadSnapshot(now: now);

    expect(snapshot.items.single.title, '预览内容已隐藏');
    expect(snapshot.items.single.statusLabel, '安全预览');
    expect(snapshot.items.single.dueLabel, '点按后回到应用查看');
  });

  test('私密事项即使在 fullContent 模式下也必须被安全遮罩', () async {
    final DateTime now = DateTime(2026, 6, 6, 8);
    await repository.createTask(
      _task(
        id: 'private-task',
        title: '私密正文',
        createdAt: now,
        isPrivate: true,
      ),
    );

    final WidgetSnapshot snapshot = await syncService.loadSnapshot(now: now);

    expect(snapshot.items.single.title, '隐私事项内容已隐藏');
    expect(snapshot.items.single.statusLabel, '受保护');
    expect(snapshot.items.single.isPrivate, isTrue);
    expect(snapshot.hasPrivateContent, isTrue);
  });

  test('syncSnapshot 会把稳定快照交给共享存储端口', () async {
    final DateTime now = DateTime(2026, 6, 6, 8);
    await repository.createTask(
      _task(id: 'task-1', title: '同步到 Widget', createdAt: now),
    );

    final bool synced = await syncService.syncSnapshot(now: now);

    expect(synced, isTrue);
    expect(snapshotStore.savedSnapshots, hasLength(1));
    expect(snapshotStore.savedSnapshots.single.items.single.title, '同步到 Widget');
  });
}

/// 内存版设置仓储，用于验证 widget-bridge 不依赖真实 SharedPreferences 也能稳定投影。
final class _FakeSettingsPreferencesRepository
    implements SettingsPreferencesRepository {
  _FakeSettingsPreferencesRepository({required this.preferences});

  SettingsCenterPreferences preferences;

  @override
  Future<SettingsCenterPreferences> loadPreferences() async => preferences;

  @override
  Future<void> savePreferences(SettingsCenterPreferences preferences) async {
    this.preferences = preferences;
  }
}

/// 内存版快照存储端口，用于验证同步时确实交付了稳定快照。
final class _FakeWidgetSnapshotStore implements WidgetSnapshotStore {
  final List<WidgetSnapshot> savedSnapshots = <WidgetSnapshot>[];

  @override
  Future<bool> saveSnapshot(WidgetSnapshot snapshot) async {
    savedSnapshots.add(snapshot);
    return true;
  }
}

/// 测试任务构造器，统一生成可用于 Widget 快照投影的 active 事项。
TaskEntity _task({
  required String id,
  required String title,
  required DateTime createdAt,
  DateTime? dueAt,
  bool isPinned = false,
  bool isPrivate = false,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: '',
    dueAt: dueAt,
    reminderAt: null,
    isPinned: isPinned,
    isPrivate: isPrivate,
    status: TaskStatus.active,
    reminderMode: TaskReminderMode.normal,
    createdAt: createdAt,
    updatedAt: createdAt,
    completedAt: null,
    deletedAt: null,
  );
}
