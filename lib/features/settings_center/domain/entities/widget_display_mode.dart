/// 锁屏与 Widget 展示模式，同时兼容旧预览样式和当前设置页的两档开关。
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

  /// 仅展示安全预览，不直接暴露正文。
  previewOnly,

  /// 允许展示完整内容，但仍受隐私规则约束。
  fullContent,
}
