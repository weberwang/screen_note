// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_secure_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 提供全局敏感值存储封装。

@ProviderFor(appSecureStorage)
const appSecureStorageProvider = AppSecureStorageProvider._();

/// 提供全局敏感值存储封装。

final class AppSecureStorageProvider
    extends
        $FunctionalProvider<
          AppSecureStorage,
          AppSecureStorage,
          AppSecureStorage
        >
    with $Provider<AppSecureStorage> {
  /// 提供全局敏感值存储封装。
  const AppSecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSecureStorageProvider',
        isAutoDispose: false,
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

String _$appSecureStorageHash() => r'a59efed92d13fe8c705c624f70fa6153aa0dfb2a';
