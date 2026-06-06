// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_snapshot_shared_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 小组件快照存储提供器，统一复用真实平台实现与测试替换入口。

@ProviderFor(widgetSnapshotStore)
const widgetSnapshotStoreProvider = WidgetSnapshotStoreProvider._();

/// 小组件快照存储提供器，统一复用真实平台实现与测试替换入口。

final class WidgetSnapshotStoreProvider
    extends
        $FunctionalProvider<
          WidgetSnapshotStore,
          WidgetSnapshotStore,
          WidgetSnapshotStore
        >
    with $Provider<WidgetSnapshotStore> {
  /// 小组件快照存储提供器，统一复用真实平台实现与测试替换入口。
  const WidgetSnapshotStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetSnapshotStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetSnapshotStoreHash();

  @$internal
  @override
  $ProviderElement<WidgetSnapshotStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WidgetSnapshotStore create(Ref ref) {
    return widgetSnapshotStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WidgetSnapshotStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WidgetSnapshotStore>(value),
    );
  }
}

String _$widgetSnapshotStoreHash() =>
    r'a7c16f10dddbfeae18302dbb5f21b7c87da0eef6';

/// 小组件快照投影器提供器。

@ProviderFor(widgetSnapshotProjector)
const widgetSnapshotProjectorProvider = WidgetSnapshotProjectorProvider._();

/// 小组件快照投影器提供器。

final class WidgetSnapshotProjectorProvider
    extends
        $FunctionalProvider<
          WidgetSnapshotProjector,
          WidgetSnapshotProjector,
          WidgetSnapshotProjector
        >
    with $Provider<WidgetSnapshotProjector> {
  /// 小组件快照投影器提供器。
  const WidgetSnapshotProjectorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetSnapshotProjectorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetSnapshotProjectorHash();

  @$internal
  @override
  $ProviderElement<WidgetSnapshotProjector> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WidgetSnapshotProjector create(Ref ref) {
    return widgetSnapshotProjector(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WidgetSnapshotProjector value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WidgetSnapshotProjector>(value),
    );
  }
}

String _$widgetSnapshotProjectorHash() =>
    r'd4d5f985536c1132c6de360f15f28d934499d4ae';
