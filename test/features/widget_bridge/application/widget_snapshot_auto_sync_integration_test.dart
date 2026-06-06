import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_bridge_runtime_providers.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';

/// 验证默认 provider 链路下，task-flow 和 settings-center 都会自动联动 Widget 快照同步。
void main() {
  test('创建事项后会自动写入最新 Widget 快照', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    final _RecordingWidgetSnapshotStore snapshotStore =
        _RecordingWidgetSnapshotStore();
    final ProviderContainer container = ProviderContainer(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(database),
        settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
        widgetSnapshotStoreProvider.overrideWithValue(snapshotStore),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);

    await container.read(createTaskUseCaseProvider).execute(
      const CreateTaskInput(title: '自动同步锁屏快照', note: ''),
      now: DateTime.utc(2026, 6, 6, 9),
    );

    expect(snapshotStore.savedSnapshots, isNotEmpty);
    expect(snapshotStore.savedSnapshots.last.items.first.title, '自动同步锁屏快照');
  });

  test('更新锁屏展示模式后会自动刷新 Widget 快照模式', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    final _RecordingWidgetSnapshotStore snapshotStore =
        _RecordingWidgetSnapshotStore();
    final ProviderContainer container = ProviderContainer(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(database),
        settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
        widgetSnapshotStoreProvider.overrideWithValue(snapshotStore),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);

    await container.read(createTaskUseCaseProvider).execute(
      const CreateTaskInput(title: '切换后刷新模式', note: ''),
      now: DateTime.utc(2026, 6, 6, 9),
    );
    snapshotStore.savedSnapshots.clear();

    await (await container.read(updateSettingsPreferencesUseCaseProvider.future))
        .execute(
          const SettingsPreferences(
            maskPrivateContent: true,
            notificationsEnabled: true,
            widgetDisplayMode: WidgetDisplayMode.today,
          ),
        );

    expect(snapshotStore.savedSnapshots, isNotEmpty);
    expect(snapshotStore.savedSnapshots.last.displayMode, WidgetDisplayMode.today);
  });
}

/// 记录型共享存储端口，用于验证默认 provider 链路确实触发了自动同步。
final class _RecordingWidgetSnapshotStore implements WidgetSnapshotStore {
  final List<WidgetSnapshot> savedSnapshots = <WidgetSnapshot>[];

  @override
  Future<bool> saveSnapshot(WidgetSnapshot snapshot) async {
    savedSnapshots.add(snapshot);
    return true;
  }
}
