import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/features/tasks/application/services/task_display_state_resolver.dart';
import 'package:screen_note/features/tasks/application/services/task_sorting_service.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/domain/repositories/task_repository.dart';
import 'package:screen_note/features/widget_bridge/application/widget_refresh_result.dart';
import 'package:screen_note/features/widget_bridge/application/widget_refresh_scheduler.dart';
import 'package:screen_note/features/widget_bridge/application/widget_snapshot_builder.dart';
import 'package:screen_note/features/widget_bridge/domain/enums/widget_display_mode.dart';
import 'package:screen_note/features/widget_bridge/domain/models/widget_snapshot.dart';
import 'package:screen_note/features/widget_bridge/domain/repositories/widget_display_mode_repository.dart';
import 'package:screen_note/features/widget_bridge/domain/repositories/widget_snapshot_store.dart';

/// 验证 Widget 刷新调度与降级规则。
void main() {
  final DateTime now = DateTime(2026, 5, 25, 10);

  WidgetSnapshotBuilder createBuilder() {
    return WidgetSnapshotBuilder(
      displayStateResolver: TaskDisplayStateResolver(),
      textResolver: _SchedulerTextResolver(),
      now: () => now,
      snapshotIdGenerator: () => 'snapshot-${DateTime.now().microsecondsSinceEpoch}',
    );
  }

  test('刷新成功时返回 success 并写入快照', () async {
    final _InMemoryWidgetSnapshotStore store = _InMemoryWidgetSnapshotStore();
    final WidgetRefreshScheduler scheduler = WidgetRefreshScheduler(
      taskRepository: _InMemoryTaskRepository(<Task>[
        _task(id: '1', title: '置顶事项', createdAt: now, isPinned: true),
      ]),
      taskSortingService: TaskSortingService(),
      displayModeRepository: const _FixedWidgetDisplayModeRepository(
        WidgetDisplayMode.single,
      ),
      snapshotBuilder: createBuilder(),
      snapshotStore: store,
      now: () => now,
    );

    final WidgetRefreshResult result = await scheduler.refresh();

    expect(result, WidgetRefreshResult.success);
    expect(store.currentSnapshot?.displayMode, WidgetDisplayMode.single);
    expect(store.currentSnapshot?.items.single.title, '置顶事项');
  });

  test('主写入失败但存在最后有效内容时返回 savedFallback', () async {
    final WidgetSnapshot fallbackSnapshot = createBuilder().build(
      sortedTasks: <Task>[
        _task(id: 'old', title: '旧内容', createdAt: now, isPinned: true),
      ],
      displayMode: WidgetDisplayMode.single,
    );
    final _InMemoryWidgetSnapshotStore store = _InMemoryWidgetSnapshotStore(
      fallbackSnapshot: fallbackSnapshot,
      failOnPrimarySave: true,
    );
    final WidgetRefreshScheduler scheduler = WidgetRefreshScheduler(
      taskRepository: _InMemoryTaskRepository(<Task>[
        _task(id: '1', title: '新内容', createdAt: now),
      ]),
      taskSortingService: TaskSortingService(),
      displayModeRepository: const _FixedWidgetDisplayModeRepository(
        WidgetDisplayMode.single,
      ),
      snapshotBuilder: createBuilder(),
      snapshotStore: store,
      now: () => now,
    );

    final WidgetRefreshResult result = await scheduler.refresh();

    expect(result, WidgetRefreshResult.savedFallback);
    expect(store.currentSnapshot?.hasFallbackContent, isTrue);
    expect(store.currentSnapshot?.items.single.title, '旧内容');
  });

  test('主写入失败且没有有效快照时保存空态 fallback', () async {
    final _InMemoryWidgetSnapshotStore store = _InMemoryWidgetSnapshotStore(
      failOnPrimarySave: true,
    );
    final WidgetRefreshScheduler scheduler = WidgetRefreshScheduler(
      taskRepository: _InMemoryTaskRepository(<Task>[
        _task(id: '1', title: '今天到期', createdAt: now),
      ]),
      taskSortingService: TaskSortingService(),
      displayModeRepository: const _FixedWidgetDisplayModeRepository(
        WidgetDisplayMode.today,
      ),
      snapshotBuilder: createBuilder(),
      snapshotStore: store,
      now: () => now,
    );

    final WidgetRefreshResult result = await scheduler.refresh();

    expect(result, WidgetRefreshResult.savedFallback);
    expect(store.currentSnapshot?.displayMode, WidgetDisplayMode.empty);
    expect(store.currentSnapshot?.hasFallbackContent, isTrue);
  });
}

Task _task({
  required String id,
  required String title,
  required DateTime createdAt,
  bool isPinned = false,
}) {
  return Task(
    id: id,
    title: title,
    status: TaskStatus.active,
    isPinned: isPinned,
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}

class _InMemoryTaskRepository implements TaskRepository {
  _InMemoryTaskRepository(List<Task> tasks) : _tasks = tasks;

  final List<Task> _tasks;

  @override
  Future<List<Task>> findAll() async => _tasks;

  @override
  Future<Task?> findById(String id) async {
    for (final Task task in _tasks) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  @override
  Future<void> save(Task task) async {
    throw UnimplementedError();
  }

  @override
  Future<void> saveAll(Iterable<Task> tasks) async {
    throw UnimplementedError();
  }

  @override
  Stream<List<Task>> watchAll() async* {
    yield _tasks;
  }

  @override
  Stream<Task?> watchById(String id) async* {
    yield await findById(id);
  }
}

class _InMemoryWidgetSnapshotStore implements WidgetSnapshotStore {
  _InMemoryWidgetSnapshotStore({
    this.fallbackSnapshot,
    this.failOnPrimarySave = false,
  });

  final WidgetSnapshot? fallbackSnapshot;
  final bool failOnPrimarySave;
  WidgetSnapshot? currentSnapshot;
  int _saveCount = 0;

  @override
  Future<WidgetSnapshot?> read() async => currentSnapshot;

  @override
  Future<WidgetSnapshot?> readLastValid() async {
    return fallbackSnapshot ?? currentSnapshot;
  }

  @override
  Future<void> save(WidgetSnapshot snapshot) async {
    _saveCount += 1;
    if (failOnPrimarySave && _saveCount == 1) {
      throw StateError('primary_save_failed');
    }
    currentSnapshot = snapshot;
  }
}

class _SchedulerTextResolver implements WidgetSnapshotTextResolver {
  @override
  String dueLabelForTask(Task task) => '';

  @override
  String emptyTitle() => '暂无可展示事项';

  @override
  String fallbackHint() => 'fallback';

  @override
  String privateSummary({required int itemCount}) => '已隐藏 $itemCount 条事项';

  @override
  String statusLabelForTask(
    Task task, {
    required TaskDisplayState state,
  }) {
    return task.isPinned ? '置顶' : '正常';
  }
}

class _FixedWidgetDisplayModeRepository implements WidgetDisplayModeRepository {
  const _FixedWidgetDisplayModeRepository(this.mode);

  final WidgetDisplayMode mode;

  @override
  Future<WidgetDisplayMode> read() async => mode;

  @override
  Future<void> save(WidgetDisplayMode mode) async {}
}
