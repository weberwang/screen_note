// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_launch_bridge.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Widget 回流桥接提供器，允许测试替换启动 URI 和点击事件。

@ProviderFor(widgetLaunchBridge)
const widgetLaunchBridgeProvider = WidgetLaunchBridgeProvider._();

/// Widget 回流桥接提供器，允许测试替换启动 URI 和点击事件。

final class WidgetLaunchBridgeProvider
    extends
        $FunctionalProvider<
          WidgetLaunchBridge,
          WidgetLaunchBridge,
          WidgetLaunchBridge
        >
    with $Provider<WidgetLaunchBridge> {
  /// Widget 回流桥接提供器，允许测试替换启动 URI 和点击事件。
  const WidgetLaunchBridgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetLaunchBridgeProvider',
        isAutoDispose: true,
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
    r'9bce50ddb02e1acb01e6100d001c63fa16b4092a';
