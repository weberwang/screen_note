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
import 'package:screen_note/features/settings_center/domain/entities/widget_pin_request_result.dart';
import 'package:screen_note/features/settings_center/domain/repositories/widget_installation_repository.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

void main() {
  testWidgets('璁剧疆椤典細灞曠ず閫氱煡銆侀殣绉併€佸睍绀烘ā寮忋€佸悓姝ヤ笌浼氬憳鍒嗗尯', (tester) async {
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
    expect(find.text('Add Home Widget'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Sync & Backup'), 200);
    expect(find.text('Sync & Backup'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Membership'), 120);
    expect(find.text('Membership'), findsOneWidget);
  });

  testWidgets('iOS 涓嬬偣娣诲姞妗岄潰灏忕粍浠朵細鎵撳紑娣诲姞姝ラ寮曞', (tester) async {
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
      platform: TargetPlatform.iOS,
    );

    await tester.scrollUntilVisible(find.text('Add Home Widget'), 120);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Home Widget'));
    await tester.pumpAndSettle();

    expect(find.text('Add Home Widget'), findsNWidgets(2));
    expect(
      find.text(
        'Touch and hold the Home Screen, tap Edit, then choose Add Widget and search for Screen Note.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Android 涓嬪彲浠ヤ粠璁剧疆椤佃Е鍙戞坊鍔犲埌妗岄潰鍔ㄤ綔', (tester) async {
    _prepareTestViewport(tester);
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.enabled,
    );
    final widgetInstallationRepository = _FakeWidgetInstallationRepository(
      result: WidgetPinRequestResult.requested,
    );
    final ProviderContainer container = ProviderContainer(
      overrides: [
        settingsPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
        notificationPermissionRepositoryProvider.overrideWithValue(
          notificationRepository,
        ),
        widgetInstallationRepositoryProvider.overrideWithValue(
          widgetInstallationRepository,
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
                platform: TargetPlatform.android,
              ),
              darkTheme: ScreenNoteTheme.dark().copyWith(
                splashFactory: NoSplash.splashFactory,
                platform: TargetPlatform.android,
              ),
              home: const Scaffold(body: SettingsCenterPage()),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Add Home Widget'), 120);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Home Widget'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Home Screen'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(widgetInstallationRepository.requestCount, 1);
    expect(
      container.read(appShellUiStateControllerProvider).feedback?.text,
      'Widget request sent to the launcher.',
    );
  });

  testWidgets('鍒囨崲闅愮妯″紡浼氭洿鏂板亸濂藉苟鍐欏叆鍏变韩鍙嶉', (tester) async {
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

  testWidgets('闅愮妯″紡寮€鍚椂閫夋嫨 Full Content 浠嶄細淇濇寔 Preview Only', (
    tester,
  ) async {
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

  testWidgets('澶嶆煡閫氱煡鏉冮檺鍚庝細鏇存柊鐘舵€佸苟绉婚櫎闄嶇骇鎻愮ず', (tester) async {
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
  testWidgets('鍒囨崲涓婚鍜岃瑷€鍚庝細鍐欏叆鍋忓ソ浠撳偍', (tester) async {
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

  test('refresh 有旧快照时不应立刻清空数据', () async {
    final Completer<void> refreshGate = Completer<void>();
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
    expect(
      container.read(currentSettingsCenterPreferencesProvider),
      initialSnapshot.preferences,
    );

    await container
        .read(settingsCenterControllerProvider.notifier)
        .updateThemeModePreference(
          mode: SettingsThemeModePreference.dark,
          feedbackText: 'theme updated',
        );

    // 杩欐槸鏍瑰簲鐢ㄧ湡姝ｆ秷璐圭殑鍋忓ソ鏉ユ簮锛屽繀椤诲拰璁剧疆鎺у埗鍣ㄥ唴鐨勬洿鏂扮粨鏋滃悓姝ュ墠杩涖€?
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
  testWidgets('设置页滚动到底部时最后一个分组下方不会保留过大空白', (tester) async {
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

    // 底部只保留安全区和轻量留白，避免最后一个分组下方出现明显空洞。
    expect(viewportRect.bottom - lastPanelRect.bottom, lessThanOrEqualTo(56));
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
  WidgetInstallationRepository? widgetInstallationRepository,
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
        if (widgetInstallationRepository != null)
          widgetInstallationRepositoryProvider.overrideWithValue(
            widgetInstallationRepository,
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
            home: const Scaffold(body: SettingsCenterPage()),
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

/// 鍐呭瓨鍋忓ソ浠撳偍鐢ㄤ簬椤甸潰娴嬭瘯锛岄伩鍏嶄緷璧?shared_preferences 鐨勫叏灞€闈欐€佺紦瀛樸€?
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

/// 寤惰繜浠撳偍鐢ㄤ簬鍗′綇 refresh 涓殑蹇収閲嶈浇锛岄獙璇佹帶鍒跺櫒鏄惁淇濈暀宸叉湁鏁版嵁銆?
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

/// 鍋囬€氱煡浠撳偍鐢ㄤ簬椤甸潰娴嬭瘯锛屽厑璁哥簿纭帶鍒跺鏌ュ墠鍚庣殑鏉冮檺鐘舵€併€?
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

/// 鍋囧皬缁勪欢瀹夎浠撳偍鐢ㄤ簬楠岃瘉璁剧疆椤靛叆鍙ｄ細鎶婂姩浣滀氦缁欏簲鐢ㄥ眰鑰屼笉鏄〉闈㈢洿鎺ョ鎻掍欢銆?
final class _FakeWidgetInstallationRepository
    implements WidgetInstallationRepository {
  _FakeWidgetInstallationRepository({required this.result});

  final WidgetPinRequestResult result;
  int requestCount = 0;

  @override
  Future<WidgetPinRequestResult> requestPinWidget() async {
    requestCount += 1;
    return result;
  }
}
