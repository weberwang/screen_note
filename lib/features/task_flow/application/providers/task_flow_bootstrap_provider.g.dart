// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_flow_bootstrap_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 提供事项主流程初始化快照，供首页骨架展示模块 readiness。

@ProviderFor(taskFlowBootstrapSnapshot)
const taskFlowBootstrapSnapshotProvider = TaskFlowBootstrapSnapshotProvider._();

/// 提供事项主流程初始化快照，供首页骨架展示模块 readiness。

final class TaskFlowBootstrapSnapshotProvider
    extends
        $FunctionalProvider<
          TaskFlowBootstrapSnapshot,
          TaskFlowBootstrapSnapshot,
          TaskFlowBootstrapSnapshot
        >
    with $Provider<TaskFlowBootstrapSnapshot> {
  /// 提供事项主流程初始化快照，供首页骨架展示模块 readiness。
  const TaskFlowBootstrapSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFlowBootstrapSnapshotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskFlowBootstrapSnapshotHash();

  @$internal
  @override
  $ProviderElement<TaskFlowBootstrapSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskFlowBootstrapSnapshot create(Ref ref) {
    return taskFlowBootstrapSnapshot(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskFlowBootstrapSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskFlowBootstrapSnapshot>(value),
    );
  }
}

String _$taskFlowBootstrapSnapshotHash() =>
    r'f1abde1cfb7fc1c84090edaa4c8b8133cb18abf9';
