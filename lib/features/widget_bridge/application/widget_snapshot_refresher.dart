import 'widget_refresh_result.dart';

/// 小组件快照刷新接口。
///
/// 阶段三开始由应用层统一承接刷新编排，调用方只关心“触发一次刷新”，
/// 不直接处理底层共享存储、原生刷新或 fallback 细节。
abstract interface class WidgetSnapshotRefresher {
  /// 触发一次快照刷新。
  Future<WidgetRefreshResult> refresh();
}

/// 默认空刷新实现。
///
/// 测试或未接通原生能力时仍返回成功，保证调用方不必在页面和用例里做额外分支。
final class NoopWidgetSnapshotRefresher implements WidgetSnapshotRefresher {
  /// 创建空刷新器。
  const NoopWidgetSnapshotRefresher();

  @override
  Future<WidgetRefreshResult> refresh() async {
    return WidgetRefreshResult.success;
  }
}
