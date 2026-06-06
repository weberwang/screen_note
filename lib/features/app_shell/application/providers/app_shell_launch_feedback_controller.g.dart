// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_shell_launch_feedback_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 壳层回流反馈控制器，只维护最近一次待消费的轻反馈事件。

@ProviderFor(AppShellLaunchFeedbackController)
const appShellLaunchFeedbackControllerProvider =
    AppShellLaunchFeedbackControllerProvider._();

/// 壳层回流反馈控制器，只维护最近一次待消费的轻反馈事件。
final class AppShellLaunchFeedbackControllerProvider
    extends
        $NotifierProvider<
          AppShellLaunchFeedbackController,
          AppShellLaunchFeedbackEvent?
        > {
  /// 壳层回流反馈控制器，只维护最近一次待消费的轻反馈事件。
  const AppShellLaunchFeedbackControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appShellLaunchFeedbackControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appShellLaunchFeedbackControllerHash();

  @$internal
  @override
  AppShellLaunchFeedbackController create() =>
      AppShellLaunchFeedbackController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppShellLaunchFeedbackEvent? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppShellLaunchFeedbackEvent?>(value),
    );
  }
}

String _$appShellLaunchFeedbackControllerHash() =>
    r'714c4bc579fba2b8a3b6e8090db1c7137ba97c3a';

/// 壳层回流反馈控制器，只维护最近一次待消费的轻反馈事件。

abstract class _$AppShellLaunchFeedbackController
    extends $Notifier<AppShellLaunchFeedbackEvent?> {
  AppShellLaunchFeedbackEvent? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AppShellLaunchFeedbackEvent?, AppShellLaunchFeedbackEvent?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AppShellLaunchFeedbackEvent?,
                AppShellLaunchFeedbackEvent?
              >,
              AppShellLaunchFeedbackEvent?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
