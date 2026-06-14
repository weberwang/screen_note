import 'package:screen_note/features/settings_center/domain/entities/widget_pin_request_result.dart';
import 'package:screen_note/features/settings_center/domain/repositories/widget_installation_repository.dart';

/// 小组件添加用例，统一承接设置页对桌面固定入口的请求。
final class RequestPinWidgetUseCase {
  /// 创建小组件添加用例。
  const RequestPinWidgetUseCase({
    required WidgetInstallationRepository repository,
  }) : _repository = repository;

  final WidgetInstallationRepository _repository;

  /// 触发桌面小组件添加请求。
  Future<WidgetPinRequestResult> execute() {
    return _repository.requestPinWidget();
  }
}
