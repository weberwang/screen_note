// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_bridge_runtime_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 小组件快照同步服务提供器，统一复用任务事实源、设置偏好和共享存储。

@ProviderFor(widgetSnapshotSyncService)
const widgetSnapshotSyncServiceProvider = WidgetSnapshotSyncServiceProvider._();

/// 小组件快照同步服务提供器，统一复用任务事实源、设置偏好和共享存储。

final class WidgetSnapshotSyncServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<WidgetSnapshotSyncService>,
          WidgetSnapshotSyncService,
          FutureOr<WidgetSnapshotSyncService>
        >
    with
        $FutureModifier<WidgetSnapshotSyncService>,
        $FutureProvider<WidgetSnapshotSyncService> {
  /// 小组件快照同步服务提供器，统一复用任务事实源、设置偏好和共享存储。
  const WidgetSnapshotSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetSnapshotSyncServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetSnapshotSyncServiceHash();

  @$internal
  @override
  $FutureProviderElement<WidgetSnapshotSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WidgetSnapshotSyncService> create(Ref ref) {
    return widgetSnapshotSyncService(ref);
  }
}

String _$widgetSnapshotSyncServiceHash() =>
    r'3ffcd367196901d719e6041a4e9245832898eccb';

/// 小组件桥接控制器，统一收口预览读取与手动同步动作。

@ProviderFor(WidgetBridgeController)
const widgetBridgeControllerProvider = WidgetBridgeControllerProvider._();

/// 小组件桥接控制器，统一收口预览读取与手动同步动作。
final class WidgetBridgeControllerProvider
    extends $AsyncNotifierProvider<WidgetBridgeController, WidgetSnapshot> {
  /// 小组件桥接控制器，统一收口预览读取与手动同步动作。
  const WidgetBridgeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetBridgeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetBridgeControllerHash();

  @$internal
  @override
  WidgetBridgeController create() => WidgetBridgeController();
}

String _$widgetBridgeControllerHash() =>
    r'dafb1aea0267a55fcdea41d75c1aecdc23012a57';

/// 小组件桥接控制器，统一收口预览读取与手动同步动作。

abstract class _$WidgetBridgeController extends $AsyncNotifier<WidgetSnapshot> {
  FutureOr<WidgetSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<WidgetSnapshot>, WidgetSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WidgetSnapshot>, WidgetSnapshot>,
              AsyncValue<WidgetSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
