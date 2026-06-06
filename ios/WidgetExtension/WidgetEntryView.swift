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
          title: snapshot.emptyTitle,
          body: snapshot.emptyBody
        )
      }
    case .list3:
      if snapshot.items.isEmpty {
        emptyView(
          title: snapshot.emptyTitle,
          body: snapshot.emptyBody
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
        title: snapshot.emptyTitle,
        body: snapshot.emptyBody
      )
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
