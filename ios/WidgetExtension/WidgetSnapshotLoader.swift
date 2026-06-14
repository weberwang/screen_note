import Foundation

/// 小组件展示模式。
///
/// Swift 侧只消费 Flutter 已经冻结好的稳定枚举值，避免原生层自行发明额外状态分支。
enum WidgetDisplayModePayload: String, Codable {
  case previewOnly
  case fullContent
}

/// 小组件快照条目。
///
/// 这里只保留 Widget 渲染所需的稳定字段，不引入完整事项实体或业务状态推导。
struct WidgetSnapshotItemPayload: Codable {
  let title: String
  let statusLabel: String
  let dueLabel: String
  let isPinned: Bool
  let isOverdue: Bool
  let isPrivate: Bool
  let taskId: String?
  let launchTarget: String?
  let rank: Int
}

/// 小组件共享快照。
///
/// 原生层仅读取这份共享快照，不直连数据库，也不在 Swift 侧重新排序或拼装隐私文案。
struct WidgetSnapshotPayload: Codable {
  let snapshotId: String
  let generatedAt: Date
  let displayMode: WidgetDisplayModePayload
  let headerTitle: String
  let emptyTitle: String
  let emptyBody: String
  let fallbackHint: String
  let items: [WidgetSnapshotItemPayload]
  let hasPrivateContent: Bool
  let hasFallbackContent: Bool
  let version: Int
}

/// 共享快照读取器。
///
/// 读取顺序优先当前快照，若为空再退回最后有效快照，保证 Widget 在读取失败时仍有机会展示稳定内容。
struct WidgetSnapshotLoader {
  static let appGroupId = "group.com.example.screenNote.shared"
  static let currentSnapshotKey = "screen_note.widget_snapshot.current"
  static let lastValidSnapshotKey = "screen_note.widget_snapshot.last_valid"
  static let supportedSnapshotVersion = 2

  /// Flutter 侧 `toIso8601String()` 默认会带毫秒；旧快照若没有毫秒也要兼容读取。
  private static let iso8601WithFractionalSeconds: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }()

  private static let iso8601WithoutFractionalSeconds: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()

  private let decoder: JSONDecoder

  init() {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let rawValue = try container.decode(String.self)

      if let date = Self.iso8601WithFractionalSeconds.date(from: rawValue) {
        return date
      }
      if let date = Self.iso8601WithoutFractionalSeconds.date(from: rawValue) {
        return date
      }

      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Unsupported ISO-8601 date: \(rawValue)"
      )
    }
    self.decoder = decoder
  }

  func loadSnapshot() -> WidgetSnapshotPayload? {
    guard let defaults = UserDefaults(suiteName: Self.appGroupId) else {
      return nil
    }

    if let snapshot = decodeSnapshot(
      defaults.string(forKey: Self.currentSnapshotKey)
    ) {
      return snapshot
    }

    return decodeSnapshot(defaults.string(forKey: Self.lastValidSnapshotKey))
  }

  private func decodeSnapshot(_ raw: String?) -> WidgetSnapshotPayload? {
    guard let raw, let data = raw.data(using: .utf8) else {
      return nil
    }

    guard
      let snapshot = try? decoder.decode(WidgetSnapshotPayload.self, from: data),
      snapshot.version == Self.supportedSnapshotVersion
    else {
      return nil
    }

    return snapshot
  }
}
