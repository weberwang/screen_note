/// 历史分区，只允许最近完成与最近删除两种展示语义。
enum HistorySection {
  /// 最近完成分区。
  completed,

  /// 最近删除分区。
  deleted;

  /// 从路由 query 中解析当前分区；非法值统一保守回退到最近完成。
  static HistorySection fromQueryValue(String? value) {
    return switch (value) {
      'deleted' => HistorySection.deleted,
      _ => HistorySection.completed,
    };
  }

  /// 返回用于路由 query 的稳定值，避免页面层散落硬编码字符串。
  String get queryValue => name;
}
