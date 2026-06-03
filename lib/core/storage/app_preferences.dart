import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

part 'app_preferences.g.dart';

/// 轻量偏好存储入口，统一收口共享偏好与启动预热逻辑。
final class AppPreferences {
  SharedPreferences? _instance;

  /// 确保底层 SharedPreferences 已初始化。
  Future<void> ensureInitialized() async {
    _instance ??= await SharedPreferences.getInstance();
  }

  /// 提供稳定实例给后续轻量配置或引导状态复用。
  Future<SharedPreferences> instance() async {
    await ensureInitialized();
    return _instance!;
  }
}

/// 应用级 SharedPreferences 提供器。
@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return AppPreferences().instance();
}

/// 初始化本地时区，避免后续通知调度和时间展示落回硬编码本地时间。
Future<void> initializeLocalTimezone() async {
  tz_data.initializeTimeZones();
  final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
  final String timezoneName = timezoneInfo.identifier;

  try {
    tz.setLocalLocation(tz.getLocation(timezoneName));
  } on ArgumentError {
    // 少数设备会返回 IANA 数据库中不存在的时区名，这里退回 UTC 保证调度链不断。
    tz.setLocalLocation(tz.UTC);
  }
}
