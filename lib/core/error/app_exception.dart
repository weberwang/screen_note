/// 统一定义基础异常类型，避免后续在公共层散落裸 `Exception` 字符串。
sealed class AppException implements Exception {
  /// 创建基础异常。
  const AppException(this.message);

  /// 面向日志和调试的异常说明。
  final String message;

  @override
  String toString() => 'AppException(message: $message)';
}

/// 表示当前公共基线尚未接入真实能力时的占位异常。
final class AppUnimplementedException extends AppException {
  /// 创建占位异常。
  const AppUnimplementedException(super.message);
}

