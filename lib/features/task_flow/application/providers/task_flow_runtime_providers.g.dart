// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_flow_runtime_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 运行时数据库 Provider，统一复用 `TaskFlowDatabase` 真源入口，避免页面层直接感知连接细节。

@ProviderFor(taskFlowDatabase)
const taskFlowDatabaseProvider = TaskFlowDatabaseProvider._();

/// 运行时数据库 Provider，统一复用 `TaskFlowDatabase` 真源入口，避免页面层直接感知连接细节。

final class TaskFlowDatabaseProvider
    extends
        $FunctionalProvider<
          TaskFlowDatabase,
          TaskFlowDatabase,
          TaskFlowDatabase
        >
    with $Provider<TaskFlowDatabase> {
  /// 运行时数据库 Provider，统一复用 `TaskFlowDatabase` 真源入口，避免页面层直接感知连接细节。
  const TaskFlowDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFlowDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskFlowDatabaseHash();

  @$internal
  @override
  $ProviderElement<TaskFlowDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskFlowDatabase create(Ref ref) {
    return taskFlowDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskFlowDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskFlowDatabase>(value),
    );
  }
}

String _$taskFlowDatabaseHash() => r'e5f431fe3632b351f14037102a540a2cbf1d32fc';

/// 任务写仓储 Provider，显式暴露变更契约，避免在写用例装配时做向下转型。

@ProviderFor(taskFlowMutationRepository)
const taskFlowMutationRepositoryProvider =
    TaskFlowMutationRepositoryProvider._();

/// 任务写仓储 Provider，显式暴露变更契约，避免在写用例装配时做向下转型。

final class TaskFlowMutationRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  /// 任务写仓储 Provider，显式暴露变更契约，避免在写用例装配时做向下转型。
  const TaskFlowMutationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFlowMutationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskFlowMutationRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskFlowMutationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskFlowMutationRepositoryHash() =>
    r'70a76123a597ac31c5428ab05bd1622a08572ed4';

/// 任务只读仓储 Provider，首页和查询用例只依赖读契约，不接触写能力细节。

@ProviderFor(taskFlowRepository)
const taskFlowRepositoryProvider = TaskFlowRepositoryProvider._();

/// 任务只读仓储 Provider，首页和查询用例只依赖读契约，不接触写能力细节。

final class TaskFlowRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  /// 任务只读仓储 Provider，首页和查询用例只依赖读契约，不接触写能力细节。
  const TaskFlowRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFlowRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskFlowRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskFlowRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskFlowRepositoryHash() =>
    r'75167c4855a9d6748640cd31239a97b0becd38b4';

/// 默认副作用端口 Provider，当前先降级到 no-op，后续通知、Widget 等能力都从这里替换接线。

@ProviderFor(defaultTaskFlowSideEffectPort)
const defaultTaskFlowSideEffectPortProvider =
    DefaultTaskFlowSideEffectPortProvider._();

/// 默认副作用端口 Provider，当前先降级到 no-op，后续通知、Widget 等能力都从这里替换接线。

final class DefaultTaskFlowSideEffectPortProvider
    extends
        $FunctionalProvider<
          TaskFlowSideEffectPort,
          TaskFlowSideEffectPort,
          TaskFlowSideEffectPort
        >
    with $Provider<TaskFlowSideEffectPort> {
  /// 默认副作用端口 Provider，当前先降级到 no-op，后续通知、Widget 等能力都从这里替换接线。
  const DefaultTaskFlowSideEffectPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultTaskFlowSideEffectPortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultTaskFlowSideEffectPortHash();

  @$internal
  @override
  $ProviderElement<TaskFlowSideEffectPort> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskFlowSideEffectPort create(Ref ref) {
    return defaultTaskFlowSideEffectPort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskFlowSideEffectPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskFlowSideEffectPort>(value),
    );
  }
}

String _$defaultTaskFlowSideEffectPortHash() =>
    r'cd1993c07eddfaef480f10d32e6dddb1f9f19f75';

/// 任务流副作用装配点，默认复用降级实现，但保留清晰可替换入口以满足后续能力接入。

@ProviderFor(taskFlowSideEffectPort)
const taskFlowSideEffectPortProvider = TaskFlowSideEffectPortProvider._();

/// 任务流副作用装配点，默认复用降级实现，但保留清晰可替换入口以满足后续能力接入。

final class TaskFlowSideEffectPortProvider
    extends
        $FunctionalProvider<
          TaskFlowSideEffectPort,
          TaskFlowSideEffectPort,
          TaskFlowSideEffectPort
        >
    with $Provider<TaskFlowSideEffectPort> {
  /// 任务流副作用装配点，默认复用降级实现，但保留清晰可替换入口以满足后续能力接入。
  const TaskFlowSideEffectPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFlowSideEffectPortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskFlowSideEffectPortHash();

  @$internal
  @override
  $ProviderElement<TaskFlowSideEffectPort> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskFlowSideEffectPort create(Ref ref) {
    return taskFlowSideEffectPort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskFlowSideEffectPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskFlowSideEffectPort>(value),
    );
  }
}

String _$taskFlowSideEffectPortHash() =>
    r'8028b9ab5508a56528e87a8b77f0e3885b17d33f';

/// 创建事项用例 Provider，供后续编辑页或快捷入口直接读取，不把构造细节散落到展示层。

@ProviderFor(createTaskUseCase)
const createTaskUseCaseProvider = CreateTaskUseCaseProvider._();

/// 创建事项用例 Provider，供后续编辑页或快捷入口直接读取，不把构造细节散落到展示层。

final class CreateTaskUseCaseProvider
    extends
        $FunctionalProvider<
          CreateTaskUseCase,
          CreateTaskUseCase,
          CreateTaskUseCase
        >
    with $Provider<CreateTaskUseCase> {
  /// 创建事项用例 Provider，供后续编辑页或快捷入口直接读取，不把构造细节散落到展示层。
  const CreateTaskUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createTaskUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createTaskUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateTaskUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateTaskUseCase create(Ref ref) {
    return createTaskUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateTaskUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateTaskUseCase>(value),
    );
  }
}

String _$createTaskUseCaseHash() => r'4d801a03bae24268958130c28f857345b8434ab3';

/// 首页快照用例 Provider，统一封装任务分组与优先级选择规则。

@ProviderFor(loadTaskFeedUseCase)
const loadTaskFeedUseCaseProvider = LoadTaskFeedUseCaseProvider._();

/// 首页快照用例 Provider，统一封装任务分组与优先级选择规则。

final class LoadTaskFeedUseCaseProvider
    extends
        $FunctionalProvider<
          LoadTaskFeedUseCase,
          LoadTaskFeedUseCase,
          LoadTaskFeedUseCase
        >
    with $Provider<LoadTaskFeedUseCase> {
  /// 首页快照用例 Provider，统一封装任务分组与优先级选择规则。
  const LoadTaskFeedUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadTaskFeedUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadTaskFeedUseCaseHash();

  @$internal
  @override
  $ProviderElement<LoadTaskFeedUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoadTaskFeedUseCase create(Ref ref) {
    return loadTaskFeedUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadTaskFeedUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadTaskFeedUseCase>(value),
    );
  }
}

String _$loadTaskFeedUseCaseHash() =>
    r'05f75827c90189916a0bdca88e0d5b57753782cf';

/// 单事项读取 Provider，供编辑页按身份读取既有任务并预填，避免页面层直接碰仓储。

@ProviderFor(taskFlowTaskById)
const taskFlowTaskByIdProvider = TaskFlowTaskByIdFamily._();

/// 单事项读取 Provider，供编辑页按身份读取既有任务并预填，避免页面层直接碰仓储。

final class TaskFlowTaskByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<TaskEntity?>,
          TaskEntity?,
          FutureOr<TaskEntity?>
        >
    with $FutureModifier<TaskEntity?>, $FutureProvider<TaskEntity?> {
  /// 单事项读取 Provider，供编辑页按身份读取既有任务并预填，避免页面层直接碰仓储。
  const TaskFlowTaskByIdProvider._({
    required TaskFlowTaskByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskFlowTaskByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskFlowTaskByIdHash();

  @override
  String toString() {
    return r'taskFlowTaskByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TaskEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TaskEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return taskFlowTaskById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskFlowTaskByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskFlowTaskByIdHash() => r'b9107b3f2a47510daf971b6359dd0d3295021dff';

/// 单事项读取 Provider，供编辑页按身份读取既有任务并预填，避免页面层直接碰仓储。

final class TaskFlowTaskByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TaskEntity?>, String> {
  const TaskFlowTaskByIdFamily._()
    : super(
        retry: null,
        name: r'taskFlowTaskByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 单事项读取 Provider，供编辑页按身份读取既有任务并预填，避免页面层直接碰仓储。

  TaskFlowTaskByIdProvider call(String taskId) =>
      TaskFlowTaskByIdProvider._(argument: taskId, from: this);

  @override
  String toString() => r'taskFlowTaskByIdProvider';
}

/// 更新事项用例 Provider，统一承接编辑态保存，不允许页面层误走新建链路。

@ProviderFor(updateTaskUseCase)
const updateTaskUseCaseProvider = UpdateTaskUseCaseProvider._();

/// 更新事项用例 Provider，统一承接编辑态保存，不允许页面层误走新建链路。

final class UpdateTaskUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateTaskUseCase,
          UpdateTaskUseCase,
          UpdateTaskUseCase
        >
    with $Provider<UpdateTaskUseCase> {
  /// 更新事项用例 Provider，统一承接编辑态保存，不允许页面层误走新建链路。
  const UpdateTaskUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateTaskUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateTaskUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateTaskUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateTaskUseCase create(Ref ref) {
    return updateTaskUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateTaskUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateTaskUseCase>(value),
    );
  }
}

String _$updateTaskUseCaseHash() => r'3207f048c89fed8e21842eaa37a1214fbe18e580';

/// 状态流转用例 Provider，供后续页面直接读取，保持状态写入仍通过应用层编排。

@ProviderFor(updateTaskStatusUseCase)
const updateTaskStatusUseCaseProvider = UpdateTaskStatusUseCaseProvider._();

/// 状态流转用例 Provider，供后续页面直接读取，保持状态写入仍通过应用层编排。

final class UpdateTaskStatusUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateTaskStatusUseCase,
          UpdateTaskStatusUseCase,
          UpdateTaskStatusUseCase
        >
    with $Provider<UpdateTaskStatusUseCase> {
  /// 状态流转用例 Provider，供后续页面直接读取，保持状态写入仍通过应用层编排。
  const UpdateTaskStatusUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateTaskStatusUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateTaskStatusUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateTaskStatusUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateTaskStatusUseCase create(Ref ref) {
    return updateTaskStatusUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateTaskStatusUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateTaskStatusUseCase>(value),
    );
  }
}

String _$updateTaskStatusUseCaseHash() =>
    r'b288d680009210887c713108b6d5e5e8bed4d808';

/// 首页基础快照 Provider，保留 Task 2 的最小快照读取入口，供 controller 或其他轻量读取复用。

@ProviderFor(taskFlowHomeSnapshot)
const taskFlowHomeSnapshotProvider = TaskFlowHomeSnapshotProvider._();

/// 首页基础快照 Provider，保留 Task 2 的最小快照读取入口，供 controller 或其他轻量读取复用。

final class TaskFlowHomeSnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<TaskFeedSnapshot>,
          TaskFeedSnapshot,
          FutureOr<TaskFeedSnapshot>
        >
    with $FutureModifier<TaskFeedSnapshot>, $FutureProvider<TaskFeedSnapshot> {
  /// 首页基础快照 Provider，保留 Task 2 的最小快照读取入口，供 controller 或其他轻量读取复用。
  const TaskFlowHomeSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFlowHomeSnapshotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskFlowHomeSnapshotHash();

  @$internal
  @override
  $FutureProviderElement<TaskFeedSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TaskFeedSnapshot> create(Ref ref) {
    return taskFlowHomeSnapshot(ref);
  }
}

String _$taskFlowHomeSnapshotHash() =>
    r'f70759a38ca3fef193792c630afd8f4443884753';

/// 首页控制器统一承接快照刷新与后续写后刷新入口，避免页面直接操心失效策略。

@ProviderFor(TaskFlowHomeController)
const taskFlowHomeControllerProvider = TaskFlowHomeControllerProvider._();

/// 首页控制器统一承接快照刷新与后续写后刷新入口，避免页面直接操心失效策略。
final class TaskFlowHomeControllerProvider
    extends $AsyncNotifierProvider<TaskFlowHomeController, TaskFeedSnapshot> {
  /// 首页控制器统一承接快照刷新与后续写后刷新入口，避免页面直接操心失效策略。
  const TaskFlowHomeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFlowHomeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskFlowHomeControllerHash();

  @$internal
  @override
  TaskFlowHomeController create() => TaskFlowHomeController();
}

String _$taskFlowHomeControllerHash() =>
    r'0e7af69adf0bcbb828244c67fa5e79301c059b08';

/// 首页控制器统一承接快照刷新与后续写后刷新入口，避免页面直接操心失效策略。

abstract class _$TaskFlowHomeController
    extends $AsyncNotifier<TaskFeedSnapshot> {
  FutureOr<TaskFeedSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<TaskFeedSnapshot>, TaskFeedSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TaskFeedSnapshot>, TaskFeedSnapshot>,
              AsyncValue<TaskFeedSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
