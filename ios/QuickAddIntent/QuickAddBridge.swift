import Foundation

/// Quick Add 系统入口共享桥接。
///
/// 原生入口只负责把草稿写进 App Group，让主 App 冷启动后统一消费，
/// 不直接创建事项，也不在扩展里承载业务状态流转。
enum QuickAddBridge {
  static let appGroupId = "group.com.example.screenNote.shared"
  static let pendingDraftStorageKey = "screen_note.quick_add.intent_payload"

  /// 保存一份待主 App 消费的快速添加草稿。
  static func savePendingDraft(
    draftText: String?,
    source: String,
    dueAt: Date?,
    isPinned: Bool,
    isPrivate: Bool
  ) throws {
    guard let defaults = UserDefaults(suiteName: appGroupId) else {
      throw QuickAddBridgeError.appGroupUnavailable
    }

    let timestamp = ISO8601DateFormatter().string(from: Date())
    let payload: [String: Any?] = [
      "draftText": draftText ?? "",
      "source": source,
      "dueAt": dueAt.map { ISO8601DateFormatter().string(from: $0) },
      "isPinned": isPinned,
      "isPrivate": isPrivate,
      "hasUnsavedChanges": true,
      "createdAt": timestamp,
      "updatedAt": timestamp
    ]

    let normalizedPayload = payload.reduce(into: [String: Any]()) { partialResult, item in
      if let value = item.value {
        partialResult[item.key] = value
      } else {
        partialResult[item.key] = NSNull()
      }
    }

    let data = try JSONSerialization.data(withJSONObject: normalizedPayload)
    guard let raw = String(data: data, encoding: .utf8) else {
      throw QuickAddBridgeError.encodingFailed
    }

    defaults.set(raw, forKey: pendingDraftStorageKey)
  }
}

/// Quick Add 系统入口桥接错误。
enum QuickAddBridgeError: Error {
  case appGroupUnavailable
  case encodingFailed
}
