import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/core/storage/app_preferences.dart';
import 'package:screen_note/core/storage/app_secure_storage.dart';

/// 应用启动预热器，负责把全局依赖初始化集中在一个地方。
final class AppStartup {
  /// 创建应用启动预热器。
  const AppStartup();

  /// 预热轻量存储、时区和安全存储等基础设施。
  Future<void> initialize() async {
    final AppPreferences preferences = AppPreferences();
    await preferences.ensureInitialized();
    try {
      await initializeLocalTimezone();
    } catch (error, stackTrace) {
      // 启动阶段平台时区能力失败时只允许降级，不能阻断应用主链路。
      AppLogger.instance.warning(
        'initialize_local_timezone_failed',
        error: error,
        stackTrace: stackTrace,
      );
    }

    try {
      await const AppSecureStorage().warmUp();
    } catch (error, stackTrace) {
      // 安全存储预热只用于提早暴露平台问题，失败时保留日志并继续启动。
      AppLogger.instance.warning(
        'warm_up_secure_storage_failed',
        error: error,
        stackTrace: stackTrace,
      );
    }

    AppLogger.instance.info('app_startup_completed');
  }
}
