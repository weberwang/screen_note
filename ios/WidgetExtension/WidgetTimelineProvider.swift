import Foundation
import WidgetKit

/// WidgetKit 时间线条目。
///
/// 时间线只承载“何时渲染”和“渲染哪份快照”，不把额外业务逻辑塞进时间线层。
struct ScreenNoteWidgetEntry: TimelineEntry {
  let date: Date
  let snapshot: WidgetSnapshotPayload?
}

/// 小组件时间线提供器。
///
/// 这里始终基于共享快照生成单条时间线，刷新节奏由 Flutter 侧写入快照后主动触发。
struct ScreenNoteWidgetTimelineProvider: TimelineProvider {
  private let loader = WidgetSnapshotLoader()

  func placeholder(in context: Context) -> ScreenNoteWidgetEntry {
    ScreenNoteWidgetEntry(
      date: Date(),
      snapshot: placeholderSnapshot()
    )
  }

  func getSnapshot(
    in context: Context,
    completion: @escaping (ScreenNoteWidgetEntry) -> Void
  ) {
    completion(
      ScreenNoteWidgetEntry(
        date: Date(),
        snapshot: loader.loadSnapshot() ?? placeholderSnapshot()
      )
    )
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<ScreenNoteWidgetEntry>) -> Void
  ) {
    let entry = ScreenNoteWidgetEntry(
      date: Date(),
      snapshot: loader.loadSnapshot() ?? placeholderSnapshot()
    )
    completion(Timeline(entries: [entry], policy: .atEnd))
  }

  /// 占位快照统一承担“首帧无共享数据”时的安全展示，避免 Widget 首次渲染落成空白。
  private func placeholderSnapshot() -> WidgetSnapshotPayload {
    WidgetSnapshotPayload(
      snapshotId: "placeholder",
      generatedAt: Date(),
      displayMode: .previewOnly,
      headerTitle: "仅安全预览",
      emptyTitle: "小组件上还没有可展示的事项",
      emptyBody: "新增事项后，这里会读取下一次稳定快照。",
      fallbackHint: "保留最后一次有效快照",
      items: [
        WidgetSnapshotItemPayload(
          title: "预览内容已隐藏",
          statusLabel: "安全预览",
          dueLabel: "点按后回到应用查看",
          isPinned: true,
          isOverdue: false,
          isPrivate: false,
          taskId: nil,
          launchTarget: "home",
          rank: 1
        )
      ],
      hasPrivateContent: false,
      hasFallbackContent: false,
      version: 2
    )
  }
}
