import Foundation
import WidgetKit

/// WidgetKit 时间线条目。
///
/// 时间线只承载“何时渲染”和“渲染哪份快照”，不把额外业务逻辑塞进时间线层。
struct ScreenNoteWidgetEntry: TimelineEntry {
  let date: Date
  let snapshot: WidgetSnapshotPayload?
}

/// 锁屏小组件时间线提供器。
///
/// 这里始终基于共享快照生成单条时间线，刷新节奏由 Flutter 侧写入快照后主动触发。
struct ScreenNoteWidgetTimelineProvider: TimelineProvider {
  private let loader = WidgetSnapshotLoader()

  func placeholder(in context: Context) -> ScreenNoteWidgetEntry {
    ScreenNoteWidgetEntry(
      date: Date(),
      snapshot: WidgetSnapshotPayload(
        snapshotId: "placeholder",
        generatedAt: Date(),
        displayMode: .single,
        items: [
          WidgetSnapshotItemPayload(
            title: "完成锁屏小组件验收",
            statusLabel: "置顶",
            dueLabel: "今天 18:00",
            isPinned: true,
            isOverdue: false,
            isPrivate: false,
            rank: 1
          )
        ],
        hasPrivateContent: false,
        hasFallbackContent: false,
        version: 1
      )
    )
  }

  func getSnapshot(
    in context: Context,
    completion: @escaping (ScreenNoteWidgetEntry) -> Void
  ) {
    completion(
      ScreenNoteWidgetEntry(
        date: Date(),
        snapshot: loader.loadSnapshot()
      )
    )
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<ScreenNoteWidgetEntry>) -> Void
  ) {
    let entry = ScreenNoteWidgetEntry(
      date: Date(),
      snapshot: loader.loadSnapshot()
    )
    completion(Timeline(entries: [entry], policy: .atEnd))
  }
}
