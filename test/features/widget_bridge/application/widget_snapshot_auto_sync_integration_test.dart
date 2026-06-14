import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_bridge_runtime_providers.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/widget_snapshot_settings_side_effect_port.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/widget_snapshot_task_flow_side_effect_port.dart';

/// 验证默认 Provider 链路下，task-flow 与 settings-center 都会自动联动 Widget 快照同步。
void main() {
  test('创建事项后会自动写入最新 Widget 快照', () async {
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    final _RecordingWidgetSnapshotStore snapshotStore =
        _RecordingWidgetSnapshotStore();
    final _InMemorySettingsPreferencesRepository preferencesRepository =
        _InMemorySettingsPreferencesRepository(
          initial: const SettingsCenterPreferences(
            privacyModeEnabled: false,
            widgetDisplayMode: WidgetDisplayMode.fullContent,
          ),
        );
    final ProviderContainer container = ProviderContainer(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(database),
        settingsPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
        widgetSnapshotStoreProvider.overrideWithValue(snapshotStore),
        defaultTaskFlowSideEffectPortProvider.overrideWith((ref) {
          return WidgetSnapshotTaskFlowSideEffectPort(
            coordinator: ref.watch(widgetSnapshotAutoSyncCoordinatorProvider),
            logger: ref.watch(appLoggerProvider),
          );
        }),
        defaultSettingsSideEffectPortProvider.overrideWith((ref) {
          return WidgetSnapshotSettingsSideEffectPort(
            coordinator: ref.watch(widgetSnapshotAutoSyncCoordinatorProvider),
            logger: ref.watch(appLoggerProvider),
          );
        }),
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

  test('更新 Widget 展示模式后会自动刷新共享快照模式', () async {
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    final _RecordingWidgetSnapshotStore snapshotStore =
        _RecordingWidgetSnapshotStore();
    final _InMemorySettingsPreferencesRepository preferencesRepository =
        _InMemorySettingsPreferencesRepository(
          initial: const SettingsCenterPreferences(
            privacyModeEnabled: false,
            widgetDisplayMode: WidgetDisplayMode.fullContent,
          ),
        );
    final ProviderContainer container = ProviderContainer(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(database),
        settingsPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
        widgetSnapshotStoreProvider.overrideWithValue(snapshotStore),
        defaultTaskFlowSideEffectPortProvider.overrideWith((ref) {
          return WidgetSnapshotTaskFlowSideEffectPort(
            coordinator: ref.watch(widgetSnapshotAutoSyncCoordinatorProvider),
            logger: ref.watch(appLoggerProvider),
          );
        }),
        defaultSettingsSideEffectPortProvider.overrideWith((ref) {
          return WidgetSnapshotSettingsSideEffectPort(
            coordinator: ref.watch(widgetSnapshotAutoSyncCoordinatorProvider),
            logger: ref.watch(appLoggerProvider),
          );
        }),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);

    await container.read(createTaskUseCaseProvider).execute(
      const CreateTaskInput(title: '切换后刷新模式', note: ''),
      now: DateTime.utc(2026, 6, 6, 9),
    );
    snapshotStore.savedSnapshots.clear();

    await container.read(updateWidgetDisplayModeUseCaseProvider).execute(
      mode: WidgetDisplayMode.previewOnly,
    );

    expect(snapshotStore.savedSnapshots, isNotEmpty);
    expect(
      snapshotStore.savedSnapshots.last.displayMode,
      WidgetDisplayMode.previewOnly,
    );
    expect(
      snapshotStore.savedSnapshots.last.items.single.title,
      isNot('切换后刷新模式'),
    );
  });
}

/// 记录型共享存储端口，用于验证默认 Provider 链路确实触发了自动同步。
final class _RecordingWidgetSnapshotStore implements WidgetSnapshotStore {
  final List<WidgetSnapshot> savedSnapshots = <WidgetSnapshot>[];

  @override
  Future<bool> saveSnapshot(WidgetSnapshot snapshot) async {
    savedSnapshots.add(snapshot);
    return true;
  }
}

/// 内存偏好仓储，供 Provider 集成测试替换真实 shared_preferences。
final class _InMemorySettingsPreferencesRepository
    implements SettingsPreferencesRepository {
  _InMemorySettingsPreferencesRepository({
    required SettingsCenterPreferences initial,
  }) : _current = initial;

  SettingsCenterPreferences _current;

  @override
  Future<SettingsCenterPreferences> loadPreferences() async => _current;

  @override
  Future<void> savePreferences(SettingsCenterPreferences preferences) async {
    _current = preferences;
  }
}
