// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_init_stage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 当前 Provider 只用于验证初始化阶段的 Riverpod 生成链，
/// 不代表应用已经进入真实启动、注入或路由装配阶段。

@ProviderFor(appInitStage)
const appInitStageProvider = AppInitStageProvider._();

/// 当前 Provider 只用于验证初始化阶段的 Riverpod 生成链，
/// 不代表应用已经进入真实启动、注入或路由装配阶段。

final class AppInitStageProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 当前 Provider 只用于验证初始化阶段的 Riverpod 生成链，
  /// 不代表应用已经进入真实启动、注入或路由装配阶段。
  const AppInitStageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appInitStageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appInitStageHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return appInitStage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$appInitStageHash() => r'e5a5be618b954cc0cf1692ce09df8c562dc3988f';
