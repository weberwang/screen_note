import 'dart:convert';
import 'dart:developer';

import '../application/quick_add_draft.dart';

/// 快速添加草稿存储接口。
///
/// 后续流程层、失败回流页和系统桥接都只依赖这份抽象，
/// 不直接触碰 SharedPreferences、App Group 或其他平台持久化细节。
abstract interface class QuickAddDraftStore {
  /// 读取最近一次保留的快速添加草稿。
  Future<QuickAddDraft?> read();

  /// 保存快速添加草稿。
  Future<void> save(QuickAddDraft draft);

  /// 清空已经保留的快速添加草稿。
  Future<void> clear();
}

/// 快速添加草稿字符串驱动接口。
///
/// 这里故意只暴露最小的字符串读写能力，方便后续替换为 SharedPreferences、
/// App Group 或内存实现，同时让测试不依赖真实平台环境。
abstract interface class QuickAddDraftStorageDriver {
  /// 读取指定键对应的字符串值。
  Future<String?> readString(String key);

  /// 写入指定键对应的字符串值。
  Future<void> writeString(String key, String value);

  /// 删除指定键对应的字符串值。
  Future<void> delete(String key);
}

/// 快速添加草稿存储默认实现。
final class QuickAddDraftStoreImpl implements QuickAddDraftStore {
  /// 创建快速添加草稿存储实现。
  QuickAddDraftStoreImpl({required QuickAddDraftStorageDriver driver})
    : _driver = driver;

  /// 草稿持久化键。
  static const String draftStorageKey = 'screen_note.quick_add.draft';

  final QuickAddDraftStorageDriver _driver;

  @override
  Future<QuickAddDraft?> read() async {
    final String? raw = await _driver.readString(draftStorageKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, Object?>) {
        await _deleteCorruptedDraft();
        return null;
      }
      return QuickAddDraft.fromJson(decoded);
    } catch (error, stackTrace) {
      log(
        'Failed to decode quick add draft.',
        name: 'QuickAddDraftStoreImpl',
        error: error,
        stackTrace: stackTrace,
      );
      await _deleteCorruptedDraft();
      return null;
    }
  }

  @override
  Future<void> save(QuickAddDraft draft) async {
    final String payload = jsonEncode(draft.toJson());
    await _driver.writeString(draftStorageKey, payload);
  }

  @override
  Future<void> clear() async {
    await _driver.delete(draftStorageKey);
  }

  /// 损坏草稿会被直接清理，避免后续每次恢复都重复命中同一份脏数据。
  Future<void> _deleteCorruptedDraft() async {
    await _driver.delete(draftStorageKey);
  }
}
