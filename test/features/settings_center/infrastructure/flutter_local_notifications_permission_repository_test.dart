import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/infrastructure/flutter_local_notifications_permission_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  FlutterLocalNotificationsPlatform? originalPlatform;

  setUp(() {
    try {
      originalPlatform = FlutterLocalNotificationsPlatform.instance;
    } catch (_) {
      originalPlatform = null;
    }
  });

  tearDown(() {
    if (originalPlatform != null) {
      FlutterLocalNotificationsPlatform.instance = originalPlatform!;
    }
    debugDefaultTargetPlatformOverride = null;
  });

  test('Android 已开启通知时会映射为 enabled', () async {
    final _FakeAndroidNotificationsPlugin fakePlugin =
        _FakeAndroidNotificationsPlugin(
          notificationsEnabled: true,
          requestResult: true,
        );
    FlutterLocalNotificationsPlatform.instance = fakePlugin;
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final repository = FlutterLocalNotificationsPermissionRepository(
      plugin: FlutterLocalNotificationsPlugin(),
    );

    final NotificationPermissionStatus status = await repository.readStatus();

    expect(status, NotificationPermissionStatus.enabled);
  });

  test('Android 请求权限后仍不可用时会保持 disabled', () async {
    final _FakeAndroidNotificationsPlugin fakePlugin =
        _FakeAndroidNotificationsPlugin(
          notificationsEnabled: false,
          requestResult: false,
        );
    FlutterLocalNotificationsPlatform.instance = fakePlugin;
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final repository = FlutterLocalNotificationsPermissionRepository(
      plugin: FlutterLocalNotificationsPlugin(),
    );

    final NotificationPermissionStatus status =
        await repository.requestPermission();

    expect(status, NotificationPermissionStatus.disabled);
  });

  test('iOS 权限不可读取时会降级为 unknown', () async {
    final _FakeIosNotificationsPlugin fakePlugin = _FakeIosNotificationsPlugin(
      currentOptions: null,
      requestResult: null,
    );
    FlutterLocalNotificationsPlatform.instance = fakePlugin;
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final repository = FlutterLocalNotificationsPermissionRepository(
      plugin: FlutterLocalNotificationsPlugin(),
    );

    final NotificationPermissionStatus status = await repository.readStatus();

    expect(status, NotificationPermissionStatus.unknown);
  });

  test('macOS 请求权限成功后会复读为 enabled', () async {
    final _FakeMacOsNotificationsPlugin fakePlugin =
        _FakeMacOsNotificationsPlugin(
          currentOptions: const NotificationsEnabledOptions(
            isEnabled: false,
            isSoundEnabled: false,
            isAlertEnabled: false,
            isBadgeEnabled: false,
            isProvisionalEnabled: false,
            isCriticalEnabled: false,
            isProvidesAppNotificationSettingsEnabled: false,
          ),
          requestResult: const NotificationsEnabledOptions(
            isEnabled: true,
            isSoundEnabled: true,
            isAlertEnabled: true,
            isBadgeEnabled: true,
            isProvisionalEnabled: false,
            isCriticalEnabled: false,
            isProvidesAppNotificationSettingsEnabled: false,
          ),
        );
    FlutterLocalNotificationsPlatform.instance = fakePlugin;
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    final repository = FlutterLocalNotificationsPermissionRepository(
      plugin: FlutterLocalNotificationsPlugin(),
    );

    final NotificationPermissionStatus status =
        await repository.requestPermission();

    expect(status, NotificationPermissionStatus.enabled);
  });
}

/// Android 假插件用于控制通知开关读取与请求结果，不依赖真实系统权限。
final class _FakeAndroidNotificationsPlugin
    extends AndroidFlutterLocalNotificationsPlugin {
  _FakeAndroidNotificationsPlugin({
    required this.notificationsEnabled,
    required this.requestResult,
  });

  bool? notificationsEnabled;
  final bool? requestResult;

  @override
  Future<bool?> areNotificationsEnabled() async => notificationsEnabled;

  @override
  Future<bool?> requestNotificationsPermission() async {
    notificationsEnabled = requestResult;
    return requestResult;
  }
}

/// iOS 假插件用于控制 Darwin 权限快照，验证仓储映射逻辑。
final class _FakeIosNotificationsPlugin
    extends IOSFlutterLocalNotificationsPlugin {
  _FakeIosNotificationsPlugin({
    required this.currentOptions,
    required this.requestResult,
  });

  NotificationsEnabledOptions? currentOptions;
  final NotificationsEnabledOptions? requestResult;

  @override
  Future<NotificationsEnabledOptions?> checkPermissions() async {
    return currentOptions;
  }

  @override
  Future<bool?> requestPermissions({
    bool sound = false,
    bool alert = false,
    bool badge = false,
    bool provisional = false,
    bool critical = false,
    bool carPlay = false,
    bool providesAppNotificationSettings = false,
  }) async {
    currentOptions = requestResult;
    return requestResult?.isEnabled;
  }
}

/// macOS 假插件复用 Darwin 权限模型，验证复查后状态会回读最新结果。
final class _FakeMacOsNotificationsPlugin
    extends MacOSFlutterLocalNotificationsPlugin {
  _FakeMacOsNotificationsPlugin({
    required this.currentOptions,
    required this.requestResult,
  });

  NotificationsEnabledOptions? currentOptions;
  final NotificationsEnabledOptions? requestResult;

  @override
  Future<NotificationsEnabledOptions?> checkPermissions() async {
    return currentOptions;
  }

  @override
  Future<bool?> requestPermissions({
    bool sound = false,
    bool alert = false,
    bool badge = false,
    bool provisional = false,
    bool critical = false,
    bool providesAppNotificationSettings = false,
  }) async {
    currentOptions = requestResult;
    return requestResult?.isEnabled;
  }
}
