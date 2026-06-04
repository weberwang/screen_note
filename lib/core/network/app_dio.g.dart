// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_dio.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 统一创建应用级 Dio 客户端，后续所有 Retrofit 接口都应复用这里的基座配置。

@ProviderFor(appDio)
const appDioProvider = AppDioProvider._();

/// 统一创建应用级 Dio 客户端，后续所有 Retrofit 接口都应复用这里的基座配置。

final class AppDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// 统一创建应用级 Dio 客户端，后续所有 Retrofit 接口都应复用这里的基座配置。
  const AppDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return appDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$appDioHash() => r'405afb2f94db8d8183b811070c0552644e4ed675';
