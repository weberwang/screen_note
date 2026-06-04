import 'package:flutter/widgets.dart';

import 'package:screen_note/app/startup/app_startup.dart';

/// 统一承接 Flutter 绑定与基础依赖预热，避免入口文件继续堆叠启动细节。
Future<void> bootstrap({required Widget child}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await const AppStartup().initialize();
  runApp(child);
}
