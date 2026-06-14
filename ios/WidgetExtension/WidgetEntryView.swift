import SwiftUI
import WidgetKit

/// 小组件内容视图。
///
/// 视图只按共享快照和当前 family 渲染固定结构，不在原生侧重排任务或重做隐私判断。
struct ScreenNoteWidgetEntryView: View {
  @Environment(\.widgetFamily) private var family

  let entry: ScreenNoteWidgetEntry

  var body: some View {
    let snapshot = entry.snapshot

    widgetBackground {
      VStack(alignment: .leading, spacing: 6) {
        Text(snapshot?.headerTitle ?? " ")
          .font(.caption2.weight(.semibold))
          .foregroundStyle(.secondary)

        if let snapshot {
          content(for: snapshot)
        } else {
          emptyView(
            title: " ",
            body: " "
          )
        }

        if snapshot?.hasFallbackContent == true {
          Text(snapshot?.fallbackHint ?? " ")
            .font(.caption2)
            .foregroundStyle(.secondary)
            .lineLimit(1)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding(12)
      .widgetURL(widgetTapURL(for: snapshot))
    }
  }

  /// `containerBackground` 仅在 iOS 17+ 可用；16.x 目标上回退到普通背景，避免扩展无法编译。
  @ViewBuilder
  private func widgetBackground<Content: View>(
    @ViewBuilder content: () -> Content
  ) -> some View {
    let container = content()

    if #available(iOSApplicationExtension 17.0, *) {
      container.containerBackground(.fill.tertiary, for: .widget)
    } else {
      container
        .background(.tertiary)
    }
  }

  /// 条目跳转以共享快照里的 `launchTarget` 为准，只有明确标成 task 才尝试进入事项。
  private func destinationURL(for item: WidgetSnapshotItemPayload) -> URL {
    switch normalizedLaunchTarget(item.launchTarget) {
    case "task":
      guard
        let taskId = item.taskId?.trimmingCharacters(in: .whitespacesAndNewlines),
        !taskId.isEmpty
      else {
        return homeURL
      }

      var components = URLComponents()
      components.scheme = "screennote"
      components.host = "launch"
      components.queryItems = [
        URLQueryItem(name: "source", value: "widget"),
        URLQueryItem(name: "target", value: "task"),
        URLQueryItem(name: "taskId", value: taskId),
      ]
      return components.url ?? homeURL
    default:
      return homeURL
    }
  }

  /// 对未知目标统一按首页处理，避免原生侧擅自扩展更多导航语义。
  private func normalizedLaunchTarget(_ rawTarget: String?) -> String {
    let target = rawTarget?
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .lowercased()
    return target == "task" ? "task" : "home"
  }

  /// 单条卡片 family 让整卡点击与首条事项保持一致；多条列表仍保留逐行点击。
  private func widgetTapURL(for snapshot: WidgetSnapshotPayload?) -> URL {
    guard let firstItem = snapshot?.items.first else {
      return homeURL
    }

    switch family {
    case .systemSmall, .accessoryRectangular:
      return destinationURL(for: firstItem)
    default:
      return homeURL
    }
  }

  /// 共享快照已经冻结好展示字段，这里只做稳定拼接，不在 Swift 层重新推导业务含义。
  private func itemSubtitle(for item: WidgetSnapshotItemPayload) -> String {
    [item.statusLabel, item.dueLabel]
      .filter { !$0.isEmpty }
      .joined(separator: " · ")
  }

  private var homeURL: URL {
    var components = URLComponents()
    components.scheme = "screennote"
    components.host = "launch"
    components.queryItems = [
      URLQueryItem(name: "source", value: "widget"),
      URLQueryItem(name: "target", value: "home"),
    ]
    return components.url!
  }

  @ViewBuilder
  private func content(for snapshot: WidgetSnapshotPayload) -> some View {
    if snapshot.items.isEmpty {
      emptyView(
        title: snapshot.emptyTitle,
        body: snapshot.emptyBody
      )
    } else {
      switch family {
      case .systemMedium:
        mediumContent(snapshot.items)
      case .systemSmall:
        singleItemContent(snapshot.items[0])
      case .accessoryRectangular:
        accessoryContent(snapshot.items[0])
      default:
        singleItemContent(snapshot.items[0])
      }
    }
  }

  @ViewBuilder
  private func accessoryContent(_ item: WidgetSnapshotItemPayload) -> some View {
    Link(destination: destinationURL(for: item)) {
      itemRow(item, emphasizesTitle: false)
    }
  }

  @ViewBuilder
  private func singleItemContent(_ item: WidgetSnapshotItemPayload) -> some View {
    Link(destination: destinationURL(for: item)) {
      itemRow(item, emphasizesTitle: true)
    }
  }

  @ViewBuilder
  private func mediumContent(_ items: [WidgetSnapshotItemPayload]) -> some View {
    let visibleItems = Array(items.prefix(3))

    VStack(alignment: .leading, spacing: 8) {
      ForEach(Array(visibleItems.enumerated()), id: \.offset) { indexedItem in
        let index = indexedItem.offset
        let item = indexedItem.element

        Link(destination: destinationURL(for: item)) {
          itemRow(item, emphasizesTitle: index == 0)
        }

        if index < visibleItems.count - 1 {
          Divider()
        }
      }
    }
  }

  @ViewBuilder
  private func itemRow(
    _ item: WidgetSnapshotItemPayload,
    emphasizesTitle: Bool
  ) -> some View {
    HStack(alignment: .top, spacing: 8) {
      VStack(alignment: .leading, spacing: 2) {
        Text(item.title)
          .font(emphasizesTitle ? .caption.weight(.semibold) : .caption2.weight(.semibold))
          .lineLimit(2)
          .multilineTextAlignment(.leading)

        if !item.statusLabel.isEmpty || !item.dueLabel.isEmpty {
          Text(itemSubtitle(for: item))
            .font(.caption2)
            .foregroundStyle(.secondary)
            .lineLimit(1)
        }
      }

      Spacer(minLength: 4)

      Text("\(item.rank)")
        .font(.caption2.weight(.bold))
        .foregroundStyle(.secondary)
    }
  }

  @ViewBuilder
  private func emptyView(title: String, body: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.caption.weight(.semibold))
      Text(body)
        .font(.caption2)
        .foregroundStyle(.secondary)
        .lineLimit(2)
    }
  }

}
