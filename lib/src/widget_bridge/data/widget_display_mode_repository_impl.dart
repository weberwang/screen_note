import 'package:shared_preferences/shared_preferences.dart';

import '../domain/enums/widget_display_mode.dart';
import '../domain/repositories/widget_display_mode_repository.dart';

/// Widget 展示模式仓储实现。
///
/// 阶段三只需持久化一个本地展示模式，因此这里用 `SharedPreferences`
/// 保存稳定枚举值，而不是让设置页直接依赖三方包。
final class WidgetDisplayModeRepositoryImpl
    implements WidgetDisplayModeRepository {
  /// 创建 Widget 展示模式仓储实现。
  WidgetDisplayModeRepositoryImpl({
    required Future<SharedPreferences> Function() preferencesLoader,
  }) : _preferencesLoader = preferencesLoader;

  /// 展示模式偏好键。
  static const String displayModeKey = 'screen_note.widget.display_mode';

  final Future<SharedPreferences> Function() _preferencesLoader;

  @override
  Future<WidgetDisplayMode> read() async {
    final SharedPreferences preferences = await _preferencesLoader();
    final String? rawMode = preferences.getString(displayModeKey);
    return _parseMode(rawMode) ?? WidgetDisplayMode.single;
  }

  @override
  Future<void> save(WidgetDisplayMode mode) async {
    final SharedPreferences preferences = await _preferencesLoader();
    await preferences.setString(displayModeKey, mode.name);
  }

  /// 解析持久化模式值。
  WidgetDisplayMode? _parseMode(String? rawMode) {
    if (rawMode == null || rawMode.isEmpty) {
      return null;
    }

    for (final WidgetDisplayMode mode in WidgetDisplayMode.values) {
      if (mode.name == rawMode) {
        return mode;
      }
    }

    return null;
  }
}
