import 'package:screen_note/app/bootstrap/app_bootstrap.dart';

/// 应用主入口只负责把控制权交给 bootstrap 阶段，
/// 避免在这里散落真实路由、主题或依赖装配逻辑。
Future<void> main() async {
  await bootstrapAndRunApp();
}

