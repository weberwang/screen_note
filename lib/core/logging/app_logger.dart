import 'dart:developer' as developer;

/// 统一日志入口，避免初始化与基础设施继续散落 `print` 或匿名日志调用。
final class AppLogger {
  AppLogger._();

  /// 全局单例日志器。
  static final AppLogger instance = AppLogger._();

  /// 记录普通信息日志。
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'screen_note',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// 记录告警或错误日志。
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'screen_note.warning',
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
