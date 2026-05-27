import 'dart:convert';
import 'dart:developer';

import '../domain/models/widget_snapshot.dart';
import '../domain/repositories/widget_snapshot_store.dart';
import 'widget_snapshot_storage_driver.dart';

/// Widget 快照仓储实现。
///
/// 这里统一管理共享 JSON 键名，并保证“当前快照”和“最后有效快照”
/// 的写入语义一致，避免上层自己拼字符串或重复处理 fallback 标志。
final class WidgetSnapshotStoreImpl implements WidgetSnapshotStore {
  /// 创建 Widget 快照仓储实现。
  WidgetSnapshotStoreImpl({required WidgetSnapshotStorageDriver driver})
    : _driver = driver;

  /// 当前快照存储键。
  static const String currentSnapshotKey = 'screen_note.widget_snapshot.current';

  /// 最后有效快照存储键。
  static const String lastValidSnapshotKey =
      'screen_note.widget_snapshot.last_valid';

  final WidgetSnapshotStorageDriver _driver;

  @override
  Future<WidgetSnapshot?> read() async {
    return _readSnapshot(currentSnapshotKey);
  }

  @override
  Future<WidgetSnapshot?> readLastValid() async {
    return _readSnapshot(lastValidSnapshotKey);
  }

  @override
  Future<void> save(WidgetSnapshot snapshot) async {
    final String currentPayload = jsonEncode(snapshot.toJson());
    // fallback 标记只属于当前展示态，不能反向污染“最后有效快照”的稳定基线。
    final String lastValidPayload = jsonEncode(
      snapshot.copyWith(hasFallbackContent: false).toJson(),
    );

    await _driver.writeString(currentSnapshotKey, currentPayload);
    await _driver.writeString(lastValidSnapshotKey, lastValidPayload);
    await _driver.reloadWidget();
  }

  Future<WidgetSnapshot?> _readSnapshot(String key) async {
    final String? raw = await _driver.readString(key);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, Object?>) {
        return null;
      }
      return WidgetSnapshot.fromJson(decoded);
    } catch (error, stackTrace) {
      log(
        'Failed to decode widget snapshot for key: $key',
        name: 'WidgetSnapshotStoreImpl',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
