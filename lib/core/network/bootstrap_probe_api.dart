import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'bootstrap_probe_api.g.dart';

/// 这个接口只用于验证初始化阶段的 Retrofit 生成链，
/// 不能被当成真实业务后端契约。
@RestApi()
abstract class BootstrapProbeApi {
  /// 初始化阶段只保留工厂声明，真实 baseUrl 与拦截器接线留给 bootstrap 阶段。
  factory BootstrapProbeApi(Dio dio, {String baseUrl}) = _BootstrapProbeApi;

  /// 探测接口仅用于占位，后续若无远端能力，也可以整体被保留为未接线契约。
  @GET('/bootstrap-probe')
  Future<String> getBootstrapProbe();
}
