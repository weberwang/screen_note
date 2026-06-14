// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_snapshot_shared_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Widget 快照存储 Provider，统一暴露真实平台实现与测试替换入口。

@ProviderFor(widgetSnapshotStore)
const widgetSnapshotStoreProvider = WidgetSnapshotStoreProvider._();

/// Widget 快照存储 Provider，统一暴露真实平台实现与测试替换入口。

final class WidgetSnapshotStoreProvider
    extends
        $FunctionalProvider<
          WidgetSnapshotStore,
          WidgetSnapshotStore,
          WidgetSnapshotStore
        >
    with $Provider<WidgetSnapshotStore> {
  /// Widget 快照存储 Provider，统一暴露真实平台实现与测试替换入口。
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
    r'450947652c8a9af78b5dcd29a8d8b429c3a75474';

/// Widget 快照投影器 Provider。

@ProviderFor(widgetSnapshotProjector)
const widgetSnapshotProjectorProvider = WidgetSnapshotProjectorProvider._();

/// Widget 快照投影器 Provider。

final class WidgetSnapshotProjectorProvider
    extends
        $FunctionalProvider<
          WidgetSnapshotProjector,
          WidgetSnapshotProjector,
          WidgetSnapshotProjector
        >
    with $Provider<WidgetSnapshotProjector> {
  /// Widget 快照投影器 Provider。
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
