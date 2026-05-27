import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/features/tasks/application/services/task_display_state_resolver.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/widget_bridge/application/widget_snapshot_builder.dart';
import 'package:screen_note/features/widget_bridge/domain/enums/widget_display_mode.dart';

/// 验证 Widget 快照生成规则。
void main() {
  final DateTime now = DateTime(2026, 5, 25, 10);

  test('list3 模式只保留前三条并按输入顺序写入 rank', () {
    final WidgetSnapshotBuilder builder = WidgetSnapshotBuilder(
      displayStateResolver: TaskDisplayStateResolver(),
      textResolver: _FakeWidgetSnapshotTextResolver(),
      now: () => now,
      snapshotIdGenerator: () => 'snapshot-1',
    );

    final snapshot = builder.build(
      sortedTasks: <Task>[
        _task(id: '1', title: '置顶事项', createdAt: now, isPinned: true),
        _task(
          id: '2',
          title: '今天到期',
          createdAt: now.subtract(const Duration(minutes: 1)),
          dueAt: DateTime(2026, 5, 25, 18),
        ),
        _task(
          id: '3',
          title: '普通事项',
          createdAt: now.subtract(const Duration(minutes: 2)),
        ),
        _task(
          id: '4',
          title: '第四条不应出现',
          createdAt: now.subtract(const Duration(minutes: 3)),
        ),
      ],
      displayMode: WidgetDisplayMode.list3,
    );

    expect(snapshot.displayMode, WidgetDisplayMode.list3);
    expect(snapshot.items.map((item) => item.title), <String>[
      '置顶事项',
      '今天到期',
      '普通事项',
    ]);
    expect(snapshot.items.map((item) => item.rank), <int>[1, 2, 3]);
    expect(snapshot.items.first.statusLabel, 'status:置顶');
    expect(snapshot.items[1].dueLabel, 'due:2026-05-25 18:00');
  });

  test('today 模式只展示今天到期事项，缺数据时回退为空模式', () {
    final WidgetSnapshotBuilder builder = WidgetSnapshotBuilder(
      displayStateResolver: TaskDisplayStateResolver(),
      textResolver: _FakeWidgetSnapshotTextResolver(),
      now: () => now,
      snapshotIdGenerator: () => 'snapshot-2',
    );

    final snapshot = builder.build(
      sortedTasks: <Task>[
        _task(
          id: '1',
          title: '今天到期',
          createdAt: now,
          dueAt: DateTime(2026, 5, 25, 16),
        ),
        _task(
          id: '2',
          title: '已经过期',
          createdAt: now,
          dueAt: DateTime(2026, 5, 24, 8),
        ),
      ],
      displayMode: WidgetDisplayMode.today,
    );

    expect(snapshot.displayMode, WidgetDisplayMode.today);
    expect(snapshot.items.map((item) => item.title), <String>['今天到期']);

    final emptySnapshot = builder.build(
      sortedTasks: <Task>[
        _task(
          id: '3',
          title: '没有今天到期',
          createdAt: now,
          dueAt: DateTime(2026, 5, 26, 8),
        ),
      ],
      displayMode: WidgetDisplayMode.today,
    );
    expect(emptySnapshot.displayMode, WidgetDisplayMode.empty);
    expect(emptySnapshot.items, isEmpty);
  });

  test('private 模式不泄露原始标题并标记隐私内容', () {
    final WidgetSnapshotBuilder builder = WidgetSnapshotBuilder(
      displayStateResolver: TaskDisplayStateResolver(),
      textResolver: _FakeWidgetSnapshotTextResolver(),
      now: () => now,
      snapshotIdGenerator: () => 'snapshot-3',
    );

    final snapshot = builder.build(
      sortedTasks: <Task>[
        _task(
          id: '1',
          title: '工资条密码 123456',
          createdAt: now,
          isPrivate: true,
        ),
        _task(
          id: '2',
          title: '普通事项',
          createdAt: now.subtract(const Duration(minutes: 1)),
        ),
      ],
      displayMode: WidgetDisplayMode.private,
    );

    expect(snapshot.displayMode, WidgetDisplayMode.private);
    expect(snapshot.hasPrivateContent, isTrue);
    expect(snapshot.items.single.title, '已隐藏 2 条事项');
    expect(snapshot.items.single.statusLabel, 'status:隐私');
    expect(
      snapshot.items.single.title.contains('工资条密码'),
      isFalse,
    );
  });
}

Task _task({
  required String id,
  required String title,
  required DateTime createdAt,
  DateTime? dueAt,
  bool isPinned = false,
  bool isPrivate = false,
}) {
  return Task(
    id: id,
    title: title,
    status: TaskStatus.active,
    dueAt: dueAt,
    isPinned: isPinned,
    isPrivate: isPrivate,
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}

class _FakeWidgetSnapshotTextResolver implements WidgetSnapshotTextResolver {
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
    switch (state) {
      case TaskDisplayState.overdue:
        return 'status:过期';
      case TaskDisplayState.today:
        return 'status:今天';
      case TaskDisplayState.privateMasked:
        return 'status:隐私';
      default:
        if (task.isPinned) {
          return 'status:置顶';
        }
        return 'status:正常';
    }
  }

  @override
  String dueLabelForTask(Task task) {
    final DateTime? dueAt = task.dueAt;
    if (dueAt == null) {
      return '';
    }
    final String hour = dueAt.hour.toString().padLeft(2, '0');
    final String minute = dueAt.minute.toString().padLeft(2, '0');
    return 'due:${dueAt.year}-${dueAt.month.toString().padLeft(2, '0')}-${dueAt.day.toString().padLeft(2, '0')} $hour:$minute';
  }
}
