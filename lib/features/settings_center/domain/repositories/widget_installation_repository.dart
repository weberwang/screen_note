import 'package:screen_note/features/settings_center/domain/entities/widget_pin_request_result.dart';

/// 小组件安装仓储统一屏蔽设置页对桌面 launcher 与插件能力的直接依赖。
abstract interface class WidgetInstallationRepository {
  /// 触发添加桌面小组件动作，并返回当前平台可给设置页消费的最小结果。
  Future<WidgetPinRequestResult> requestPinWidget();
}
