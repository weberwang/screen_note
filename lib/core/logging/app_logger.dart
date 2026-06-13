import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_note/core/logging/app_logger_contract.dart';

part 'app_logger.g.dart';

/// 公共日志实现统一收口 `logger` 的使用入口，
/// 避免后续 feature 直接构造各自的日志实例。
final class AppLogger implements AppLoggerContract {
  /// 创建日志实现。
  AppLogger() : _logger = Logger();

  final Logger _logger;

  @override
  Logger get rawLogger => _logger;

  /// 记录普通信息日志。
  void info(String message) {
    _logger.i(message);
  }

  /// 记录告警日志。
  void warning(String message) {
    _logger.w(message);
  }

  /// 记录错误日志。
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}

/// 根级日志 Provider，为 bootstrap 和后续 feature 提供统一日志入口。
@Riverpod(keepAlive: true)
AppLogger appLogger(Ref ref) {
  return AppLogger();
}

