/// 应用基础异常模型，统一承接基础设施层向上抛出的可分类异常。
final class AppException implements Exception {
  /// 创建应用异常。
  const AppException({required this.code, required this.message, this.cause});

  /// 稳定错误码，供上层做分流或日志聚合。
  final String code;

  /// 面向开发排障的异常说明。
  final String message;

  /// 原始异常对象，用于保留底层上下文。
  final Object? cause;

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}
