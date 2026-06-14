// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_bridge_runtime_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Widget 自动同步协调器 Provider，统一复用任务真源、设置偏好与共享存储。

@ProviderFor(widgetSnapshotAutoSyncCoordinator)
const widgetSnapshotAutoSyncCoordinatorProvider =
    WidgetSnapshotAutoSyncCoordinatorProvider._();

/// Widget 自动同步协调器 Provider，统一复用任务真源、设置偏好与共享存储。

final class WidgetSnapshotAutoSyncCoordinatorProvider
    extends
        $FunctionalProvider<
          WidgetSnapshotAutoSyncCoordinator,
          WidgetSnapshotAutoSyncCoordinator,
          WidgetSnapshotAutoSyncCoordinator
        >
    with $Provider<WidgetSnapshotAutoSyncCoordinator> {
  /// Widget 自动同步协调器 Provider，统一复用任务真源、设置偏好与共享存储。
  const WidgetSnapshotAutoSyncCoordinatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetSnapshotAutoSyncCoordinatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$widgetSnapshotAutoSyncCoordinatorHash();

  @$internal
  @override
  $ProviderElement<WidgetSnapshotAutoSyncCoordinator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WidgetSnapshotAutoSyncCoordinator create(Ref ref) {
    return widgetSnapshotAutoSyncCoordinator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WidgetSnapshotAutoSyncCoordinator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WidgetSnapshotAutoSyncCoordinator>(
        value,
      ),
    );
  }
}

String _$widgetSnapshotAutoSyncCoordinatorHash() =>
    r'45831392e1460e5be109fd7ef80e22c1bc97a6c3';

/// Widget 快照同步服务 Provider，供后续手动同步或诊断入口统一复用。

@ProviderFor(widgetSnapshotSyncService)
const widgetSnapshotSyncServiceProvider = WidgetSnapshotSyncServiceProvider._();

/// Widget 快照同步服务 Provider，供后续手动同步或诊断入口统一复用。

final class WidgetSnapshotSyncServiceProvider
    extends
        $FunctionalProvider<
          WidgetSnapshotSyncService,
          WidgetSnapshotSyncService,
          WidgetSnapshotSyncService
        >
    with $Provider<WidgetSnapshotSyncService> {
  /// Widget 快照同步服务 Provider，供后续手动同步或诊断入口统一复用。
  const WidgetSnapshotSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetSnapshotSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetSnapshotSyncServiceHash();

  @$internal
  @override
  $ProviderElement<WidgetSnapshotSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WidgetSnapshotSyncService create(Ref ref) {
    return widgetSnapshotSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WidgetSnapshotSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WidgetSnapshotSyncService>(value),
    );
  }
}

String _$widgetSnapshotSyncServiceHash() =>
    r'15195326c0de73c89547d338a43263dbaa8ddd4f';
