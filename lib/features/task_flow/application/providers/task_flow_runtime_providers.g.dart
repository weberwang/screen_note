// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_flow_runtime_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// task-flow 数据库提供器，统一托管持久层生命周期。

@ProviderFor(taskFlowDatabase)
const taskFlowDatabaseProvider = TaskFlowDatabaseProvider._();

/// task-flow 数据库提供器，统一托管持久层生命周期。

final class TaskFlowDatabaseProvider
    extends
        $FunctionalProvider<
          TaskFlowDatabase,
          TaskFlowDatabase,
          TaskFlowDatabase
        >
    with $Provider<TaskFlowDatabase> {
  /// task-flow 数据库提供器，统一托管持久层生命周期。
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

String _$taskFlowDatabaseHash() => r'4848cc9a973f0f6110ab37cf9dbadc09009cd072';

/// 事项仓储提供器，隔离页面层对 Drift 的直接依赖。

@ProviderFor(taskRepository)
const taskRepositoryProvider = TaskRepositoryProvider._();

/// 事项仓储提供器，隔离页面层对 Drift 的直接依赖。

final class TaskRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  /// 事项仓储提供器，隔离页面层对 Drift 的直接依赖。
  const TaskRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskRepositoryHash() => r'680779c01103e8a811af58e1ace84baabc2d1ae1';

/// 副作用端口提供器，当前先用空实现保住主链路，后续再接提醒与快照刷新。

@ProviderFor(taskFlowSideEffectPort)
const taskFlowSideEffectPortProvider = TaskFlowSideEffectPortProvider._();

/// 副作用端口提供器，当前先用空实现保住主链路，后续再接提醒与快照刷新。

final class TaskFlowSideEffectPortProvider
    extends
        $FunctionalProvider<
          TaskFlowSideEffectPort,
          TaskFlowSideEffectPort,
          TaskFlowSideEffectPort
        >
    with $Provider<TaskFlowSideEffectPort> {
  /// 副作用端口提供器，当前先用空实现保住主链路，后续再接提醒与快照刷新。
  const TaskFlowSideEffectPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFlowSideEffectPortProvider',
        isAutoDispose: true,
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
    r'f8085d4feae9c6e1140c1ad7efd0de8992ca4763';

/// 创建事项用例提供器。

@ProviderFor(createTaskUseCase)
const createTaskUseCaseProvider = CreateTaskUseCaseProvider._();

/// 创建事项用例提供器。

final class CreateTaskUseCaseProvider
    extends
        $FunctionalProvider<
          CreateTaskUseCase,
          CreateTaskUseCase,
          CreateTaskUseCase
        >
    with $Provider<CreateTaskUseCase> {
  /// 创建事项用例提供器。
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

String _$createTaskUseCaseHash() => r'a9cc5159f4e5b1e23207a6c1f6a10995159fe302';

/// 首页任务流读取用例提供器。

@ProviderFor(loadTaskFeedUseCase)
const loadTaskFeedUseCaseProvider = LoadTaskFeedUseCaseProvider._();

/// 首页任务流读取用例提供器。

final class LoadTaskFeedUseCaseProvider
    extends
        $FunctionalProvider<
          LoadTaskFeedUseCase,
          LoadTaskFeedUseCase,
          LoadTaskFeedUseCase
        >
    with $Provider<LoadTaskFeedUseCase> {
  /// 首页任务流读取用例提供器。
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
    r'd3c77deb76d18aa073ff1a06f3353b69c35e1b79';

/// 事项状态流转用例提供器。

@ProviderFor(updateTaskStatusUseCase)
const updateTaskStatusUseCaseProvider = UpdateTaskStatusUseCaseProvider._();

/// 事项状态流转用例提供器。

final class UpdateTaskStatusUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateTaskStatusUseCase,
          UpdateTaskStatusUseCase,
          UpdateTaskStatusUseCase
        >
    with $Provider<UpdateTaskStatusUseCase> {
  /// 事项状态流转用例提供器。
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
    r'eef24e42b1ad2842770973ea1e75eb3b682bf4a7';

/// 首页任务流控制器，统一收口首页读取与快速状态变更。

@ProviderFor(TaskFlowHomeController)
const taskFlowHomeControllerProvider = TaskFlowHomeControllerProvider._();

/// 首页任务流控制器，统一收口首页读取与快速状态变更。
final class TaskFlowHomeControllerProvider
    extends $AsyncNotifierProvider<TaskFlowHomeController, TaskFeedSnapshot> {
  /// 首页任务流控制器，统一收口首页读取与快速状态变更。
  const TaskFlowHomeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFlowHomeControllerProvider',
        isAutoDispose: true,
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
    r'641d667c0aba04069eb4f06d78f1fe813474e7fc';

/// 首页任务流控制器，统一收口首页读取与快速状态变更。

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
