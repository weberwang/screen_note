/// 项目级环境配置，集中保存初始化阶段就能确定的常量。
final class AppEnvironment {
  /// 当前应用展示名。
  static const String appName = 'Screen Note';

  /// Android 应用包名。
  static const String androidApplicationId = 'com.example.screen_note';

  /// Apple 平台应用包名。
  static const String appleBundleId = 'com.example.screenNote';

  /// 共享 Widget 与系统入口桥接使用的 App Group。
  static const String sharedAppGroupId = 'group.com.example.screenNote.shared';

  /// 预留远程接口基地址；真实后端接入前保持空值，避免初始化阶段编造契约。
  static const String? apiBaseUrl = null;
}
