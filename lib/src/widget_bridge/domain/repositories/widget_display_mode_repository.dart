import '../enums/widget_display_mode.dart';

/// Widget 展示模式仓储。
///
/// 阶段三只保存一个本地展示模式选择，避免设置页直接依赖底层偏好存储。
abstract interface class WidgetDisplayModeRepository {
  /// 读取当前展示模式。
  Future<WidgetDisplayMode> read();

  /// 保存当前展示模式。
  Future<void> save(WidgetDisplayMode mode);
}
