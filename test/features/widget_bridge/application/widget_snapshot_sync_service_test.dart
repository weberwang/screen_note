import 'dart:ui';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
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

/// 验证 widget-bridge 会把任务快照和设置偏好投影成稳定的锁屏预览合同。
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
      preferences: const SettingsPreferences(
        maskPrivateContent: true,
        notificationsEnabled: true,
        widgetDisplayMode: WidgetDisplayMode.list3,
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

  test('loadSnapshot 会按展示模式输出三条快照并遮罩隐私事项正文', () async {
    final DateTime now = DateTime.utc(2026, 6, 6, 8);
    await repository.createTask(
      _task(id: 'pinned', title: '先处理置顶', createdAt: now, isPinned: true),
    );
    await repository.createTask(
      _task(
        id: 'today-private',
        title: '不该外露的正文',
        createdAt: now,
        dueAt: DateTime(2026, 6, 6, 18),
        isPrivate: true,
      ),
    );
    await repository.createTask(
      _task(id: 'other', title: '普通补充事项', createdAt: now),
    );
    await repository.createTask(
      _task(id: 'overflow', title: '第四条不应进入三条快照', createdAt: now),
    );

    final WidgetSnapshot snapshot = await syncService.loadSnapshot(now: now);

    expect(snapshot.displayMode, WidgetDisplayMode.list3);
    expect(snapshot.items.map((item) => item.rank), <int>[1, 2, 3]);
    expect(
      snapshot.items.map((item) => item.title),
      <String>['先处理置顶', '隐私事项', '普通补充事项'],
    );
    expect(snapshot.items[0].statusLabel, '置顶');
    expect(snapshot.items[1].statusLabel, '今天');
    expect(snapshot.items[1].isPrivate, isTrue);
    expect(snapshot.items[1].dueLabel, '18:00');
    expect(snapshot.hasPrivateContent, isTrue);
    expect(snapshot.hasFallbackContent, isFalse);
  });

  test('private 模式会输出安全摘要，并在同步时交给共享存储端口', () async {
    final DateTime now = DateTime.utc(2026, 6, 6, 8);
    settingsRepository.preferences = const SettingsPreferences(
      maskPrivateContent: true,
      notificationsEnabled: true,
      widgetDisplayMode: WidgetDisplayMode.private,
    );
    await repository.createTask(
      _task(
        id: 'private-a',
        title: '隐私一',
        createdAt: now,
        isPrivate: true,
      ),
    );
    await repository.createTask(
      _task(
        id: 'private-b',
        title: '隐私二',
        createdAt: now,
        isPrivate: true,
      ),
    );

    final bool synced = await syncService.syncSnapshot(now: now);

    expect(synced, isTrue);
    expect(snapshotStore.savedSnapshots, hasLength(1));
    expect(snapshotStore.savedSnapshots.single.displayMode, WidgetDisplayMode.private);
    expect(snapshotStore.savedSnapshots.single.items.single.title, '隐私事项内容已隐藏');
    expect(
      snapshotStore.savedSnapshots.single.items.single.dueLabel,
      '已隐藏 2 条隐私事项',
    );
    expect(snapshotStore.savedSnapshots.single.items.single.statusLabel, '隐私');
  });
}

/// 内存版设置仓储，用于验证 widget-bridge 不依赖真实 SharedPreferences 也能稳定投影。
final class _FakeSettingsPreferencesRepository
    implements SettingsPreferencesRepository {
  _FakeSettingsPreferencesRepository({required this.preferences});

  SettingsPreferences preferences;

  @override
  Future<SettingsPreferences> load() async => preferences;

  @override
  Future<void> save(SettingsPreferences preferences) async {
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

/// 测试任务构造器，统一生成可用于锁屏快照投影的 active 事项。
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
