import SwiftUI
import WidgetKit

/// iOS 小组件定义。
///
/// kind 必须与 Flutter 侧触发 HomeWidget.updateWidget 时传入的 iOSName 保持一致。
@main
struct ScreenNoteLockScreenWidget: Widget {
  let kind: String = "ScreenNoteLockScreenWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: kind,
      provider: ScreenNoteWidgetTimelineProvider()
    ) { entry in
      ScreenNoteWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Screen Note")
    .description("展示主应用生成的稳定事项快照。")
    .supportedFamilies([.accessoryRectangular, .systemSmall, .systemMedium])
  }
}
