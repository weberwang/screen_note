/// 统一描述当前应用的运行环境。
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

  /// 当前未接入真实远端时保留空基地址，兼容网络层旧调用。
  static const String? apiBaseUrl = null;
}
