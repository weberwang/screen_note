import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'bootstrap_probe_api.g.dart';

/// 初始化阶段的 Retrofit 模板接口，后续真实远程能力应在 feature 内扩展具体契约。
@RestApi()
abstract class BootstrapProbeApi {
  /// 创建初始化探针接口。
  factory BootstrapProbeApi(Dio dio, {String? baseUrl}) = _BootstrapProbeApi;

  /// 仅保留最小探活契约，用来验证 `dio + retrofit` 代码生成链可用。
  @GET('/health')
  Future<void> healthCheck();
}
