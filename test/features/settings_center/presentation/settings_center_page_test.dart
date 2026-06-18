import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/app_shell/application/providers/app_shell_ui_state.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/application/use_cases/load_settings_center_snapshot_use_case.dart';
import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_snapshot.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_membership_state.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_sync_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/features/widget_bridge/presentation/pages/widget_bridge_page.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

void main() {
  testWidgets('设置页会展示主题和语言设置项', (tester) async {
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
    expect(
      find.text(
        'Manage how Screen Note works across your device and keep your notes safe.',
      ),
      findsNothing,
    );
    await tester.scrollUntilVisible(find.text('Theme'), 120);
    expect(find.text('Theme'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Language'), 120);
    expect(find.text('Language'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('SYNC'), 160);
    expect(find.text('SYNC'), findsOneWidget);
  });

  testWidgets('隐私设置会更新偏好并写入共享反馈', (tester) async {
    _prepareTestViewport(tester);
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(privacyModeEnabled: true),
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

    await tester.scrollUntilVisible(
      find.byKey(const Key('settings-privacy-switch')),
      120,
    );
    await tester.tap(find.byKey(const Key('settings-privacy-switch')));
    await tester.pumpAndSettle();

    final stored = await preferencesRepository.loadPreferences();
    expect(stored.privacyModeEnabled, isFalse);
    expect(
      container.read(appShellUiStateControllerProvider).feedback?.text,
      'Privacy setting updated.',
    );
  });

  testWidgets('主题设置项会更新持久化偏好并写入共享反馈', (tester) async {
    _prepareTestViewport(tester);
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(
        themeModePreference: SettingsThemeModePreference.system,
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

    await tester.scrollUntilVisible(find.text('Theme'), 120);
    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    final stored = await preferencesRepository.loadPreferences();
    expect(stored.themeModePreference, SettingsThemeModePreference.dark);
    expect(
      container.read(appShellUiStateControllerProvider).feedback?.text,
      'Theme setting updated.',
    );
  });

  testWidgets('语言设置项会更新持久化偏好并同步全局语言偏好', (tester) async {
    _prepareTestViewport(tester);
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(
        languagePreference: SettingsLanguagePreference.en,
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

    await tester.scrollUntilVisible(find.text('Language'), 120);
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simplified Chinese'));
    await tester.pumpAndSettle();

    final stored = await preferencesRepository.loadPreferences();
    expect(stored.languagePreference, SettingsLanguagePreference.zh);
    expect(
      container
          .read(currentSettingsCenterPreferencesProvider)
          .languagePreference,
      SettingsLanguagePreference.zh,
    );
  });

  testWidgets('通知降级提示复查后会刷新状态', (tester) async {
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

    expect(find.text('Notifications are turned off.'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('settings-notification-switch')),
    );
    await tester.tap(find.byKey(const Key('settings-notification-switch')));
    await tester.pumpAndSettle();

    expect(find.text('Notifications are turned off.'), findsNothing);
    expect(
      container
          .read(settingsCenterControllerProvider)
          .requireValue
          .notificationPermissionStatus,
      NotificationPermissionStatus.enabled,
    );
  });

  testWidgets('关闭通知时会先弹确认框，确认后跳转系统设置', (tester) async {
    _prepareTestViewport(tester);
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.enabled,
    );
    var openSettingsCalled = false;

    await _pumpSettingsPage(
      tester,
      preferencesRepository: preferencesRepository,
      notificationRepository: notificationRepository,
      locale: const Locale('zh'),
      openAppSettingsOverride: () async {
        openSettingsCalled = true;
        return true;
      },
    );

    await tester.tap(find.byKey(const Key('settings-notification-switch')));
    await tester.pumpAndSettle();

    expect(find.text('关闭通知？'), findsOneWidget);
    expect(find.text('通知需要在系统设置中关闭，是否现在前往？'), findsOneWidget);

    await tester.tap(find.text('前往设置'));
    await tester.pumpAndSettle();

    expect(openSettingsCalled, isTrue);
  });

  testWidgets('设置页不会继续展示隐私与会员说明卡片', (tester) async {
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(privacyModeEnabled: true),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.enabled,
    );

    await _pumpSettingsPage(
      tester,
      preferencesRepository: preferencesRepository,
      notificationRepository: notificationRepository,
    );

    expect(find.text('Privacy mode is on.'), findsNothing);
    expect(find.text('You\'re using Screen Note Pro'), findsNothing);
  });

  test('refresh 不应依赖 settingsCenterSnapshotProvider 的二次失效重读', () async {
    final SettingsCenterSnapshot initialSnapshot = _buildSettingsCenterSnapshot(
      notificationPermissionStatus: NotificationPermissionStatus.disabled,
    );
    final SettingsCenterSnapshot refreshedSnapshot =
        _buildSettingsCenterSnapshot(
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
            throw StateError(
              'unexpected second settingsCenterSnapshotProvider read',
            );
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

  test('更新主题偏好后应同步全局 currentSettingsCenterPreferencesProvider', () async {
    final SettingsCenterSnapshot initialSnapshot =
        _buildSettingsCenterSnapshot();
    final settingsRepository = _InMemorySettingsPreferencesRepository(
      initial: initialSnapshot.preferences,
    );
    final ProviderContainer container = ProviderContainer(
      overrides: [
        settingsPreferencesRepositoryProvider.overrideWithValue(
          settingsRepository,
        ),
        notificationPermissionRepositoryProvider.overrideWithValue(
          _FakeNotificationPermissionRepository(
            initialStatus: NotificationPermissionStatus.enabled,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(settingsCenterControllerProvider.future);

    await container
        .read(settingsCenterControllerProvider.notifier)
        .updateThemeModePreference(
          mode: SettingsThemeModePreference.dark,
          feedbackText: 'theme updated',
        );

    expect(
      container
          .read(currentSettingsCenterPreferencesProvider)
          .themeModePreference,
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

  test('更新语言偏好后应同步全局 currentSettingsCenterPreferencesProvider', () async {
    final SettingsCenterSnapshot initialSnapshot =
        _buildSettingsCenterSnapshot();
    final settingsRepository = _InMemorySettingsPreferencesRepository(
      initial: initialSnapshot.preferences,
    );
    final ProviderContainer container = ProviderContainer(
      overrides: [
        settingsPreferencesRepositoryProvider.overrideWithValue(
          settingsRepository,
        ),
        notificationPermissionRepositoryProvider.overrideWithValue(
          _FakeNotificationPermissionRepository(
            initialStatus: NotificationPermissionStatus.enabled,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(settingsCenterControllerProvider.future);

    await container
        .read(settingsCenterControllerProvider.notifier)
        .updateLanguagePreference(
          language: SettingsLanguagePreference.en,
          feedbackText: 'language updated',
        );

    expect(
      container
          .read(currentSettingsCenterPreferencesProvider)
          .languagePreference,
      SettingsLanguagePreference.en,
    );
    expect(
      container
          .read(settingsCenterControllerProvider)
          .requireValue
          .preferences
          .languagePreference,
      SettingsLanguagePreference.en,
    );
  });

  testWidgets('设置页滚动到底部时不会留下过大空白', (tester) async {
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
      locale: const Locale('zh'),
      viewportSize: const Size(600, 844),
    );

    await tester.scrollUntilVisible(find.byType(ScreenNotePanel).last, 200);
    await tester.pumpAndSettle();

    final ScrollableState scrollableState = tester.state(
      find.byType(Scrollable),
    );
    scrollableState.position.jumpTo(scrollableState.position.maxScrollExtent);
    await tester.pumpAndSettle();

    final Rect lastPanelRect = tester.getRect(
      find.byType(ScreenNotePanel).last,
    );
    final Rect viewportRect = tester.getRect(find.byType(Scrollable));

    expect(viewportRect.bottom - lastPanelRect.bottom, lessThanOrEqualTo(56));
  });

  testWidgets('设置页会导航到小组件页', (tester) async {
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.enabled,
    );

    _prepareTestViewport(tester);
    final GoRouter router = GoRouter(
      initialLocation: RoutePaths.settings,
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.settings,
          builder: (context, state) =>
              const Scaffold(body: SettingsCenterPage()),
        ),
        GoRoute(
          path: RoutePaths.widgetBridge,
          builder: (context, state) => const Scaffold(body: WidgetBridgePage()),
        ),
      ],
    );
    addTearDown(router.dispose);

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
            return MaterialApp.router(
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ScreenNoteTheme.light(),
              darkTheme: ScreenNoteTheme.dark(),
              routerConfig: router,
            );
          },
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.scrollUntilVisible(find.text('Add Home Widget'), 120);
    await tester.tap(find.text('Add Home Widget'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(WidgetBridgePage), findsOneWidget);
  });
}

/// 构造测试快照，统一提供设置页控制器所需的最小稳定数据。
SettingsCenterSnapshot _buildSettingsCenterSnapshot({
  SettingsCenterPreferences preferences = const SettingsCenterPreferences(),
  NotificationPermissionStatus notificationPermissionStatus =
      NotificationPermissionStatus.enabled,
}) {
  return SettingsCenterSnapshot(
    notificationPermissionStatus: notificationPermissionStatus,
    preferences: preferences,
    syncStatus: SettingsSyncStatus.synced,
    membershipState: SettingsMembershipState.active,
  );
}

Future<void> _pumpSettingsPage(
  WidgetTester tester, {
  required SettingsPreferencesRepository preferencesRepository,
  required NotificationPermissionRepository notificationRepository,
  Future<bool> Function()? openAppSettingsOverride,
  TargetPlatform platform = TargetPlatform.android,
  Locale locale = const Locale('en'),
  Size viewportSize = const Size(390, 844),
}) async {
  _prepareTestViewport(tester, viewportSize: viewportSize);

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
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ScreenNoteTheme.light().copyWith(
              splashFactory: NoSplash.splashFactory,
              platform: platform,
            ),
            darkTheme: ScreenNoteTheme.dark().copyWith(
              splashFactory: NoSplash.splashFactory,
              platform: platform,
            ),
            home: Scaffold(
              body: SettingsCenterPage(
                openAppSettingsOverride: openAppSettingsOverride,
              ),
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void _prepareTestViewport(
  WidgetTester tester, {
  Size viewportSize = const Size(390, 844),
}) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = viewportSize;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// 内存偏好仓储只服务设置页测试，避免引入 shared_preferences。
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

/// 延迟偏好仓储用于覆盖 refresh 期间的异步重读场景。
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

/// 假通知权限仓储用于控制设置页里的权限状态与复查结果。
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
