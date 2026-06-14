import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/features/app_shell/application/providers/app_shell_ui_state.dart';
import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/application/use_cases/load_settings_center_snapshot_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/review_notification_permission_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_privacy_mode_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_widget_display_mode_use_case.dart';
import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_snapshot.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/settings_center/infrastructure/flutter_local_notifications_permission_repository.dart';
import 'package:screen_note/features/settings_center/infrastructure/settings_center_noop_side_effect_port.dart';
import 'package:screen_note/features/settings_center/infrastructure/shared_preferences_settings_preferences_repository.dart';

part 'settings_center_runtime_providers.g.dart';

/// 设置偏好仓储 Provider，统一暴露真实本地偏好入口，避免页面层直接碰 shared_preferences。
@Riverpod(keepAlive: true)
SettingsPreferencesRepository settingsPreferencesRepository(Ref ref) {
  return const SharedPreferencesSettingsPreferencesRepository();
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
    state = const AsyncLoading<SettingsCenterSnapshot>();
    state = await AsyncValue.guard(_reloadSnapshot);
  }

  /// 更新隐私模式，并通过共享壳层反馈告知用户设置已生效。
  Future<void> updatePrivacyMode({
    required bool enabled,
    required String feedbackText,
  }) async {
    state = const AsyncLoading<SettingsCenterSnapshot>();
    state = await AsyncValue.guard(() async {
      await ref
          .read(updatePrivacyModeUseCaseProvider)
          .execute(enabled: enabled);
      _showFeedback(feedbackText);
      return _reloadSnapshot();
    });
  }

  /// 更新 Widget 展示模式，所有安全约束都交由应用层统一编排。
  Future<void> updateWidgetDisplayMode({
    required WidgetDisplayMode mode,
    required String feedbackText,
  }) async {
    state = const AsyncLoading<SettingsCenterSnapshot>();
    state = await AsyncValue.guard(() async {
      await ref.read(updateWidgetDisplayModeUseCaseProvider).execute(mode: mode);
      _showFeedback(feedbackText);
      return _reloadSnapshot();
    });
  }

  /// 触发通知权限复查，并根据结果返回不同的共享反馈语气。
  Future<void> reviewNotificationPermission({
    required String grantedFeedbackText,
    required String deferredFeedbackText,
  }) async {
    state = const AsyncLoading<SettingsCenterSnapshot>();
    state = await AsyncValue.guard(() async {
      final NotificationPermissionStatus status = await ref
          .read(reviewNotificationPermissionUseCaseProvider)
          .execute();
      _showFeedback(
        status == NotificationPermissionStatus.enabled
            ? grantedFeedbackText
            : deferredFeedbackText,
      );
      return _reloadSnapshot();
    });
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

  /// 统一处理设置页快照失效与重新读取，避免刷新策略散落在多个入口。
  Future<SettingsCenterSnapshot> _reloadSnapshot() async {
    ref.invalidate(settingsCenterSnapshotProvider);
    return ref.read(settingsCenterSnapshotProvider.future);
  }
}
