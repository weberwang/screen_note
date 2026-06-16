import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/core/storage/app_preferences.dart';
import 'package:screen_note/core/storage/app_secure_storage.dart';

/// 应用启动预热器，负责把全局依赖初始化集中在一个地方。
final class AppStartup {
  /// 创建应用启动预热器。
  const AppStartup();

  /// 预热轻量存储与安全存储等基础设施。
  Future<void> initialize() async {
    final AppLogger logger = AppLogger();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final AppPreferences preferences = AppPreferences(sharedPreferences);
    // 这里仅触发底层实例创建，避免历史调用点依赖已删除的 ensureInitialized 旧接口。
    preferences.getBool('bootstrap.warmup');

    try {
      final secureStorage = AppSecureStorage(const FlutterSecureStorage());
      await secureStorage.read('__warmup__');
    } catch (_) {
      // 安全存储预热失败只允许降级，不能阻断应用主链路。
      logger.warning('warm_up_secure_storage_failed');
    }

    logger.info('app_startup_completed');
  }
}
