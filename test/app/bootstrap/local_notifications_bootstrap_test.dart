import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/app/bootstrap/local_notifications_bootstrap.dart';

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

  test('iOS 初始化不会在启动时直接申请通知权限', () async {
    final _FakeIosNotificationsPlugin fakePlugin = _FakeIosNotificationsPlugin();
    FlutterLocalNotificationsPlatform.instance = fakePlugin;
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await initializeScreenNoteLocalNotifications();

    expect(fakePlugin.initializeCallCount, 1);
    expect(fakePlugin.lastSettings, isNotNull);
    expect(fakePlugin.lastSettings!.requestAlertPermission, isFalse);
    expect(fakePlugin.lastSettings!.requestBadgePermission, isFalse);
    expect(fakePlugin.lastSettings!.requestSoundPermission, isFalse);
  });

  test('Android 初始化会注入默认通知图标配置', () async {
    final _FakeAndroidNotificationsPlugin fakePlugin =
        _FakeAndroidNotificationsPlugin();
    FlutterLocalNotificationsPlatform.instance = fakePlugin;
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await initializeScreenNoteLocalNotifications();

    expect(fakePlugin.initializeCallCount, 1);
    expect(fakePlugin.lastSettings, isNotNull);
    expect(fakePlugin.lastSettings!.defaultIcon, '@mipmap/ic_launcher');
  });
}

/// Android 假插件只记录初始化参数，避免测试触达真实平台通道。
final class _FakeAndroidNotificationsPlugin
    extends AndroidFlutterLocalNotificationsPlugin {
  int initializeCallCount = 0;
  AndroidInitializationSettings? lastSettings;

  @override
  Future<bool> initialize({
    required AndroidInitializationSettings settings,
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
    onDidReceiveBackgroundNotificationResponse,
  }) async {
    initializeCallCount += 1;
    lastSettings = settings;
    return true;
  }
}

/// iOS 假插件只记录初始化配置，确保启动阶段不会提前弹权限框。
final class _FakeIosNotificationsPlugin
    extends IOSFlutterLocalNotificationsPlugin {
  int initializeCallCount = 0;
  DarwinInitializationSettings? lastSettings;

  @override
  Future<bool?> initialize({
    required DarwinInitializationSettings settings,
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
    onDidReceiveBackgroundNotificationResponse,
  }) async {
    initializeCallCount += 1;
    lastSettings = settings;
    return true;
  }
}
