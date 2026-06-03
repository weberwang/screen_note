// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_secure_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 应用级安全存储提供器。

@ProviderFor(appSecureStorage)
const appSecureStorageProvider = AppSecureStorageProvider._();

/// 应用级安全存储提供器。

final class AppSecureStorageProvider
    extends
        $FunctionalProvider<
          AppSecureStorage,
          AppSecureStorage,
          AppSecureStorage
        >
    with $Provider<AppSecureStorage> {
  /// 应用级安全存储提供器。
  const AppSecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSecureStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSecureStorageHash();

  @$internal
  @override
  $ProviderElement<AppSecureStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppSecureStorage create(Ref ref) {
    return appSecureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSecureStorage>(value),
    );
  }
}

String _$appSecureStorageHash() => r'962b8eeab75e7e057e2aaa7c6c3be0518794db4b';
