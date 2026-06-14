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
          LoadHistoryCenterSnapshotUseCase,
          LoadHistoryCenterSnapshotUseCase,
          LoadHistoryCenterSnapshotUseCase
        >
    with $Provider<LoadHistoryCenterSnapshotUseCase> {
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
  $ProviderElement<LoadHistoryCenterSnapshotUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoadHistoryCenterSnapshotUseCase create(Ref ref) {
    return loadHistoryCenterSnapshotUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadHistoryCenterSnapshotUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadHistoryCenterSnapshotUseCase>(
        value,
      ),
    );
  }
}

String _$loadHistoryCenterSnapshotUseCaseHash() =>
    r'd5136a84f5af3396f54a917d47b8fee3b6d45ace';

/// 历史页基础快照 Provider，保留独立的读取入口，避免页面直接耦合仓储查询细节。

@ProviderFor(historyCenterSnapshot)
const historyCenterSnapshotProvider = HistoryCenterSnapshotProvider._();

/// 历史页基础快照 Provider，保留独立的读取入口，避免页面直接耦合仓储查询细节。

final class HistoryCenterSnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<HistoryCenterSnapshot>,
          HistoryCenterSnapshot,
          FutureOr<HistoryCenterSnapshot>
        >
    with
        $FutureModifier<HistoryCenterSnapshot>,
        $FutureProvider<HistoryCenterSnapshot> {
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
  $FutureProviderElement<HistoryCenterSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HistoryCenterSnapshot> create(Ref ref) {
    return historyCenterSnapshot(ref);
  }
}

String _$historyCenterSnapshotHash() =>
    r'2b745b8b2e147e5e52c2bc05871ad59bc5122113';

/// 历史页控制器统一承接刷新与恢复链路，避免页面直接编排跨模块状态。

@ProviderFor(HistoryCenterController)
const historyCenterControllerProvider = HistoryCenterControllerProvider._();

/// 历史页控制器统一承接刷新与恢复链路，避免页面直接编排跨模块状态。
final class HistoryCenterControllerProvider
    extends
        $AsyncNotifierProvider<HistoryCenterController, HistoryCenterSnapshot> {
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
    r'04dd0fbae0ef8a5e66ae74a78b05a3720217418a';

/// 历史页控制器统一承接刷新与恢复链路，避免页面直接编排跨模块状态。

abstract class _$HistoryCenterController
    extends $AsyncNotifier<HistoryCenterSnapshot> {
  FutureOr<HistoryCenterSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<HistoryCenterSnapshot>, HistoryCenterSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<HistoryCenterSnapshot>,
                HistoryCenterSnapshot
              >,
              AsyncValue<HistoryCenterSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
