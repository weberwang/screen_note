// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_shell_ui_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 共享壳层 UI 状态控制器负责维护全局轻量交互状态，
/// 避免页面直接共享可变字段。

@ProviderFor(AppShellUiStateController)
const appShellUiStateControllerProvider = AppShellUiStateControllerProvider._();

/// 共享壳层 UI 状态控制器负责维护全局轻量交互状态，
/// 避免页面直接共享可变字段。
final class AppShellUiStateControllerProvider
    extends $NotifierProvider<AppShellUiStateController, AppShellUiState> {
  /// 共享壳层 UI 状态控制器负责维护全局轻量交互状态，
  /// 避免页面直接共享可变字段。
  const AppShellUiStateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appShellUiStateControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appShellUiStateControllerHash();

  @$internal
  @override
  AppShellUiStateController create() => AppShellUiStateController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppShellUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppShellUiState>(value),
    );
  }
}

String _$appShellUiStateControllerHash() =>
    r'02f55c19649ed495eedc46a35b3a9eaef20aa0d6';

/// 共享壳层 UI 状态控制器负责维护全局轻量交互状态，
/// 避免页面直接共享可变字段。

abstract class _$AppShellUiStateController extends $Notifier<AppShellUiState> {
  AppShellUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppShellUiState, AppShellUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppShellUiState, AppShellUiState>,
              AppShellUiState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
