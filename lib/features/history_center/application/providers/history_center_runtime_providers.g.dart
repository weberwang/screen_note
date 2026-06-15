// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_center_runtime_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 历史页快照用例 Provider，统一复用 task-flow 只读仓储，不单独引入新的历史真源。

@ProviderFor(loadHistoryCenterSnapshotUseCase)
const loadHistoryCenterSnapshotUseCaseProvider =
    LoadHistoryCenterSnapshotUseCaseProvider._();

/// 历史页快照用例 Provider，统一复用 task-flow 只读仓储，不单独引入新的历史真源。

final class LoadHistoryCenterSnapshotUseCaseProvider
    extends
        $FunctionalProvider<
          LoadHistorySnapshotUseCase,
          LoadHistorySnapshotUseCase,
          LoadHistorySnapshotUseCase
        >
    with $Provider<LoadHistorySnapshotUseCase> {
  /// 历史页快照用例 Provider，统一复用 task-flow 只读仓储，不单独引入新的历史真源。
  const LoadHistoryCenterSnapshotUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadHistoryCenterSnapshotUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadHistoryCenterSnapshotUseCaseHash();

  @$internal
  @override
  $ProviderElement<LoadHistorySnapshotUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoadHistorySnapshotUseCase create(Ref ref) {
    return loadHistoryCenterSnapshotUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadHistorySnapshotUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadHistorySnapshotUseCase>(value),
    );
  }
}

String _$loadHistoryCenterSnapshotUseCaseHash() =>
    r'0103f17e21949514868e3c918fd3c92d47b30c40';

/// 历史页基础快照 Provider，保留独立的读取入口，避免页面直接耦合仓储查询细节。

@ProviderFor(historyCenterSnapshot)
const historyCenterSnapshotProvider = HistoryCenterSnapshotProvider._();

/// 历史页基础快照 Provider，保留独立的读取入口，避免页面直接耦合仓储查询细节。

final class HistoryCenterSnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<HistorySnapshot>,
          HistorySnapshot,
          FutureOr<HistorySnapshot>
        >
    with $FutureModifier<HistorySnapshot>, $FutureProvider<HistorySnapshot> {
  /// 历史页基础快照 Provider，保留独立的读取入口，避免页面直接耦合仓储查询细节。
  const HistoryCenterSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyCenterSnapshotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyCenterSnapshotHash();

  @$internal
  @override
  $FutureProviderElement<HistorySnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HistorySnapshot> create(Ref ref) {
    return historyCenterSnapshot(ref);
  }
}

String _$historyCenterSnapshotHash() =>
    r'bb77c25415a54f59a8e995aeb11fff6c71bb2768';

/// 历史页控制器统一承接刷新与恢复链路，避免页面直接编排跨模块状态。

@ProviderFor(HistoryCenterController)
const historyCenterControllerProvider = HistoryCenterControllerProvider._();

/// 历史页控制器统一承接刷新与恢复链路，避免页面直接编排跨模块状态。
final class HistoryCenterControllerProvider
    extends $AsyncNotifierProvider<HistoryCenterController, HistorySnapshot> {
  /// 历史页控制器统一承接刷新与恢复链路，避免页面直接编排跨模块状态。
  const HistoryCenterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyCenterControllerProvider',
        isAutoDispose: false,
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
    r'74d8fa3fe46440bc0065829fda18a7c62d29e6c7';

/// 历史页控制器统一承接刷新与恢复链路，避免页面直接编排跨模块状态。

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
