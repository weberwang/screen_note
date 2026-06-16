// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_center_runtime_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsSharedPreferences)
const settingsSharedPreferencesProvider = SettingsSharedPreferencesProvider._();

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
  const SettingsSharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsSharedPreferencesProvider',
        isAutoDispose: false,
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
    r'4f71685a03ee755629f2fe2cdd83362b4e26c9f5';

/// 设置偏好仓储 Provider，统一暴露真实本地偏好入口，避免页面层直接碰 shared_preferences。

@ProviderFor(settingsPreferencesRepository)
const settingsPreferencesRepositoryProvider =
    SettingsPreferencesRepositoryProvider._();

/// 设置偏好仓储 Provider，统一暴露真实本地偏好入口，避免页面层直接碰 shared_preferences。

final class SettingsPreferencesRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsPreferencesRepository,
          SettingsPreferencesRepository,
          SettingsPreferencesRepository
        >
    with $Provider<SettingsPreferencesRepository> {
  /// 设置偏好仓储 Provider，统一暴露真实本地偏好入口，避免页面层直接碰 shared_preferences。
  const SettingsPreferencesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsPreferencesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsPreferencesRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsPreferencesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsPreferencesRepository create(Ref ref) {
    return settingsPreferencesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsPreferencesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsPreferencesRepository>(
        value,
      ),
    );
  }
}

String _$settingsPreferencesRepositoryHash() =>
    r'5a5374bd46fdab0375538296f956d0fd184fdfc3';

/// 本地通知插件 Provider，供设置页统一读取或请求通知权限状态。

@ProviderFor(settingsNotificationPlugin)
const settingsNotificationPluginProvider =
    SettingsNotificationPluginProvider._();

/// 本地通知插件 Provider，供设置页统一读取或请求通知权限状态。

final class SettingsNotificationPluginProvider
    extends
        $FunctionalProvider<
          FlutterLocalNotificationsPlugin,
          FlutterLocalNotificationsPlugin,
          FlutterLocalNotificationsPlugin
        >
    with $Provider<FlutterLocalNotificationsPlugin> {
  /// 本地通知插件 Provider，供设置页统一读取或请求通知权限状态。
  const SettingsNotificationPluginProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsNotificationPluginProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsNotificationPluginHash();

  @$internal
  @override
  $ProviderElement<FlutterLocalNotificationsPlugin> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterLocalNotificationsPlugin create(Ref ref) {
    return settingsNotificationPlugin(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterLocalNotificationsPlugin value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterLocalNotificationsPlugin>(
        value,
      ),
    );
  }
}

String _$settingsNotificationPluginHash() =>
    r'24101d9dab56b3d0b5433eb76ee0ce762bddc29a';

/// 通知权限仓储 Provider，统一屏蔽平台实现差异与失败降级。

@ProviderFor(notificationPermissionRepository)
const notificationPermissionRepositoryProvider =
    NotificationPermissionRepositoryProvider._();

/// 通知权限仓储 Provider，统一屏蔽平台实现差异与失败降级。

final class NotificationPermissionRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationPermissionRepository,
          NotificationPermissionRepository,
          NotificationPermissionRepository
        >
    with $Provider<NotificationPermissionRepository> {
  /// 通知权限仓储 Provider，统一屏蔽平台实现差异与失败降级。
  const NotificationPermissionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPermissionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationPermissionRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationPermissionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationPermissionRepository create(Ref ref) {
    return notificationPermissionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationPermissionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationPermissionRepository>(
        value,
      ),
    );
  }
}

String _$notificationPermissionRepositoryHash() =>
    r'4b8f60ff84586689ca3621a9fbfdb8016702d8ad';

/// 小组件安装仓储 Provider，统一封装设置页对桌面固定能力的访问。

@ProviderFor(widgetInstallationRepository)
const widgetInstallationRepositoryProvider =
    WidgetInstallationRepositoryProvider._();

/// 小组件安装仓储 Provider，统一封装设置页对桌面固定能力的访问。

final class WidgetInstallationRepositoryProvider
    extends
        $FunctionalProvider<
          WidgetInstallationRepository,
          WidgetInstallationRepository,
          WidgetInstallationRepository
        >
    with $Provider<WidgetInstallationRepository> {
  /// 小组件安装仓储 Provider，统一封装设置页对桌面固定能力的访问。
  const WidgetInstallationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetInstallationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetInstallationRepositoryHash();

  @$internal
  @override
  $ProviderElement<WidgetInstallationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WidgetInstallationRepository create(Ref ref) {
    return widgetInstallationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WidgetInstallationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WidgetInstallationRepository>(value),
    );
  }
}

String _$widgetInstallationRepositoryHash() =>
    r'9996bda628379a741042265e5795b19f693cfd92';

/// 默认设置副作用端口，当前接入 Widget 快照自动同步，同时保留独立的可替换入口。

@ProviderFor(defaultSettingsSideEffectPort)
const defaultSettingsSideEffectPortProvider =
    DefaultSettingsSideEffectPortProvider._();

/// 默认设置副作用端口，当前接入 Widget 快照自动同步，同时保留独立的可替换入口。

final class DefaultSettingsSideEffectPortProvider
    extends
        $FunctionalProvider<
          SettingsSideEffectPort,
          SettingsSideEffectPort,
          SettingsSideEffectPort
        >
    with $Provider<SettingsSideEffectPort> {
  /// 默认设置副作用端口，当前接入 Widget 快照自动同步，同时保留独立的可替换入口。
  const DefaultSettingsSideEffectPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultSettingsSideEffectPortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultSettingsSideEffectPortHash();

  @$internal
  @override
  $ProviderElement<SettingsSideEffectPort> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsSideEffectPort create(Ref ref) {
    return defaultSettingsSideEffectPort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsSideEffectPort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsSideEffectPort>(value),
    );
  }
}

String _$defaultSettingsSideEffectPortHash() =>
    r'7c2e634e56ca97c7fe8060506f53749ea61f32df';

/// 设置副作用装配点，允许测试或后续能力按 Provider 维度替换。

@ProviderFor(settingsSideEffectPort)
const settingsSideEffectPortProvider = SettingsSideEffectPortProvider._();

/// 设置副作用装配点，允许测试或后续能力按 Provider 维度替换。

final class SettingsSideEffectPortProvider
    extends
        $FunctionalProvider<
          SettingsSideEffectPort,
          SettingsSideEffectPort,
          SettingsSideEffectPort
        >
    with $Provider<SettingsSideEffectPort> {
  /// 设置副作用装配点，允许测试或后续能力按 Provider 维度替换。
  const SettingsSideEffectPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsSideEffectPortProvider',
        isAutoDispose: false,
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
    r'328c28df3f46d05314482bc8c6c0c8d03b111703';

/// 设置页快照用例 Provider，统一装配偏好、权限状态与次级入口边界。

@ProviderFor(loadSettingsCenterSnapshotUseCase)
const loadSettingsCenterSnapshotUseCaseProvider =
    LoadSettingsCenterSnapshotUseCaseProvider._();

/// 设置页快照用例 Provider，统一装配偏好、权限状态与次级入口边界。

final class LoadSettingsCenterSnapshotUseCaseProvider
    extends
        $FunctionalProvider<
          LoadSettingsCenterSnapshotUseCase,
          LoadSettingsCenterSnapshotUseCase,
          LoadSettingsCenterSnapshotUseCase
        >
    with $Provider<LoadSettingsCenterSnapshotUseCase> {
  /// 设置页快照用例 Provider，统一装配偏好、权限状态与次级入口边界。
  const LoadSettingsCenterSnapshotUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadSettingsCenterSnapshotUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$loadSettingsCenterSnapshotUseCaseHash();

  @$internal
  @override
  $ProviderElement<LoadSettingsCenterSnapshotUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoadSettingsCenterSnapshotUseCase create(Ref ref) {
    return loadSettingsCenterSnapshotUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadSettingsCenterSnapshotUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadSettingsCenterSnapshotUseCase>(
        value,
      ),
    );
  }
}

String _$loadSettingsCenterSnapshotUseCaseHash() =>
    r'2c21d005f841fbebf6e2e5506057926d3f53134f';

/// 隐私模式更新用例 Provider。

@ProviderFor(updatePrivacyModeUseCase)
const updatePrivacyModeUseCaseProvider = UpdatePrivacyModeUseCaseProvider._();

/// 隐私模式更新用例 Provider。

final class UpdatePrivacyModeUseCaseProvider
    extends
        $FunctionalProvider<
          UpdatePrivacyModeUseCase,
          UpdatePrivacyModeUseCase,
          UpdatePrivacyModeUseCase
        >
    with $Provider<UpdatePrivacyModeUseCase> {
  /// 隐私模式更新用例 Provider。
  const UpdatePrivacyModeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updatePrivacyModeUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updatePrivacyModeUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdatePrivacyModeUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdatePrivacyModeUseCase create(Ref ref) {
    return updatePrivacyModeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdatePrivacyModeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdatePrivacyModeUseCase>(value),
    );
  }
}

String _$updatePrivacyModeUseCaseHash() =>
    r'81d47fc12201f2be6105b0267ade83c4665f9b06';

/// 展示模式更新用例 Provider。

@ProviderFor(updateWidgetDisplayModeUseCase)
const updateWidgetDisplayModeUseCaseProvider =
    UpdateWidgetDisplayModeUseCaseProvider._();

/// 展示模式更新用例 Provider。

final class UpdateWidgetDisplayModeUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateWidgetDisplayModeUseCase,
          UpdateWidgetDisplayModeUseCase,
          UpdateWidgetDisplayModeUseCase
        >
    with $Provider<UpdateWidgetDisplayModeUseCase> {
  /// 展示模式更新用例 Provider。
  const UpdateWidgetDisplayModeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateWidgetDisplayModeUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateWidgetDisplayModeUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateWidgetDisplayModeUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateWidgetDisplayModeUseCase create(Ref ref) {
    return updateWidgetDisplayModeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateWidgetDisplayModeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateWidgetDisplayModeUseCase>(
        value,
      ),
    );
  }
}

String _$updateWidgetDisplayModeUseCaseHash() =>
    r'6861cfaaa56922401e8ed115894f484322c5f846';

/// 主题偏好更新用例 Provider。

@ProviderFor(updateThemeModePreferenceUseCase)
const updateThemeModePreferenceUseCaseProvider =
    UpdateThemeModePreferenceUseCaseProvider._();

/// 主题偏好更新用例 Provider。

final class UpdateThemeModePreferenceUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateThemeModePreferenceUseCase,
          UpdateThemeModePreferenceUseCase,
          UpdateThemeModePreferenceUseCase
        >
    with $Provider<UpdateThemeModePreferenceUseCase> {
  /// 主题偏好更新用例 Provider。
  const UpdateThemeModePreferenceUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateThemeModePreferenceUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateThemeModePreferenceUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateThemeModePreferenceUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateThemeModePreferenceUseCase create(Ref ref) {
    return updateThemeModePreferenceUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateThemeModePreferenceUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateThemeModePreferenceUseCase>(
        value,
      ),
    );
  }
}

String _$updateThemeModePreferenceUseCaseHash() =>
    r'd80a567d2eb0848a9ccf58a354f8fdc6419d1c0b';

/// 语言偏好更新用例 Provider。

@ProviderFor(updateLanguagePreferenceUseCase)
const updateLanguagePreferenceUseCaseProvider =
    UpdateLanguagePreferenceUseCaseProvider._();

/// 语言偏好更新用例 Provider。

final class UpdateLanguagePreferenceUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateLanguagePreferenceUseCase,
          UpdateLanguagePreferenceUseCase,
          UpdateLanguagePreferenceUseCase
        >
    with $Provider<UpdateLanguagePreferenceUseCase> {
  /// 语言偏好更新用例 Provider。
  const UpdateLanguagePreferenceUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateLanguagePreferenceUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateLanguagePreferenceUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateLanguagePreferenceUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateLanguagePreferenceUseCase create(Ref ref) {
    return updateLanguagePreferenceUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateLanguagePreferenceUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateLanguagePreferenceUseCase>(
        value,
      ),
    );
  }
}

String _$updateLanguagePreferenceUseCaseHash() =>
    r'8a6171953944176a22ded43f3bb24b58cb364d6d';

/// 小组件添加用例 Provider。

@ProviderFor(requestPinWidgetUseCase)
const requestPinWidgetUseCaseProvider = RequestPinWidgetUseCaseProvider._();

/// 小组件添加用例 Provider。

final class RequestPinWidgetUseCaseProvider
    extends
        $FunctionalProvider<
          RequestPinWidgetUseCase,
          RequestPinWidgetUseCase,
          RequestPinWidgetUseCase
        >
    with $Provider<RequestPinWidgetUseCase> {
  /// 小组件添加用例 Provider。
  const RequestPinWidgetUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestPinWidgetUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestPinWidgetUseCaseHash();

  @$internal
  @override
  $ProviderElement<RequestPinWidgetUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RequestPinWidgetUseCase create(Ref ref) {
    return requestPinWidgetUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestPinWidgetUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestPinWidgetUseCase>(value),
    );
  }
}

String _$requestPinWidgetUseCaseHash() =>
    r'5de6edfe1080b277e426b83709db12bb654cd17a';

/// 通知权限复查用例 Provider。

@ProviderFor(reviewNotificationPermissionUseCase)
const reviewNotificationPermissionUseCaseProvider =
    ReviewNotificationPermissionUseCaseProvider._();

/// 通知权限复查用例 Provider。

final class ReviewNotificationPermissionUseCaseProvider
    extends
        $FunctionalProvider<
          ReviewNotificationPermissionUseCase,
          ReviewNotificationPermissionUseCase,
          ReviewNotificationPermissionUseCase
        >
    with $Provider<ReviewNotificationPermissionUseCase> {
  /// 通知权限复查用例 Provider。
  const ReviewNotificationPermissionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewNotificationPermissionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$reviewNotificationPermissionUseCaseHash();

  @$internal
  @override
  $ProviderElement<ReviewNotificationPermissionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReviewNotificationPermissionUseCase create(Ref ref) {
    return reviewNotificationPermissionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewNotificationPermissionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewNotificationPermissionUseCase>(
        value,
      ),
    );
  }
}

String _$reviewNotificationPermissionUseCaseHash() =>
    r'6ecb947b0581b3e5061891aa52fa7bceb46b4bb9';

/// 设置页基础快照 Provider，供控制器或其他轻量读取场景复用。

@ProviderFor(settingsCenterSnapshot)
const settingsCenterSnapshotProvider = SettingsCenterSnapshotProvider._();

/// 设置页基础快照 Provider，供控制器或其他轻量读取场景复用。

final class SettingsCenterSnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<SettingsCenterSnapshot>,
          SettingsCenterSnapshot,
          FutureOr<SettingsCenterSnapshot>
        >
    with
        $FutureModifier<SettingsCenterSnapshot>,
        $FutureProvider<SettingsCenterSnapshot> {
  /// 设置页基础快照 Provider，供控制器或其他轻量读取场景复用。
  const SettingsCenterSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsCenterSnapshotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsCenterSnapshotHash();

  @$internal
  @override
  $FutureProviderElement<SettingsCenterSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SettingsCenterSnapshot> create(Ref ref) {
    return settingsCenterSnapshot(ref);
  }
}

String _$settingsCenterSnapshotHash() =>
    r'41c5abbe4e5be93ea95ff4fb508a06b3debc1b99';

/// 根应用偏好控制器只承接主题与语言等全局展示偏好，避免根应用直接依赖设置页快照装配。

@ProviderFor(SettingsCenterPreferencesController)
const settingsCenterPreferencesControllerProvider =
    SettingsCenterPreferencesControllerProvider._();

/// 根应用偏好控制器只承接主题与语言等全局展示偏好，避免根应用直接依赖设置页快照装配。
final class SettingsCenterPreferencesControllerProvider
    extends
        $AsyncNotifierProvider<
          SettingsCenterPreferencesController,
          SettingsCenterPreferences
        > {
  /// 根应用偏好控制器只承接主题与语言等全局展示偏好，避免根应用直接依赖设置页快照装配。
  const SettingsCenterPreferencesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsCenterPreferencesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$settingsCenterPreferencesControllerHash();

  @$internal
  @override
  SettingsCenterPreferencesController create() =>
      SettingsCenterPreferencesController();
}

String _$settingsCenterPreferencesControllerHash() =>
    r'1aa83c42bfbdfdf85b7fa670d5938ae98da1eaf2';

/// 根应用偏好控制器只承接主题与语言等全局展示偏好，避免根应用直接依赖设置页快照装配。

abstract class _$SettingsCenterPreferencesController
    extends $AsyncNotifier<SettingsCenterPreferences> {
  FutureOr<SettingsCenterPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SettingsCenterPreferences>,
              SettingsCenterPreferences
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SettingsCenterPreferences>,
                SettingsCenterPreferences
              >,
              AsyncValue<SettingsCenterPreferences>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 根应用消费的同步偏好 Provider，加载中的短暂阶段回退到默认值，避免 MaterialApp 出现空配置。

@ProviderFor(currentSettingsCenterPreferences)
const currentSettingsCenterPreferencesProvider =
    CurrentSettingsCenterPreferencesProvider._();

/// 根应用消费的同步偏好 Provider，加载中的短暂阶段回退到默认值，避免 MaterialApp 出现空配置。

final class CurrentSettingsCenterPreferencesProvider
    extends
        $FunctionalProvider<
          SettingsCenterPreferences,
          SettingsCenterPreferences,
          SettingsCenterPreferences
        >
    with $Provider<SettingsCenterPreferences> {
  /// 根应用消费的同步偏好 Provider，加载中的短暂阶段回退到默认值，避免 MaterialApp 出现空配置。
  const CurrentSettingsCenterPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSettingsCenterPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSettingsCenterPreferencesHash();

  @$internal
  @override
  $ProviderElement<SettingsCenterPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsCenterPreferences create(Ref ref) {
    return currentSettingsCenterPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsCenterPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsCenterPreferences>(value),
    );
  }
}

String _$currentSettingsCenterPreferencesHash() =>
    r'90966193d66085d9f14342b4bd7acaed62d13914';

/// 设置页控制器统一承接快照刷新、偏好更新与通知权限复查。

@ProviderFor(SettingsCenterController)
const settingsCenterControllerProvider = SettingsCenterControllerProvider._();

/// 设置页控制器统一承接快照刷新、偏好更新与通知权限复查。
final class SettingsCenterControllerProvider
    extends
        $AsyncNotifierProvider<
          SettingsCenterController,
          SettingsCenterSnapshot
        > {
  /// 设置页控制器统一承接快照刷新、偏好更新与通知权限复查。
  const SettingsCenterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsCenterControllerProvider',
        isAutoDispose: false,
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
    r'1dda6f4d7eb8d13ba4a1e2f6d491942acef85c84';

/// 设置页控制器统一承接快照刷新、偏好更新与通知权限复查。

abstract class _$SettingsCenterController
    extends $AsyncNotifier<SettingsCenterSnapshot> {
  FutureOr<SettingsCenterSnapshot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<SettingsCenterSnapshot>, SettingsCenterSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SettingsCenterSnapshot>,
                SettingsCenterSnapshot
              >,
              AsyncValue<SettingsCenterSnapshot>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
