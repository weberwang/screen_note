import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/app.dart';

/// 执行全局 bootstrap 入口。
///
/// 当前阶段只建立最小可运行启动链：Flutter 绑定、全局错误兜底和 ProviderScope，
/// 不在这里接入数据库、通知、Widget 真桥接等后续业务依赖。
Future<void> bootstrapAndRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureGlobalErrorHandling();
  runApp(const ProviderScope(child: ScreenNoteApp()));
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

