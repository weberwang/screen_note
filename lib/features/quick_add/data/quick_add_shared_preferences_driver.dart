import 'package:shared_preferences/shared_preferences.dart';

import 'quick_add_draft_store.dart';

/// 基于 `SharedPreferences` 的快速添加草稿驱动。
///
/// 阶段四的主 App 草稿保留只需要轻量本地持久化，因此这里复用现有偏好存储，
/// 避免为了草稿引入新的数据库表或额外平台初始化成本。
final class SharedPreferencesQuickAddDraftStorageDriver
    implements QuickAddDraftStorageDriver {
  /// 创建基于 `SharedPreferences` 的快速添加草稿驱动。
  const SharedPreferencesQuickAddDraftStorageDriver({
    required Future<SharedPreferences> Function() preferencesLoader,
  }) : _preferencesLoader = preferencesLoader;

  final Future<SharedPreferences> Function() _preferencesLoader;

  @override
  Future<void> delete(String key) async {
    final SharedPreferences preferences = await _preferencesLoader();
    await preferences.remove(key);
  }

  @override
  Future<String?> readString(String key) async {
    final SharedPreferences preferences = await _preferencesLoader();
    return preferences.getString(key);
  }

  @override
  Future<void> writeString(String key, String value) async {
    final SharedPreferences preferences = await _preferencesLoader();
    await preferences.setString(key, value);
  }
}
