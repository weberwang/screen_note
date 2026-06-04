import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_secure_storage.g.dart';

/// 安全存储入口，供后续隐私或令牌类数据复用统一封装。
final class AppSecureStorage {
  /// 创建安全存储封装。
  const AppSecureStorage();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// 启动阶段预热一次，确保平台插件已就绪且后续能力有统一入口。
  Future<void> warmUp() async {
    await _storage.containsKey(key: '__screen_note_bootstrap__');
  }

  /// 暴露底层安全存储实例，后续应继续通过边界层而不是页面直接调用。
  FlutterSecureStorage get instance => _storage;
}

/// 应用级安全存储提供器。
@riverpod
AppSecureStorage appSecureStorage(Ref ref) {
  return const AppSecureStorage();
}
