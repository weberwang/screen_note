import SwiftUI
import WidgetKit

/// 锁屏小组件内容视图。
///
/// 视图只按快照里的 displayMode 渲染固定结构，不在原生侧拼接新的业务规则或查询逻辑。
struct ScreenNoteWidgetEntryView: View {
  let entry: ScreenNoteWidgetEntry

  var body: some View {
    let snapshot = entry.snapshot

    VStack(alignment: .leading, spacing: 6) {
      Text(headerTitle(for: snapshot?.displayMode ?? .empty))
        .font(.caption2.weight(.semibold))
        .foregroundStyle(.secondary)

      if let snapshot {
        content(for: snapshot)
      } else {
        emptyView(
          title: "锁屏上还没有可展示的事项",
          body: "新增事项后，这里会读取下一次稳定快照。"
        )
      }

      if snapshot?.hasFallbackContent == true {
        Text("保留最后一次有效快照")
          .font(.caption2)
          .foregroundStyle(.secondary)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding(12)
    .containerBackground(.fill.tertiary, for: .widget)
    .widgetURL(URL(string: "screennote://launch?source=widget&target=home"))
  }

  @ViewBuilder
  private func content(for snapshot: WidgetSnapshotPayload) -> some View {
    switch snapshot.displayMode {
    case .single, .today, .private:
      if let item = snapshot.items.first {
        itemRow(item)
      } else {
        emptyView(
          title: "锁屏上还没有可展示的事项",
          body: "新增事项后，这里会读取下一次稳定快照。"
        )
      }
    case .list3:
      if snapshot.items.isEmpty {
        emptyView(
          title: "锁屏上还没有可展示的事项",
          body: "新增事项后，这里会读取下一次稳定快照。"
        )
      } else {
        VStack(alignment: .leading, spacing: 4) {
          ForEach(Array(snapshot.items.prefix(3).enumerated()), id: \.offset) { _, item in
            itemRow(item)
          }
        }
      }
    case .empty:
      emptyView(
        title: "锁屏上还没有可展示的事项",
        body: "新增事项后，这里会读取下一次稳定快照。"
      )
    }
  }

  private func headerTitle(for mode: WidgetDisplayModePayload) -> String {
    switch mode {
    case .single:
      return "单条"
    case .list3:
      return "三条"
    case .today:
      return "今日"
    case .private:
      return "隐私"
    case .empty:
      return "空态"
    }
  }

  @ViewBuilder
  private func itemRow(_ item: WidgetSnapshotItemPayload) -> some View {
    HStack(alignment: .top, spacing: 8) {
      VStack(alignment: .leading, spacing: 2) {
        Text(item.title)
          .font(.caption.weight(.semibold))
          .lineLimit(2)

        if !item.statusLabel.isEmpty || !item.dueLabel.isEmpty {
          Text([item.statusLabel, item.dueLabel]
            .filter { !$0.isEmpty }
            .joined(separator: " · "))
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
