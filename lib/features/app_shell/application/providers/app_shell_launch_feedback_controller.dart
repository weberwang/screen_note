import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';

part 'app_shell_launch_feedback_controller.g.dart';

/// 壳层轻反馈事件，确保外部回流结果只被壳层宿主消费一次。
final class AppShellLaunchFeedbackEvent {
  /// 创建一次性壳层轻反馈事件。
  const AppShellLaunchFeedbackEvent({
    required this.sequence,
    required this.intent,
  });

  /// 事件序号，用来区分连续相同目标的多次回流。
  final int sequence;

  /// 对应的启动解析结果。
  final AppShellLaunchIntent intent;
}

/// 壳层回流反馈控制器，只维护最近一次待消费的轻反馈事件。
@riverpod
class AppShellLaunchFeedbackController
    extends _$AppShellLaunchFeedbackController {
  int _sequence = 0;

  @override
  AppShellLaunchFeedbackEvent? build() => null;

  /// 记录一次新的启动回流结果，交给壳层统一展示轻反馈。
  void record(AppShellLaunchIntent intent) {
    state = AppShellLaunchFeedbackEvent(
      sequence: ++_sequence,
      intent: intent,
    );
  }

  /// 仅在当前事件仍未被覆盖时清空，避免并发回流把新反馈误删。
  void consume(int sequence) {
    if (state?.sequence == sequence) {
      state = null;
    }
  }
}
