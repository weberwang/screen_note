import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preferences.g.dart';

/// 轻量偏好封装，负责把 `shared_preferences` 限定在公共基础设施边界。
final class AppPreferences {
  /// 创建偏好封装。
  AppPreferences(this._preferences);

  final SharedPreferences _preferences;

  /// 读取布尔偏好值。
  bool? getBool(String key) => _preferences.getBool(key);

  /// 写入布尔偏好值。
  Future<bool> setBool(String key, bool value) => _preferences.setBool(key, value);
}

/// 异步创建轻量偏好实例。
@Riverpod(keepAlive: true)
Future<AppPreferences> appPreferences(Ref ref) async {
  final preferences = await SharedPreferences.getInstance();
  return AppPreferences(preferences);
}

