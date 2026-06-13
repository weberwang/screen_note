import 'package:logger/logger.dart';

/// 日志契约只在初始化阶段锁定 `logger` 的拥有边界，
/// 后续 bootstrap 才能决定真实输出策略、格式和环境分流。
abstract interface class AppLoggerContract {
  /// 返回底层 logger 实例的访问口，避免 feature 直接决定日志实现细节。
  Logger get rawLogger;
}

