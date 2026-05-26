import AppIntents

/// Screen Note 快速添加系统入口。
///
/// 这个 Intent 只负责收集一句话输入与轻量默认值，然后把草稿交给主 App，
/// 由 Flutter 应用层统一回流到 `/quick-add`，而不是在扩展里直接创建事项。
struct QuickAddIntent: AppIntent {
  static var title: LocalizedStringResource = "Quick Add to Screen Note"
  static var description = IntentDescription(
    "Save a quick draft for Screen Note and return to the app to finish creation."
  )
  static var openAppWhenRun: Bool = true

  @Parameter(title: "Draft Text")
  var draftText: String?

  @Parameter(title: "Due Time")
  var dueAt: Date?

  @Parameter(title: "Pin by Default")
  var isPinned: Bool

  @Parameter(title: "Private by Default")
  var isPrivate: Bool

  /// 执行 Quick Add，只做草稿桥接。
  func perform() async throws -> some IntentResult {
    try QuickAddBridge.savePendingDraft(
      draftText: draftText,
      source: "appIntent",
      dueAt: dueAt,
      isPinned: isPinned,
      isPrivate: isPrivate
    )
    return .result()
  }
}

/// Quick Add App Intents 扩展入口。
@main
struct QuickAddIntentExtension: AppIntentsExtension {}
