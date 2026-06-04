/// 事项持久状态，只允许 active、completed、deleted 三种落库值。
enum TaskStatus {
  /// 当前仍在首页主链路展示的事项。
  active,

  /// 已完成，供最近完成等下游模块消费。
  completed,

  /// 已软删除，供最近删除恢复链路消费。
  deleted,
}
