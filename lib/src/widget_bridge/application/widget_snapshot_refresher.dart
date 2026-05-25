/// 小组件快照刷新接口。
///
/// 阶段一先把刷新触发位点固定在应用层，真实 Widget 与原生桥接放到后续阶段接入。
abstract interface class WidgetSnapshotRefresher {
  /// 触发一次快照刷新。
  Future<void> refresh();
}

/// 阶段一默认使用的空刷新实现。
final class NoopWidgetSnapshotRefresher implements WidgetSnapshotRefresher {
  /// 创建空刷新器。
  const NoopWidgetSnapshotRefresher();

  @override
  Future<void> refresh() async {}
}
