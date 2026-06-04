import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_flow_bootstrap_snapshot.dart';

part 'task_flow_bootstrap_provider.g.dart';

/// 提供事项主流程初始化快照，供首页骨架展示模块 readiness。
@riverpod
TaskFlowBootstrapSnapshot taskFlowBootstrapSnapshot(Ref ref) {
  return const TaskFlowBootstrapSnapshot(
    activePreviewCount: 3,
    completedPreviewCount: 2,
    deletedPreviewCount: 1,
    widgetProjectionReady: true,
    privacySafeByDefault: true,
  );
}
