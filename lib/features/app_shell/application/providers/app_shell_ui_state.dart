import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_shell_ui_state.freezed.dart';
part 'app_shell_ui_state.g.dart';

/// 共享壳层反馈等级只描述展示语气，便于后续区分普通提示与降级提示。
enum AppShellFeedbackLevel { info, warning, degradation }

/// 共享壳层反馈消息用于承载轻量提示，避免壳层直接承接复杂交互协议。
@freezed
abstract class AppShellFeedbackMessage with _$AppShellFeedbackMessage {
  /// 创建一条共享壳层反馈消息。
  const factory AppShellFeedbackMessage({
    required AppShellFeedbackLevel level,
    required String text,
  }) = _AppShellFeedbackMessage;
}

/// 共享壳层 UI 状态只承载跨页面共享的轻量反馈。
@freezed
abstract class AppShellUiState with _$AppShellUiState {
  /// 创建共享壳层 UI 状态快照。
  const factory AppShellUiState({
    @Default(false) bool quickAddSheetOpen,
    AppShellFeedbackMessage? feedback,
  }) = _AppShellUiState;
}

/// 共享壳层 UI 状态控制器负责维护全局轻量反馈状态。
@Riverpod(keepAlive: true)
class AppShellUiStateController extends _$AppShellUiStateController {
  /// 构建共享壳层默认 UI 状态。
  @override
  AppShellUiState build() => const AppShellUiState();

  /// 展示一条共享壳层反馈消息。
  void showFeedback(AppShellFeedbackMessage message) {
    state = state.copyWith(feedback: message);
  }

  /// 清空当前共享壳层反馈消息。
  void clearFeedback() {
    state = state.copyWith(feedback: null);
  }
}
