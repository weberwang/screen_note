import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/features/app_shell/application/providers/app_shell_ui_state.dart';
import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/application/use_cases/request_pin_widget_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/load_settings_center_snapshot_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/review_notification_permission_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_language_preference_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_privacy_mode_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_theme_mode_preference_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_widget_display_mode_use_case.dart';
import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_snapshot.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_pin_request_result.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/settings_center/domain/repositories/widget_installation_repository.dart';
import 'package:screen_note/features/settings_center/infrastructure/flutter_local_notifications_permission_repository.dart';
import 'package:screen_note/features/settings_center/infrastructure/home_widget_installation_repository.dart';
import 'package:screen_note/features/settings_center/infrastructure/settings_center_noop_side_effect_port.dart';
import 'package:screen_note/features/settings_center/infrastructure/shared_preferences_settings_preferences_repository.dart';

part 'settings_center_runtime_providers.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> settingsSharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

/// 设置偏好仓储 Provider，统一暴露真实本地偏好入口，避免页面层直接碰 shared_preferences。
@Riverpod(keepAlive: true)
SettingsPreferencesRepository settingsPreferencesRepository(Ref ref) {
  return SharedPreferencesSettingsPreferencesRepository(
    loadSharedPreferences: () => ref.watch(settingsSharedPreferencesProvider.future),
  );
}

/// 本地通知插件 Provider，供设置页统一读取或请求通知权限状态。
@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin settingsNotificationPlugin(Ref ref) {
  return FlutterLocalNotificationsPlugin();
}

/// 通知权限仓储 Provider，统一屏蔽平台实现差异与失败降级。
@Riverpod(keepAlive: true)
NotificationPermissionRepository notificationPermissionRepository(Ref ref) {
  return FlutterLocalNotificationsPermissionRepository(
    plugin: ref.watch(settingsNotificationPluginProvider),
  );
}

/// 小组件安装仓储 Provider，统一封装设置页对桌面固定能力的访问。
@Riverpod(keepAlive: true)
WidgetInstallationRepository widgetInstallationRepository(Ref ref) {
  return const HomeWidgetInstallationRepository();
}

/// 默认设置副作用端口，当前接入 Widget 快照自动同步，同时保留独立的可替换入口。
@Riverpod(keepAlive: true)
SettingsSideEffectPort defaultSettingsSideEffectPort(Ref ref) {
  return const SettingsCenterNoopSideEffectPort();
}

/// 设置副作用装配点，允许测试或后续能力按 Provider 维度替换。
@Riverpod(keepAlive: true)
SettingsSideEffectPort settingsSideEffectPort(Ref ref) {
  return ref.watch(defaultSettingsSideEffectPortProvider);
}

/// 设置页快照用例 Provider，统一装配偏好、权限状态与次级入口边界。
@riverpod
LoadSettingsCenterSnapshotUseCase loadSettingsCenterSnapshotUseCase(Ref ref) {
  return LoadSettingsCenterSnapshotUseCase(
    preferencesRepository: ref.watch(settingsPreferencesRepositoryProvider),
    notificationRepository: ref.watch(notificationPermissionRepositoryProvider),
  );
}

/// 隐私模式更新用例 Provider。
@riverpod
UpdatePrivacyModeUseCase updatePrivacyModeUseCase(Ref ref) {
  return UpdatePrivacyModeUseCase(
    repository: ref.watch(settingsPreferencesRepositoryProvider),
    sideEffectPort: ref.watch(settingsSideEffectPortProvider),
  );
}

/// 展示模式更新用例 Provider。
@riverpod
UpdateWidgetDisplayModeUseCase updateWidgetDisplayModeUseCase(Ref ref) {
  return UpdateWidgetDisplayModeUseCase(
    repository: ref.watch(settingsPreferencesRepositoryProvider),
    sideEffectPort: ref.watch(settingsSideEffectPortProvider),
  );
}

/// 主题偏好更新用例 Provider。
@riverpod
UpdateThemeModePreferenceUseCase updateThemeModePreferenceUseCase(Ref ref) {
  return UpdateThemeModePreferenceUseCase(
    repository: ref.watch(settingsPreferencesRepositoryProvider),
    sideEffectPort: ref.watch(settingsSideEffectPortProvider),
  );
}

/// 语言偏好更新用例 Provider。
@riverpod
UpdateLanguagePreferenceUseCase updateLanguagePreferenceUseCase(Ref ref) {
  return UpdateLanguagePreferenceUseCase(
    repository: ref.watch(settingsPreferencesRepositoryProvider),
    sideEffectPort: ref.watch(settingsSideEffectPortProvider),
  );
}

/// 小组件添加用例 Provider。
@riverpod
RequestPinWidgetUseCase requestPinWidgetUseCase(Ref ref) {
  return RequestPinWidgetUseCase(
    repository: ref.watch(widgetInstallationRepositoryProvider),
  );
}

/// 通知权限复查用例 Provider。
@riverpod
ReviewNotificationPermissionUseCase reviewNotificationPermissionUseCase(
  Ref ref,
) {
  return ReviewNotificationPermissionUseCase(
    repository: ref.watch(notificationPermissionRepositoryProvider),
  );
}

/// 设置页基础快照 Provider，供控制器或其他轻量读取场景复用。
@riverpod
Future<SettingsCenterSnapshot> settingsCenterSnapshot(Ref ref) {
  return ref.watch(loadSettingsCenterSnapshotUseCaseProvider).execute();
}

/// 根应用偏好控制器只承接主题与语言等全局展示偏好，避免根应用直接依赖设置页快照装配。
@Riverpod(keepAlive: true)
class SettingsCenterPreferencesController
    extends _$SettingsCenterPreferencesController {
  /// 首次构建时读取持久化偏好，作为根应用展示层的稳定来源。
  @override
  Future<SettingsCenterPreferences> build() {
    return ref.watch(settingsPreferencesRepositoryProvider).loadPreferences();
  }

  /// 用设置更新结果直接覆盖全局偏好，避免根应用还要额外等待仓储重读。
  void sync(SettingsCenterPreferences preferences) {
    state = AsyncData<SettingsCenterPreferences>(preferences);
  }

  /// 主动重读持久化偏好，供外部需要重新对齐根应用状态时复用。
  Future<void> refresh() async {
    state = const AsyncLoading<SettingsCenterPreferences>();
    state = await AsyncValue.guard(
      () => ref.read(settingsPreferencesRepositoryProvider).loadPreferences(),
    );
  }
}

/// 根应用消费的同步偏好 Provider，加载中的短暂阶段回退到默认值，避免 MaterialApp 出现空配置。
@Riverpod(keepAlive: true)
SettingsCenterPreferences currentSettingsCenterPreferences(Ref ref) {
  final AsyncValue<SettingsCenterPreferences> preferencesAsync = ref.watch(
    settingsCenterPreferencesControllerProvider,
  );
  return preferencesAsync.maybeWhen(
    data: (SettingsCenterPreferences preferences) => preferences,
    orElse: () => const SettingsCenterPreferences(),
  );
}

/// 设置页控制器统一承接快照刷新、偏好更新与通知权限复查。
@Riverpod(keepAlive: true)
class SettingsCenterController extends _$SettingsCenterController {
  /// 首次构建时读取设置页快照。
  @override
  Future<SettingsCenterSnapshot> build() {
    return ref.watch(settingsCenterSnapshotProvider.future);
  }

  /// 主动刷新设置页快照，供权限复查或页面重试时复用。
  Future<void> refresh() async {
    state = _loadingState();
    state = await AsyncValue.guard(_loadSnapshot);
  }

  /// 更新隐私模式，并通过共享壳层反馈告知用户设置已生效。
  Future<void> updatePrivacyMode({
    required bool enabled,
    required String feedbackText,
  }) async {
    state = _loadingState();
    state = await AsyncValue.guard(() async {
      final SettingsCenterPreferences next = await ref
          .read(updatePrivacyModeUseCaseProvider)
          .execute(enabled: enabled);
      _syncGlobalPreferences(next);
      _showFeedback(feedbackText);
      return _loadSnapshot();
    });
  }

  /// 更新 Widget 展示模式，所有安全约束都交由应用层统一编排。
  Future<void> updateWidgetDisplayMode({
    required WidgetDisplayMode mode,
    required String feedbackText,
  }) async {
    state = _loadingState();
    state = await AsyncValue.guard(() async {
      final SettingsCenterPreferences next = await ref
          .read(updateWidgetDisplayModeUseCaseProvider)
          .execute(mode: mode);
      _syncGlobalPreferences(next);
      _showFeedback(feedbackText);
      return _loadSnapshot();
    });
  }

  /// 更新主题偏好，并同步刷新根应用正在消费的全局展示偏好。
  Future<void> updateThemeModePreference({
    required SettingsThemeModePreference mode,
    required String feedbackText,
  }) async {
    state = _loadingState();
    state = await AsyncValue.guard(() async {
      final SettingsCenterPreferences next = await ref
          .read(updateThemeModePreferenceUseCaseProvider)
          .execute(mode: mode);
      _syncGlobalPreferences(next);
      _showFeedback(feedbackText);
      return _loadSnapshot();
    });
  }

  /// 更新语言偏好，并同步刷新根应用正在消费的 locale 偏好。
  Future<void> updateLanguagePreference({
    required SettingsLanguagePreference language,
    required String feedbackText,
  }) async {
    state = _loadingState();
    state = await AsyncValue.guard(() async {
      final SettingsCenterPreferences next = await ref
          .read(updateLanguagePreferenceUseCaseProvider)
          .execute(language: language);
      _syncGlobalPreferences(next);
      _showFeedback(feedbackText);
      return _loadSnapshot();
    });
  }

  /// 触发通知权限复查，并根据结果返回不同的共享反馈语气。
  Future<void> reviewNotificationPermission({
    required String grantedFeedbackText,
    required String deferredFeedbackText,
  }) async {
    state = _loadingState();
    state = await AsyncValue.guard(() async {
      final NotificationPermissionStatus status = await ref
          .read(reviewNotificationPermissionUseCaseProvider)
          .execute();
      _showFeedback(
        status == NotificationPermissionStatus.enabled
            ? grantedFeedbackText
            : deferredFeedbackText,
      );
      return _loadSnapshot();
    });
  }

  /// 触发桌面小组件添加请求，并把平台结果映射成共享轻反馈。
  Future<void> requestPinWidget({
    required String requestedFeedbackText,
    required String unsupportedFeedbackText,
    required String failedFeedbackText,
  }) async {
    final WidgetPinRequestResult result = await ref
        .read(requestPinWidgetUseCaseProvider)
        .execute();
    _showFeedback(
      switch (result) {
        WidgetPinRequestResult.requested => requestedFeedbackText,
        WidgetPinRequestResult.unsupported => unsupportedFeedbackText,
        WidgetPinRequestResult.failed => failedFeedbackText,
      },
    );
  }

  /// 统一复用共享壳层轻反馈宿主，避免设置页私自引入另一套提示系统。
  void _showFeedback(String text) {
    ref.read(appShellUiStateControllerProvider.notifier).showFeedback(
      AppShellFeedbackMessage(
        level: AppShellFeedbackLevel.info,
        text: text,
      ),
    );
  }

  /// 设置页更新偏好后直接同步根应用控制器，避免 MaterialApp 还要依赖一次额外异步重读。
  void _syncGlobalPreferences(SettingsCenterPreferences preferences) {
    ref
        .read(settingsCenterPreferencesControllerProvider.notifier)
        .sync(preferences);
  }

  /// 已有快照刷新时保留旧数据，避免设置页因二次重载出现短暂白屏。
  AsyncValue<SettingsCenterSnapshot> _loadingState() {
    return switch (state) {
      AsyncData<SettingsCenterSnapshot>() => state,
      _ => const AsyncLoading<SettingsCenterSnapshot>(),
    };
  }

  /// 统一直接读取设置页快照用例，避免依赖基础快照 Provider 的失效重算链路。
  Future<SettingsCenterSnapshot> _loadSnapshot() {
    return ref.read(loadSettingsCenterSnapshotUseCaseProvider).execute();
  }
}
