import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_bridge_runtime_providers.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';
import 'package:screen_note/features/widget_bridge/presentation/pages/widget_bridge_page.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 验证 widget-bridge 会渲染真实快照预览，并把手动同步交给共享存储端口。
void main() {
  testWidgets('预览页会把隐私事项渲染成安全摘要并允许手动同步快照', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'settings.maskPrivateContent': true,
      'settings.widgetDisplayMode': 'list3',
    });
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    addTearDown(database.close);
    final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
      database: database,
    );
    final _FakeWidgetSnapshotStore snapshotStore = _FakeWidgetSnapshotStore();
    final DateTime now = DateTime.utc(2026, 6, 6, 8);

    await repository.createTask(
      _task(id: 'pinned', title: '先处理置顶', createdAt: now, isPinned: true),
    );
    await repository.createTask(
      _task(
        id: 'private-today',
        title: '不该外露的正文',
        createdAt: now,
        dueAt: DateTime(2026, 6, 6, 18),
        isPrivate: true,
      ),
    );
    await repository.createTask(
      _task(id: 'other', title: '普通补充事项', createdAt: now),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(database),
          settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
          widgetSnapshotStoreProvider.overrideWithValue(snapshotStore),
        ],
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildScreenNoteLightTheme(),
          darkTheme: buildScreenNoteDarkTheme(),
          home: const Scaffold(body: WidgetBridgePage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('不该外露的正文'), findsNothing);
    expect(find.textContaining('18:00'), findsNothing);
    await tester.scrollUntilVisible(
      find.byKey(const Key('widget-bridge-sync-button')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('widget-bridge-sync-button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('widget-bridge-sync-button')));
    await tester.pumpAndSettle();

    expect(snapshotStore.savedSnapshots, hasLength(1));
    expect(find.text('已同步最新稳定快照。'), findsOneWidget);
  });
}

/// 内存版共享存储端口，用于验证页面动作确实触发了快照同步。
final class _FakeWidgetSnapshotStore implements WidgetSnapshotStore {
  final List<WidgetSnapshot> savedSnapshots = <WidgetSnapshot>[];

  @override
  Future<bool> saveSnapshot(WidgetSnapshot snapshot) async {
    savedSnapshots.add(snapshot);
    return true;
  }
}

/// 测试任务构造器，统一生成用于 Widget 预览的 active 事项。
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
