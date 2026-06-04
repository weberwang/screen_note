/// 锁屏/Widget 展示模式，先固定为 MVP 所需的几种轻量样式选择。
enum WidgetDisplayMode {
  /// 单条主事项展示。
  single,

  /// 三条列表展示。
  list3,

  /// 今日事项优先展示。
  today,

  /// 隐私优先展示。
  private,

  /// 空态说明展示。
  empty,
}
