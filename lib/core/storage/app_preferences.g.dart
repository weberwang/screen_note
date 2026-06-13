// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 异步创建轻量偏好实例。

@ProviderFor(appPreferences)
const appPreferencesProvider = AppPreferencesProvider._();

/// 异步创建轻量偏好实例。

final class AppPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppPreferences>,
          AppPreferences,
          FutureOr<AppPreferences>
        >
    with $FutureModifier<AppPreferences>, $FutureProvider<AppPreferences> {
  /// 异步创建轻量偏好实例。
  const AppPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<AppPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AppPreferences> create(Ref ref) {
    return appPreferences(ref);
  }
}

String _$appPreferencesHash() => r'4c2e99bd279114b38697c12fa506f486ba92b63b';
