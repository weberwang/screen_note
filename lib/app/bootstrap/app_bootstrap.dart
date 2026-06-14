import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/bootstrap/local_notifications_bootstrap.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_bridge_runtime_providers.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/widget_snapshot_settings_side_effect_port.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/widget_snapshot_task_flow_side_effect_port.dart';

/// 执行全局 bootstrap 入口。
///
/// 当前阶段会在 runApp 前先拿到安全的 Widget 启动桥，保证桌面回流失败时也只降级到首页。
Future<void> bootstrapAndRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureGlobalErrorHandling();
  await initializeScreenNoteLocalNotifications();
  final WidgetLaunchBridge launchBridge = await loadSafeWidgetLaunchBridge();
  runApp(
    ProviderScope(
      overrides: [
        widgetLaunchBridgeProvider.overrideWithValue(launchBridge),
        defaultTaskFlowSideEffectPortProvider.overrideWith((Ref ref) {
          return WidgetSnapshotTaskFlowSideEffectPort(
            coordinator: ref.watch(widgetSnapshotAutoSyncCoordinatorProvider),
            logger: ref.watch(appLoggerProvider),
          );
        }),
        defaultSettingsSideEffectPortProvider.overrideWith((Ref ref) {
          return WidgetSnapshotSettingsSideEffectPort(
            coordinator: ref.watch(widgetSnapshotAutoSyncCoordinatorProvider),
            logger: ref.watch(appLoggerProvider),
          );
        }),
      ],
      child: const ScreenNoteApp(),
    ),
  );
}

/// 配置全局错误展示与上报入口。
///
/// 这里先提供稳定兜底，后续如果需要接真实日志上传或崩溃采集，再在同一位置扩展。
void _configureGlobalErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: const Color(0xFFFBFAF7),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            details.exceptionAsString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF1F2328)),
          ),
        ),
      ),
    );
  };
}
