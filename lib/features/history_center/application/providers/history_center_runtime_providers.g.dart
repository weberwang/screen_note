// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_center_runtime_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 历史中心读取用例提供器，复用 task-flow 仓储避免重复维护数据边界。

@ProviderFor(loadHistorySnapshotUseCase)
const loadHistorySnapshotUseCaseProvider =
    LoadHistorySnapshotUseCaseProvider._();

/// 历史中心读取用例提供器，复用 task-flow 仓储避免重复维护数据边界。

final class LoadHistorySnapshotUseCaseProvider
    extends
        $FunctionalProvider<
          LoadHistorySnapshotUseCase,
          LoadHistorySnapshotUseCase,
          LoadHistorySnapshotUseCase
        >
    with $Provider<LoadHistorySnapshotUseCase> {
  /// 历史中心读取用例提供器，复用 task-flow 仓储避免重复维护数据边界。
  const LoadHistorySnapshotUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadHistorySnapshotUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadHistorySnapshotUseCaseHash();

  @$internal
  @override
  $ProviderElement<LoadHistorySnapshotUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoadHistorySnapshotUseCase create(Ref ref) {
    return loadHistorySnapshotUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadHistorySnapshotUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadHistorySnapshotUseCase>(value),
    );
  }
}

String _$loadHistorySnapshotUseCaseHash() =>
    r'e7a9a672569ee2ccb2affbda9a63f765e6d212aa';

/// 历史中心控制器，统一收口历史读取、恢复和跨页快照刷新。

@ProviderFor(HistoryCenterController)
const historyCenterControllerProvider = HistoryCenterControllerProvider._();

/// 历史中心控制器，统一收口历史读取、恢复和跨页快照刷新。
final class HistoryCenterControllerProvider
    extends $AsyncNotifierProvider<HistoryCenterController, HistorySnapshot> {
  /// 历史中心控制器，统一收口历史读取、恢复和跨页快照刷新。
  const HistoryCenterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyCenterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyCenterControllerHash();

  @$internal
  @override
  HistoryCenterController create() => HistoryCenterController();
}

String _$historyCenterControllerHash() =>
    r'e65a8bf31ef70ae090cfb3a2af9a0eb5520b97aa';

/// 历史中心控制器，统一收口历史读取、恢复和跨页快照刷新。

abstract class _$HistoryCenterController
    extends $AsyncNotifier<HistorySnapshot> {
  FutureOr<HistorySnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<HistorySnapshot>, HistorySnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HistorySnapshot>, HistorySnapshot>,
              AsyncValue<HistorySnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
