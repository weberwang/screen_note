/// 统一描述当前应用的运行环境。
///
/// 目前项目仍是本地优先 MVP，因此环境对象只暴露最小常量，
/// 不引入 flavor、远端配置或密钥装配。
final class AppEnvironment {
  /// 创建环境对象。
  const AppEnvironment._();

  /// 当前应用包名。
  static const String packageId = 'com.example.screen_note';

  /// 当前环境标识。
  static const String environmentName = 'local-only-mvp';

  /// iOS Widget 与快捷入口共用的 App Group 标识。
  static const String sharedAppGroupId = 'group.com.example.screenNote.shared';

  /// 当前是否为生产模式。
  static const bool isProduction = false;
}
