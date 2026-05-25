import '../../tasks/application/services/task_display_state_resolver.dart';
import '../../tasks/domain/entities/task.dart';
import '../domain/enums/widget_display_mode.dart';
import '../domain/models/widget_snapshot.dart';
import '../domain/models/widget_snapshot_item.dart';

/// Widget 快照文案解析器。
///
/// 共享快照要被 Flutter 预览与 iOS Widget 共同消费，因此这里通过接口注入
/// 文案与时间格式，避免快照生成器直接绑死某个展示层实现。
abstract interface class WidgetSnapshotTextResolver {
  /// 生成状态标签文案。
  String statusLabelForTask(Task task, {required TaskDisplayState state});

  /// 生成截止时间文案。
  String dueLabelForTask(Task task);

  /// 生成隐私模式聚合文案。
  String privateSummary({required int itemCount});

  /// 生成空态标题。
  String emptyTitle();

  /// 生成 fallback 提示文案。
  String fallbackHint();
}

/// Widget 快照生成器。
///
/// 这里严格消费已经排好序的事项列表，只负责按模式切片、做隐私脱敏、
/// 生成稳定快照，不再重复排序逻辑。
final class WidgetSnapshotBuilder {
  /// 创建 Widget 快照生成器。
  WidgetSnapshotBuilder({
    required TaskDisplayStateResolver displayStateResolver,
    required WidgetSnapshotTextResolver textResolver,
    required DateTime Function() now,
    required String Function() snapshotIdGenerator,
    this.snapshotVersion = 1,
  }) : _displayStateResolver = displayStateResolver,
       _textResolver = textResolver,
       _now = now,
       _snapshotIdGenerator = snapshotIdGenerator;

  final TaskDisplayStateResolver _displayStateResolver;
  final WidgetSnapshotTextResolver _textResolver;
  final DateTime Function() _now;
  final String Function() _snapshotIdGenerator;
  final int snapshotVersion;

  /// 按指定模式构建共享快照。
  WidgetSnapshot build({
    required List<Task> sortedTasks,
    required WidgetDisplayMode displayMode,
  }) {
    if (displayMode == WidgetDisplayMode.empty) {
      return buildEmptySnapshot();
    }

    final List<Task> activeTasks = sortedTasks
        .where((Task task) => task.status == TaskStatus.active)
        .toList(growable: false);
    final bool hasPrivateContent = activeTasks.any((Task task) => task.isPrivate);

    if (displayMode == WidgetDisplayMode.private) {
      return _buildPrivateSnapshot(
        tasks: activeTasks,
        hasPrivateContent: hasPrivateContent,
      );
    }

    final List<Task> selectedTasks = switch (displayMode) {
      WidgetDisplayMode.single => activeTasks.take(1).toList(growable: false),
      WidgetDisplayMode.list3 => activeTasks.take(3).toList(growable: false),
      WidgetDisplayMode.today => activeTasks
          .where((Task task) => _displayStateResolver.isDueToday(task, now: _now()))
          .take(3)
          .toList(growable: false),
      WidgetDisplayMode.private || WidgetDisplayMode.empty => const <Task>[],
    };

    if (selectedTasks.isEmpty) {
      return buildEmptySnapshot(hasPrivateContent: hasPrivateContent);
    }

    return WidgetSnapshot(
      snapshotId: _snapshotIdGenerator(),
      generatedAt: _now(),
      displayMode: displayMode,
      items: _buildItems(selectedTasks),
      hasPrivateContent: hasPrivateContent,
      version: snapshotVersion,
    );
  }

  /// 构建无内容空态快照。
  WidgetSnapshot buildEmptySnapshot({
    bool hasFallbackContent = false,
    bool hasPrivateContent = false,
  }) {
    return WidgetSnapshot(
      snapshotId: _snapshotIdGenerator(),
      generatedAt: _now(),
      displayMode: WidgetDisplayMode.empty,
      items: const <WidgetSnapshotItem>[],
      hasPrivateContent: hasPrivateContent,
      hasFallbackContent: hasFallbackContent,
      version: snapshotVersion,
    );
  }

  /// 为降级兜底标记 fallback 元数据。
  WidgetSnapshot markAsFallback(WidgetSnapshot snapshot) {
    return snapshot.copyWith(
      snapshotId: _snapshotIdGenerator(),
      generatedAt: _now(),
      hasFallbackContent: true,
    );
  }

  WidgetSnapshot _buildPrivateSnapshot({
    required List<Task> tasks,
    required bool hasPrivateContent,
  }) {
    if (tasks.isEmpty) {
      return buildEmptySnapshot(hasPrivateContent: hasPrivateContent);
    }

    return WidgetSnapshot(
      snapshotId: _snapshotIdGenerator(),
      generatedAt: _now(),
      displayMode: WidgetDisplayMode.private,
      items: <WidgetSnapshotItem>[
        WidgetSnapshotItem(
          title: _textResolver.privateSummary(itemCount: tasks.length),
          statusLabel: _textResolver.statusLabelForTask(
            tasks.first,
            state: TaskDisplayState.privateMasked,
          ),
          dueLabel: '',
          isPinned: false,
          isOverdue: false,
          isPrivate: true,
          rank: 1,
        ),
      ],
      hasPrivateContent: hasPrivateContent,
      version: snapshotVersion,
    );
  }

  List<WidgetSnapshotItem> _buildItems(List<Task> tasks) {
    return List<WidgetSnapshotItem>.generate(tasks.length, (int index) {
      final Task task = tasks[index];
      final TaskDisplayState state = task.isPrivate
          ? TaskDisplayState.privateMasked
          : _displayStateResolver.resolve(task, now: _now());

      // 隐私事项在任何 Widget 模式下都不能泄露标题和时间，只保留安全摘要。
      if (task.isPrivate) {
        return WidgetSnapshotItem(
          title: _textResolver.privateSummary(itemCount: 1),
          statusLabel: _textResolver.statusLabelForTask(task, state: state),
          dueLabel: '',
          isPinned: false,
          isOverdue: false,
          isPrivate: true,
          rank: index + 1,
        );
      }

      return WidgetSnapshotItem(
        title: task.title,
        statusLabel: _textResolver.statusLabelForTask(task, state: state),
        dueLabel: _textResolver.dueLabelForTask(task),
        isPinned: task.isPinned,
        isOverdue: state == TaskDisplayState.overdue,
        isPrivate: false,
        rank: index + 1,
      );
    }, growable: false);
  }
}
