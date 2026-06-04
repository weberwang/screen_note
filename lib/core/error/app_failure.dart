/// 应用层失败模型，避免页面直接依赖底层异常类型。
final class AppFailure {
  /// 创建应用层失败结果。
  const AppFailure({
    required this.code,
    required this.message,
    this.isRetryable = false,
  });

  /// 失败码，便于状态层做条件分支。
  final String code;

  /// 页面最终可决定是否把这段信息翻译为用户文案。
  final String message;

  /// 标记是否适合重试，方便后续统一接到刷新或重试入口。
  final bool isRetryable;
}
