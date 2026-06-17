import 'package:flutter_test/flutter_test.dart';

import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/application/use_cases/load_settings_center_snapshot_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/review_notification_permission_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_language_preference_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_privacy_mode_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_theme_mode_preference_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_widget_display_mode_use_case.dart';
import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_membership_state.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_sync_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

void main() {
  test('加载设置快照会装配偏好、通知权限、同步与会员边界', () async {
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(
        privacyModeEnabled: true,
        widgetDisplayMode: WidgetDisplayMode.previewOnly,
      ),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.disabled,
    );
    final useCase = LoadSettingsCenterSnapshotUseCase(
      preferencesRepository: preferencesRepository,
      notificationRepository: notificationRepository,
    );

    final snapshot = await useCase.execute();

    expect(
      snapshot.notificationPermissionStatus,
      NotificationPermissionStatus.disabled,
    );
    expect(snapshot.preferences.privacyModeEnabled, isTrue);
    expect(
      snapshot.preferences.themeModePreference,
      SettingsThemeModePreference.system,
    );
    expect(
      snapshot.preferences.languagePreference,
      SettingsLanguagePreference.zh,
    );
    expect(snapshot.syncStatus, SettingsSyncStatus.localOnly);
    expect(snapshot.membershipState, SettingsMembershipState.available);
  });

  test('开启隐私模式时会把 fullContent 收敛为 previewOnly', () async {
    final repository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(
        privacyModeEnabled: false,
        widgetDisplayMode: WidgetDisplayMode.fullContent,
      ),
    );
    final sideEffectPort = _RecordingSettingsSideEffectPort();
    final useCase = UpdatePrivacyModeUseCase(
      repository: repository,
      sideEffectPort: sideEffectPort,
    );

    final updated = await useCase.execute(enabled: true);

    expect(updated.privacyModeEnabled, isTrue);
    expect(updated.widgetDisplayMode, WidgetDisplayMode.previewOnly);
    expect(sideEffectPort.recordedPreferences.single, updated);
  });

  test('隐私模式开启时更新 fullContent 会被强制收敛为 previewOnly', () async {
    final repository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(
        privacyModeEnabled: true,
        widgetDisplayMode: WidgetDisplayMode.previewOnly,
      ),
    );
    final sideEffectPort = _RecordingSettingsSideEffectPort();
    final useCase = UpdateWidgetDisplayModeUseCase(
      repository: repository,
      sideEffectPort: sideEffectPort,
    );

    final updated = await useCase.execute(mode: WidgetDisplayMode.fullContent);

    expect(updated.widgetDisplayMode, WidgetDisplayMode.previewOnly);
    expect(sideEffectPort.recordedPreferences.single, updated);
  });

  test('通知权限复查会返回仓储提供的最新状态', () async {
    final repository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.disabled,
      requestResult: NotificationPermissionStatus.enabled,
    );
    final useCase = ReviewNotificationPermissionUseCase(repository: repository);

    final status = await useCase.execute();

    expect(status, NotificationPermissionStatus.enabled);
  });
  test('更新主题偏好后会落库并触发共享副作用', () async {
    final repository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(),
    );
    final sideEffectPort = _RecordingSettingsSideEffectPort();
    final useCase = UpdateThemeModePreferenceUseCase(
      repository: repository,
      sideEffectPort: sideEffectPort,
    );

    final updated = await useCase.execute(
      mode: SettingsThemeModePreference.dark,
    );

    expect(updated.themeModePreference, SettingsThemeModePreference.dark);
    expect(sideEffectPort.recordedPreferences.single, updated);
  });

  test('更新语言偏好后会落库并触发共享副作用', () async {
    final repository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(),
    );
    final sideEffectPort = _RecordingSettingsSideEffectPort();
    final useCase = UpdateLanguagePreferenceUseCase(
      repository: repository,
      sideEffectPort: sideEffectPort,
    );

    final updated = await useCase.execute(
      language: SettingsLanguagePreference.en,
    );

    expect(updated.languagePreference, SettingsLanguagePreference.en);
    expect(sideEffectPort.recordedPreferences.single, updated);
  });
}

/// 内存偏好仓储只用于用例测试，避免把 shared_preferences 引入规则测试。
final class _InMemorySettingsPreferencesRepository
    implements SettingsPreferencesRepository {
  _InMemorySettingsPreferencesRepository({
    required SettingsCenterPreferences initial,
  }) : _current = initial;

  SettingsCenterPreferences _current;

  @override
  Future<SettingsCenterPreferences> loadPreferences() async => _current;

  @override
  Future<void> savePreferences(SettingsCenterPreferences preferences) async {
    _current = preferences;
  }
}

/// 假通知仓储只用于测试权限链路，不依赖真实平台通道。
final class _FakeNotificationPermissionRepository
    implements NotificationPermissionRepository {
  _FakeNotificationPermissionRepository({
    required NotificationPermissionStatus initialStatus,
    NotificationPermissionStatus? requestResult,
  }) : _current = initialStatus,
       _requestResult = requestResult ?? initialStatus;

  NotificationPermissionStatus _current;
  final NotificationPermissionStatus _requestResult;

  @override
  Future<NotificationPermissionStatus> readStatus() async => _current;

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    _current = _requestResult;
    return _current;
  }
}

/// 记录型设置副作用端口，用于验证偏好更新成功后确实触发了共享联动。
final class _RecordingSettingsSideEffectPort implements SettingsSideEffectPort {
  final List<SettingsCenterPreferences> recordedPreferences =
      <SettingsCenterPreferences>[];

  @override
  Future<void> onPreferencesChanged(SettingsCenterPreferences preferences) async {
    recordedPreferences.add(preferences);
  }
}
