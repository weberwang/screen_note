import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/features/history_center/domain/entities/history_section.dart';
import 'package:screen_note/features/history_center/presentation/pages/history_center_page.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_bridge_runtime_providers.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 验证历史页在最近删除分区会显示恢复动作，并在恢复后立即刷新列表。
void main() {
  testWidgets('最近删除页恢复事项后会立即移出列表', (WidgetTester tester) async {
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    addTearDown(database.close);

    final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
      database: database,
    );
    final _FakeWidgetSnapshotStore snapshotStore = _FakeWidgetSnapshotStore();
    final DateTime now = DateTime.utc(2026, 6, 6, 10);
    await repository.createTask(
      _task(
        id: 'deleted-task',
        title: '不该被真正删除',
        createdAt: now,
        isPrivate: true,
        status: TaskStatus.deleted,
        deletedAt: now.add(const Duration(hours: 2)),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(database),
          widgetSnapshotStoreProvider.overrideWithValue(snapshotStore),
        ],
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildScreenNoteLightTheme(),
          darkTheme: buildScreenNoteDarkTheme(),
          home: const Scaffold(
            body: HistoryCenterPage(initialSection: HistorySection.deleted),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('最近删除'), findsWidgets);
    expect(find.text('隐私事项'), findsOneWidget);
    expect(find.text('恢复'), findsOneWidget);

    await tester.tap(find.text('恢复'));
    await tester.pumpAndSettle();

    expect(
      (await repository.findTaskById('deleted-task'))?.status,
      TaskStatus.active,
    );
  });
}

/// 内存版小组件快照存储，用于隔离历史页测试与真实同步能力。
final class _FakeWidgetSnapshotStore implements WidgetSnapshotStore {
  @override
  Future<bool> saveSnapshot(WidgetSnapshot snapshot) async => true;
}

/// 测试任务构造器，统一生成满足持久化约束的实体。
TaskEntity _task({
  required String id,
  required String title,
  required DateTime createdAt,
  required TaskStatus status,
  required bool isPrivate,
  DateTime? deletedAt,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: '',
    dueAt: null,
    reminderAt: null,
    isPinned: false,
    isPrivate: isPrivate,
    status: status,
    reminderMode: TaskReminderMode.normal,
    createdAt: createdAt,
    updatedAt: createdAt,
    completedAt: null,
    deletedAt: deletedAt,
  );
}
