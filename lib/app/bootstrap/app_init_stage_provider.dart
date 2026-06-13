import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_init_stage_provider.g.dart';

/// 当前 Provider 只用于验证初始化阶段的 Riverpod 生成链，
/// 不代表应用已经进入真实启动、注入或路由装配阶段。
@Riverpod(keepAlive: true)
String appInitStage(Ref ref) {
  return 'bootstrap_code';
}
