// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_launch_bridge.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 根路由只依赖这个 Provider 获取安全初始落点。

@ProviderFor(widgetLaunchBridge)
const widgetLaunchBridgeProvider = WidgetLaunchBridgeProvider._();

/// 根路由只依赖这个 Provider 获取安全初始落点。

final class WidgetLaunchBridgeProvider
    extends
        $FunctionalProvider<
          WidgetLaunchBridge,
          WidgetLaunchBridge,
          WidgetLaunchBridge
        >
    with $Provider<WidgetLaunchBridge> {
  /// 根路由只依赖这个 Provider 获取安全初始落点。
  const WidgetLaunchBridgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetLaunchBridgeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetLaunchBridgeHash();

  @$internal
  @override
  $ProviderElement<WidgetLaunchBridge> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WidgetLaunchBridge create(Ref ref) {
    return widgetLaunchBridge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WidgetLaunchBridge value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WidgetLaunchBridge>(value),
    );
  }
}

String _$widgetLaunchBridgeHash() =>
    r'77c6178039571908cb5cd8c9db46dd8bf9fd928a';
