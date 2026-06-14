import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:screen_note/core/config/app_environment.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_pin_request_result.dart';
import 'package:screen_note/features/settings_center/domain/repositories/widget_installation_repository.dart';

/// 小组件安装仓储实现，优先复用 home_widget 的 launcher 固定能力，不支持时安全降级。
final class HomeWidgetInstallationRepository
    implements WidgetInstallationRepository {
  /// 创建小组件安装仓储实现。
  const HomeWidgetInstallationRepository();

  static const String _qualifiedAndroidWidgetName =
      '${AppEnvironment.packageId}.ScreenNoteWidgetProvider';

  @override
  Future<WidgetPinRequestResult> requestPinWidget() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return WidgetPinRequestResult.unsupported;
    }

    try {
      final bool? supported = await HomeWidget.isRequestPinWidgetSupported();
      if (supported != true) {
        return WidgetPinRequestResult.unsupported;
      }

      // 这里使用完整限定名，避免 launcher 在多入口环境下找不到目标 Provider。
      await HomeWidget.requestPinWidget(
        qualifiedAndroidName: _qualifiedAndroidWidgetName,
      );
      return WidgetPinRequestResult.requested;
    } on MissingPluginException {
      return WidgetPinRequestResult.failed;
    } on PlatformException {
      return WidgetPinRequestResult.failed;
    } catch (_) {
      return WidgetPinRequestResult.failed;
    }
  }
}
