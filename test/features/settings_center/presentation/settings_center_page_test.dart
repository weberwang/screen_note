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
    expect(find.text('NOTIFICATIONS'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('PRIVACY'), 120);
    expect(find.text('PRIVACY'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('WIDGET'), 120);
    expect(find.text('WIDGET'), findsOneWidget);
    expect(find.text('Theme'), findsNothing);
    expect(find.text('Language'), findsNothing);
    expect(find.text('Add Home Widget'), findsNothing);
    await tester.scrollUntilVisible(find.text('SYNC'), 200);
    expect(find.text('SYNC'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('MEMBERSHIP'), 120);
    expect(find.text('MEMBERSHIP'), findsOneWidget);
  });

  testWidgets('隐私分区会显示截图定义的安全说明块', (tester) async {
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

    await tester.scrollUntilVisible(find.text('Privacy Mode'), 120);

    expect(find.text('Privacy mode is on.'), findsOneWidget);
    expect(
      find.text('Previews are blurred in recents and widgets.'),
      findsOneWidget,
    );
    expect(find.text('Learn more'), findsOneWidget);
  });

  testWidgets('隐私分区使用状态值行而不是原生开关', (tester) async {
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

    await tester.scrollUntilVisible(find.text('Privacy Mode'), 120);

    expect(find.byType(Switch), findsNothing);
    expect(find.text('On'), findsOneWidget);
  });

  testWidgets('同步与会员分区会按截图显示 Synced 和 Active', (tester) async {
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

    await tester.scrollUntilVisible(find.text('Sync Status'), 160);
    expect(find.text('Synced'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Screen Note Pro'), 160);
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('设置页主要文本会优先保持单行显示', (tester) async {
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(privacyModeEnabled: true),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.disabled,
    );

    await _pumpSettingsPage(
      tester,
      preferencesRepository: preferencesRepository,
      notificationRepository: notificationRepository,
    );

    _expectSingleLineText(
      tester,
      'Settings Center',
      expectedOverflow: TextOverflow.ellipsis,
    );
    _expectSingleLineText(
      tester,
      'Manage how Screen Note works across your device and keep your notes safe.',
      expectedOverflow: TextOverflow.ellipsis,
    );
    _expectSingleLineText(
      tester,
      'Notification Status',
      expectedOverflow: TextOverflow.ellipsis,
    );
    _expectSingleLineText(
      tester,
      'Stay updated on saves and sync activity.',
      expectedOverflow: TextOverflow.ellipsis,
    );

    await tester.scrollUntilVisible(find.text('Privacy mode is on.'), 120);

    _expectSingleLineText(
      tester,
      'Privacy mode is on.',
      expectedOverflow: TextOverflow.ellipsis,
    );
    _expectSingleLineText(
      tester,
      'Previews are blurred in recents and widgets.',
      expectedOverflow: TextOverflow.ellipsis,
    );

    await tester.scrollUntilVisible(find.text('Synced'), 160);
    _expectSingleLineText(
      tester,
      'Synced',
      expectedOverflow: TextOverflow.ellipsis,
    );

    await tester.scrollUntilVisible(find.text("You're using Screen Note Pro"), 160);
    _expectSingleLineText(
      tester,
      "You're using Screen Note Pro",
      expectedOverflow: TextOverflow.ellipsis,
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

    expect(find.text('Notifications are turned off.'), findsOneWidget);

    await tester.ensureVisible(find.text('Enable'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enable'));
    await tester.pump();
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
  testWidgets('会员分区会显示截图定义的次级说明块', (tester) async {
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

    await tester.scrollUntilVisible(find.text('Screen Note Pro'), 180);

    expect(find.text("You're using Screen Note Pro"), findsOneWidget);
    expect(
      find.text(
        'Thank you for supporting a focused and private note-taking experience.',
      ),
      findsOneWidget,
    );
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
    syncStatus: SettingsSyncStatus.synced,
    membershipState: SettingsMembershipState.active,
  );
}

Future<void> _pumpSettingsPage(
  WidgetTester tester, {
  required SettingsPreferencesRepository preferencesRepository,
  required NotificationPermissionRepository notificationRepository,
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

/// 断言关键文本节点启用单行与省略策略，避免页面文字再次撑高布局。
void _expectSingleLineText(
  WidgetTester tester,
  String text, {
  required TextOverflow expectedOverflow,
}) {
  final Text widget = tester.widget<Text>(find.text(text).first);
  expect(widget.maxLines, 1);
  expect(widget.overflow, expectedOverflow);
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

