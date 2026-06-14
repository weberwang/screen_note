import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/features/app_shell/application/providers/app_shell_ui_state.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/application/use_cases/load_settings_center_snapshot_use_case.dart';
import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_membership_state.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_snapshot.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_sync_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

void main() {
  testWidgets('设置页会展示通知、隐私、展示模式、同步与会员分区', (tester) async {
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.disabled,
    );

    await _pumpSettingsPage(
      tester,
      preferencesRepository: preferencesRepository,
      notificationRepository: notificationRepository,
    );

    expect(find.text('Settings Center'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Privacy'), 120);
    expect(find.text('Privacy'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Display'), 120);
    expect(find.text('Display'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Sync & Backup'), 200);
    expect(find.text('Sync & Backup'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Membership'), 120);
    expect(find.text('Membership'), findsOneWidget);
  });

  testWidgets('切换隐私模式会更新偏好并写入共享反馈', (tester) async {
    _prepareTestViewport(tester);
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(
        privacyModeEnabled: true,
        widgetDisplayMode: WidgetDisplayMode.previewOnly,
      ),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.enabled,
    );
    final ProviderContainer container = ProviderContainer(
      overrides: [
        settingsPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
        notificationPermissionRepositoryProvider.overrideWithValue(
          notificationRepository,
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: ScreenNoteScreenUtilContract(
          designSize: screenNoteDesignSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ScreenNoteTheme.light().copyWith(
                splashFactory: NoSplash.splashFactory,
              ),
              darkTheme: ScreenNoteTheme.dark().copyWith(
                splashFactory: NoSplash.splashFactory,
              ),
              home: const Scaffold(body: SettingsCenterPage()),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Privacy Mode'), 120);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Privacy Mode'));
    await tester.pump();
    await tester.pumpAndSettle();

    final stored = await preferencesRepository.loadPreferences();
    expect(stored.privacyModeEnabled, isFalse);
    expect(
      container.read(appShellUiStateControllerProvider).feedback?.text,
      'Privacy setting updated.',
    );
  });

  testWidgets('隐私模式开启时选择 Full Content 仍会保持 Preview Only', (tester) async {
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(
        privacyModeEnabled: true,
        widgetDisplayMode: WidgetDisplayMode.previewOnly,
      ),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.enabled,
    );

    await _pumpSettingsPage(
      tester,
      preferencesRepository: preferencesRepository,
      notificationRepository: notificationRepository,
    );

    await tester.scrollUntilVisible(find.text('Widget Display Mode'), 120);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Widget Display Mode'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Full Content'));
    await tester.pump();
    await tester.pumpAndSettle();

    final stored = await preferencesRepository.loadPreferences();
    expect(stored.widgetDisplayMode, WidgetDisplayMode.previewOnly);
  });

  testWidgets('复查通知权限后会更新状态并移除降级提示', (tester) async {
    _prepareTestViewport(tester);
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.disabled,
      requestResult: NotificationPermissionStatus.enabled,
    );
    final ProviderContainer container = ProviderContainer(
      overrides: [
        settingsPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
        notificationPermissionRepositoryProvider.overrideWithValue(
          notificationRepository,
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: ScreenNoteScreenUtilContract(
          designSize: screenNoteDesignSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ScreenNoteTheme.light().copyWith(
                splashFactory: NoSplash.splashFactory,
              ),
              darkTheme: ScreenNoteTheme.dark().copyWith(
                splashFactory: NoSplash.splashFactory,
              ),
              home: const Scaffold(body: SettingsCenterPage()),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Permission downgraded'), findsOneWidget);

    await tester.ensureVisible(find.text('Review'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Permission downgraded'), findsNothing);
    expect(
      container
          .read(settingsCenterControllerProvider)
          .requireValue
          .notificationPermissionStatus,
      NotificationPermissionStatus.enabled,
    );
  });
  testWidgets('切换主题和语言后会写入偏好仓储', (tester) async {
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.enabled,
    );

    await _pumpSettingsPage(
      tester,
      preferencesRepository: preferencesRepository,
      notificationRepository: notificationRepository,
    );

    await tester.scrollUntilVisible(find.text('Theme'), 120);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pump();
    await tester.pumpAndSettle();

    var stored = await preferencesRepository.loadPreferences();
    expect(stored.themeModePreference, SettingsThemeModePreference.dark);

    await tester.scrollUntilVisible(find.text('Language'), 120);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simplified Chinese').last);
    await tester.pump();
    await tester.pumpAndSettle();

    stored = await preferencesRepository.loadPreferences();
    expect(stored.languagePreference, SettingsLanguagePreference.zh);
  });

  test('refresh 不应依赖 settingsCenterSnapshotProvider 的二次失效重读', () async {
    final SettingsCenterSnapshot initialSnapshot = _buildSettingsCenterSnapshot(
      notificationPermissionStatus: NotificationPermissionStatus.disabled,
    );
    final SettingsCenterSnapshot refreshedSnapshot = _buildSettingsCenterSnapshot(
      notificationPermissionStatus: NotificationPermissionStatus.enabled,
      preferences: const SettingsCenterPreferences(
        privacyModeEnabled: true,
        widgetDisplayMode: WidgetDisplayMode.previewOnly,
      ),
    );
    var snapshotReadCount = 0;
    final ProviderContainer container = ProviderContainer(
      overrides: [
        loadSettingsCenterSnapshotUseCaseProvider.overrideWithValue(
          LoadSettingsCenterSnapshotUseCase(
            preferencesRepository: _InMemorySettingsPreferencesRepository(
              initial: refreshedSnapshot.preferences,
            ),
            notificationRepository: _FakeNotificationPermissionRepository(
              initialStatus: refreshedSnapshot.notificationPermissionStatus,
            ),
          ),
        ),
        settingsCenterSnapshotProvider.overrideWith((ref) async {
          snapshotReadCount += 1;
          if (snapshotReadCount > 1) {
            throw StateError('unexpected second settingsCenterSnapshotProvider read');
          }
          return initialSnapshot;
        }),
      ],
    );
    addTearDown(container.dispose);

    final SettingsCenterSnapshot loadedSnapshot = await container.read(
      settingsCenterControllerProvider.future,
    );
    expect(loadedSnapshot, initialSnapshot);

    await container.read(settingsCenterControllerProvider.notifier).refresh();

    expect(snapshotReadCount, 1);
    expect(
      container.read(settingsCenterControllerProvider).requireValue,
      refreshedSnapshot,
    );
  });

  test('refresh 有旧快照时不应立刻清空数据', () async {
    final Completer<void> refreshGate = Completer<void>();
    final SettingsCenterSnapshot initialSnapshot = _buildSettingsCenterSnapshot(
      notificationPermissionStatus: NotificationPermissionStatus.disabled,
    );
    final SettingsCenterSnapshot refreshedSnapshot = _buildSettingsCenterSnapshot(
      notificationPermissionStatus: NotificationPermissionStatus.enabled,
      preferences: const SettingsCenterPreferences(
        privacyModeEnabled: true,
        widgetDisplayMode: WidgetDisplayMode.previewOnly,
      ),
    );
    var snapshotReadCount = 0;
    final ProviderContainer container = ProviderContainer(
      overrides: [
        loadSettingsCenterSnapshotUseCaseProvider.overrideWithValue(
          LoadSettingsCenterSnapshotUseCase(
            preferencesRepository: _DelayedSettingsPreferencesRepository(
              delegate: _InMemorySettingsPreferencesRepository(
                initial: refreshedSnapshot.preferences,
              ),
              gate: refreshGate.future,
            ),
            notificationRepository: _FakeNotificationPermissionRepository(
              initialStatus: refreshedSnapshot.notificationPermissionStatus,
            ),
          ),
        ),
        settingsCenterSnapshotProvider.overrideWith((ref) async {
          snapshotReadCount += 1;
          if (snapshotReadCount == 1) {
            return initialSnapshot;
          }
          await refreshGate.future;
          return refreshedSnapshot;
        }),
      ],
    );
    addTearDown(container.dispose);

    final SettingsCenterSnapshot loadedSnapshot = await container.read(
      settingsCenterControllerProvider.future,
    );
    expect(loadedSnapshot, initialSnapshot);

    final Future<void> refreshFuture = container
        .read(settingsCenterControllerProvider.notifier)
        .refresh();

    final AsyncValue<SettingsCenterSnapshot> refreshingState = container.read(
      settingsCenterControllerProvider,
    );
    expect(refreshingState.hasValue, isTrue);
    expect(refreshingState.requireValue, initialSnapshot);

    refreshGate.complete();
    await refreshFuture;

    expect(
      container.read(settingsCenterControllerProvider).requireValue,
      refreshedSnapshot,
    );
  });

  test('更新主题偏好后应同步全局 currentSettingsCenterPreferencesProvider', () async {
    final SettingsCenterSnapshot initialSnapshot = _buildSettingsCenterSnapshot();
    final settingsRepository = _InMemorySettingsPreferencesRepository(
      initial: initialSnapshot.preferences,
    );
    final ProviderContainer container = ProviderContainer(
      overrides: [
        settingsPreferencesRepositoryProvider.overrideWithValue(settingsRepository),
        notificationPermissionRepositoryProvider.overrideWithValue(
          _FakeNotificationPermissionRepository(
            initialStatus: NotificationPermissionStatus.enabled,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(settingsCenterControllerProvider.future);
    expect(
      container.read(currentSettingsCenterPreferencesProvider),
      initialSnapshot.preferences,
    );

    await container.read(settingsCenterControllerProvider.notifier).updateThemeModePreference(
      mode: SettingsThemeModePreference.dark,
      feedbackText: 'theme updated',
    );

    // 这是根应用真正消费的偏好来源，必须和设置控制器内的更新结果同步前进。
    expect(
      container.read(currentSettingsCenterPreferencesProvider).themeModePreference,
      SettingsThemeModePreference.dark,
    );
    expect(
      container
          .read(settingsCenterControllerProvider)
          .requireValue
          .preferences
          .themeModePreference,
      SettingsThemeModePreference.dark,
    );
  });
}

/// 构造测试快照，统一收口设置页控制器场景需要的最小稳定数据。
SettingsCenterSnapshot _buildSettingsCenterSnapshot({
  SettingsCenterPreferences preferences = const SettingsCenterPreferences(),
  NotificationPermissionStatus notificationPermissionStatus =
      NotificationPermissionStatus.enabled,
}) {
  return SettingsCenterSnapshot(
    notificationPermissionStatus: notificationPermissionStatus,
    preferences: preferences,
    syncStatus: SettingsSyncStatus.localOnly,
    membershipState: SettingsMembershipState.available,
  );
}

Future<void> _pumpSettingsPage(
  WidgetTester tester, {
  required SettingsPreferencesRepository preferencesRepository,
  required NotificationPermissionRepository notificationRepository,
}) async {
  _prepareTestViewport(tester);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
        notificationPermissionRepositoryProvider.overrideWithValue(
          notificationRepository,
        ),
      ],
      child: ScreenNoteScreenUtilContract(
        designSize: screenNoteDesignSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ScreenNoteTheme.light().copyWith(
              splashFactory: NoSplash.splashFactory,
            ),
            darkTheme: ScreenNoteTheme.dark().copyWith(
              splashFactory: NoSplash.splashFactory,
            ),
            home: const Scaffold(body: SettingsCenterPage()),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void _prepareTestViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// 内存偏好仓储用于页面测试，避免依赖 shared_preferences 的全局静态缓存。
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

/// 延迟仓储用于卡住 refresh 中的快照重载，验证控制器是否保留已有数据。
final class _DelayedSettingsPreferencesRepository
    implements SettingsPreferencesRepository {
  _DelayedSettingsPreferencesRepository({
    required SettingsPreferencesRepository delegate,
    required Future<void> gate,
  }) : _delegate = delegate,
       _gate = gate;

  final SettingsPreferencesRepository _delegate;
  final Future<void> _gate;

  @override
  Future<SettingsCenterPreferences> loadPreferences() async {
    await _gate;
    return _delegate.loadPreferences();
  }

  @override
  Future<void> savePreferences(SettingsCenterPreferences preferences) {
    return _delegate.savePreferences(preferences);
  }
}

/// 假通知仓储用于页面测试，允许精确控制复查前后的权限状态。
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
