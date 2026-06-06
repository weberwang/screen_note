// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_center_runtime_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 设置页偏好存储入口，复用全局 SharedPreferences 基线。

@ProviderFor(settingsSharedPreferences)
const settingsSharedPreferencesProvider = SettingsSharedPreferencesProvider._();

/// 设置页偏好存储入口，复用全局 SharedPreferences 基线。

final class SettingsSharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// 设置页偏好存储入口，复用全局 SharedPreferences 基线。
  const SettingsSharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsSharedPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsSharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return settingsSharedPreferences(ref);
  }
}

String _$settingsSharedPreferencesHash() =>
    r'be0fc3056b57b4714e250e9abcf8881316f6d401';

/// 设置偏好仓储提供器。

@ProviderFor(settingsPreferencesRepository)
const settingsPreferencesRepositoryProvider =
    SettingsPreferencesRepositoryProvider._();

/// 设置偏好仓储提供器。

final class SettingsPreferencesRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<SettingsPreferencesRepository>,
          SettingsPreferencesRepository,
          FutureOr<SettingsPreferencesRepository>
        >
    with
        $FutureModifier<SettingsPreferencesRepository>,
        $FutureProvider<SettingsPreferencesRepository> {
  /// 设置偏好仓储提供器。
  const SettingsPreferencesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsPreferencesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsPreferencesRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<SettingsPreferencesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SettingsPreferencesRepository> create(Ref ref) {
    return settingsPreferencesRepository(ref);
  }
}

String _$settingsPreferencesRepositoryHash() =>
    r'55f1d1b4493754e1069cd66b16c16034b140ea8b';

/// 设置副作用端口提供器。

@ProviderFor(settingsSideEffectPort)
const settingsSideEffectPortProvider = SettingsSideEffectPortProvider._();

/// 设置副作用端口提供器。

final class SettingsSideEffectPortProvider
    extends
        $FunctionalProvider<
          SettingsSideEffectPort,
          SettingsSideEffectPort,
          SettingsSideEffectPort
        >
    with $Provider<SettingsSideEffectPort> {
  /// 设置副作用端口提供器。
  const SettingsSideEffectPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsSideEffectPortProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsSideEffectPortHash();

  @$internal
  @override
  $ProviderElement<SettingsSideEffectPort> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsSideEffectPort create(Ref ref) {
    return settingsSideEffectPort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsSideEffectPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsSideEffectPort>(value),
    );
  }
}

String _$settingsSideEffectPortHash() =>
    r'6925a8ef1fd73d23a0e5c2c64739ff54cd3d3620';

/// 读取设置偏好用例提供器。

@ProviderFor(loadSettingsPreferencesUseCase)
const loadSettingsPreferencesUseCaseProvider =
    LoadSettingsPreferencesUseCaseProvider._();

/// 读取设置偏好用例提供器。

final class LoadSettingsPreferencesUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<LoadSettingsPreferencesUseCase>,
          LoadSettingsPreferencesUseCase,
          FutureOr<LoadSettingsPreferencesUseCase>
        >
    with
        $FutureModifier<LoadSettingsPreferencesUseCase>,
        $FutureProvider<LoadSettingsPreferencesUseCase> {
  /// 读取设置偏好用例提供器。
  const LoadSettingsPreferencesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadSettingsPreferencesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadSettingsPreferencesUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<LoadSettingsPreferencesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LoadSettingsPreferencesUseCase> create(Ref ref) {
    return loadSettingsPreferencesUseCase(ref);
  }
}

String _$loadSettingsPreferencesUseCaseHash() =>
    r'8b174280abb8e7e7a8fe6c95ffce4ca085758c56';

/// 更新设置偏好用例提供器。

@ProviderFor(updateSettingsPreferencesUseCase)
const updateSettingsPreferencesUseCaseProvider =
    UpdateSettingsPreferencesUseCaseProvider._();

/// 更新设置偏好用例提供器。

final class UpdateSettingsPreferencesUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<UpdateSettingsPreferencesUseCase>,
          UpdateSettingsPreferencesUseCase,
          FutureOr<UpdateSettingsPreferencesUseCase>
        >
    with
        $FutureModifier<UpdateSettingsPreferencesUseCase>,
        $FutureProvider<UpdateSettingsPreferencesUseCase> {
  /// 更新设置偏好用例提供器。
  const UpdateSettingsPreferencesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateSettingsPreferencesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateSettingsPreferencesUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<UpdateSettingsPreferencesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UpdateSettingsPreferencesUseCase> create(Ref ref) {
    return updateSettingsPreferencesUseCase(ref);
  }
}

String _$updateSettingsPreferencesUseCaseHash() =>
    r'1ac1c67d7365f6012290d4ed197d27f9b1c78b57';

/// 设置页控制器，统一收口偏好读取、切换和保存。

@ProviderFor(SettingsCenterController)
const settingsCenterControllerProvider = SettingsCenterControllerProvider._();

/// 设置页控制器，统一收口偏好读取、切换和保存。
final class SettingsCenterControllerProvider
    extends
        $AsyncNotifierProvider<SettingsCenterController, SettingsPreferences> {
  /// 设置页控制器，统一收口偏好读取、切换和保存。
  const SettingsCenterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsCenterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsCenterControllerHash();

  @$internal
  @override
  SettingsCenterController create() => SettingsCenterController();
}

String _$settingsCenterControllerHash() =>
    r'542633a36f11871044ee93d5e108d003a909acba';

/// 设置页控制器，统一收口偏好读取、切换和保存。

abstract class _$SettingsCenterController
    extends $AsyncNotifier<SettingsPreferences> {
  FutureOr<SettingsPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<SettingsPreferences>, SettingsPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SettingsPreferences>, SettingsPreferences>,
              AsyncValue<SettingsPreferences>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
