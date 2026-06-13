/// 统一定义公共失败模型，后续由应用层把异常映射成更稳定的失败语义。
sealed class AppFailure {
  /// 创建失败对象。
  const AppFailure(this.message);

  /// 可用于日志和提示映射的失败说明。
  final String message;
}

/// 表示初始化阶段可恢复的公共失败。
final class AppRecoverableFailure extends AppFailure {
  /// 创建可恢复失败。
  const AppRecoverableFailure(super.message);
}

