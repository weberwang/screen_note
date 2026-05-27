import 'dart:convert';
import 'dart:developer';

import 'package:home_widget/home_widget.dart';

import '../application/quick_add_draft.dart';

/// 阶段四快速添加桥接与 Widget 共享同一个 App Group。
const String screenNoteQuickAddAppGroupId = 'group.com.example.screenNote.shared';

/// 系统入口待消费草稿桥接接口。
///
/// 原生 App Intents、控制中心和 Action Button 只负责把草稿写进共享存储，
/// Flutter 主应用启动后从这里消费待处理草稿，再统一跳入 `/quick-add`。
abstract interface class QuickAddIntentBridge {
  /// 读取并消费待处理草稿。
  Future<QuickAddDraft?> consumePendingDraft();

  /// 保存一份待处理草稿。
  Future<void> savePendingDraft(QuickAddDraft draft);

  /// 清空已经消费完成的待处理草稿。
  Future<void> clearPendingDraft();
}

/// 系统入口共享存储驱动接口。
abstract interface class QuickAddIntentStorageDriver {
  /// 读取指定键的共享字符串值。
  Future<String?> readString(String key);

  /// 写入指定键的共享字符串值。
  Future<void> writeString(String key, String value);
}

/// 基于 `home_widget` 的 App Group 共享驱动。
///
/// 这里不额外引入 MethodChannel，而是直接复用项目已经接入的 App Group 能力，
/// 保持系统入口和 Widget 快照走同一种共享存储模式。
final class HomeWidgetQuickAddIntentStorageDriver
    implements QuickAddIntentStorageDriver {
  /// 创建基于 `home_widget` 的共享驱动。
  const HomeWidgetQuickAddIntentStorageDriver({
    required this.appGroupId,
  });

  final String appGroupId;

  @override
  Future<String?> readString(String key) async {
    await _ensureAppGroup();
    return HomeWidget.getWidgetData<String>(key);
  }

  @override
  Future<void> writeString(String key, String value) async {
    await _ensureAppGroup();
    final bool? saved = await HomeWidget.saveWidgetData<String>(key, value);
    if (saved != true) {
      throw StateError('save_quick_add_intent_data_failed');
    }
  }

  Future<void> _ensureAppGroup() async {
    final bool? configured = await HomeWidget.setAppGroupId(appGroupId);
    if (configured != true) {
      throw StateError('set_quick_add_app_group_failed');
    }
  }
}

/// 系统入口待处理草稿桥接实现。
final class QuickAddIntentBridgeImpl implements QuickAddIntentBridge {
  /// 创建系统入口待处理草稿桥接实现。
  QuickAddIntentBridgeImpl({
    required QuickAddIntentStorageDriver driver,
  }) : _driver = driver;

  /// 系统入口待处理草稿键。
  static const String pendingDraftStorageKey =
      'screen_note.quick_add.intent_payload';

  final QuickAddIntentStorageDriver _driver;

  @override
  Future<void> clearPendingDraft() async {
    await _driver.writeString(pendingDraftStorageKey, '');
  }

  @override
  Future<QuickAddDraft?> consumePendingDraft() async {
    final String? raw = await _driver.readString(pendingDraftStorageKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, Object?>) {
        await clearPendingDraft();
        return null;
      }
      final QuickAddDraft draft = QuickAddDraft.fromJson(decoded);
      await clearPendingDraft();
      return draft;
    } catch (error, stackTrace) {
      log(
        'Failed to decode quick add intent payload.',
        name: 'QuickAddIntentBridgeImpl',
        error: error,
        stackTrace: stackTrace,
      );
      await clearPendingDraft();
      return null;
    }
  }

  @override
  Future<void> savePendingDraft(QuickAddDraft draft) async {
    final String payload = jsonEncode(draft.toJson());
    await _driver.writeString(pendingDraftStorageKey, payload);
  }
}
