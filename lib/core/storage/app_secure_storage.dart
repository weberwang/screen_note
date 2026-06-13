import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_secure_storage.g.dart';

/// 敏感值存储封装，确保上层不直接依赖三方存储类型。
final class AppSecureStorage {
  /// 创建敏感值存储封装。
  AppSecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  /// 读取敏感值。
  Future<String?> read(String key) => _storage.read(key: key);

  /// 写入敏感值。
  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  /// 删除敏感值。
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// 提供全局敏感值存储封装。
@Riverpod(keepAlive: true)
AppSecureStorage appSecureStorage(Ref ref) {
  return AppSecureStorage(const FlutterSecureStorage());
}

