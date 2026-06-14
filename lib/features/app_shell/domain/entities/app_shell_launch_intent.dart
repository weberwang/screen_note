import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_shell_launch_intent.freezed.dart';

/// 共享壳层启动意图只负责表达根级安全落点，
/// 不负责承载任意业务模块参数或真实深链载荷。
@freezed
abstract class AppShellLaunchIntent with _$AppShellLaunchIntent {
  /// 进入首页分支。
  const factory AppShellLaunchIntent.home() = _Home;

  /// 进入历史分支。
  const factory AppShellLaunchIntent.history() = _History;

  /// 进入设置分支。
  const factory AppShellLaunchIntent.settings() = _Settings;

  /// 进入事项编辑页时，只携带稳定 taskId，避免把原始平台载荷直接透传给页面。
  const factory AppShellLaunchIntent.taskEditor({
    required String taskId,
  }) = _TaskEditor;

  /// 未识别入口统一回落到首页。
  const factory AppShellLaunchIntent.fallbackHome() = _FallbackHome;
}
