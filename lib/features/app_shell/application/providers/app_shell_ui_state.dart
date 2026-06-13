import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_shell_ui_state.freezed.dart';
part 'app_shell_ui_state.g.dart';

/// 共享壳层反馈等级只描述展示语气，
/// 便于后续把降级提示与普通信息提示区分开。
enum AppShellFeedbackLevel { info, warning, degradation }

/// 共享壳层反馈消息用于承载轻量提示，
/// 当前阶段只保留最小展示字段，避免提前引入复杂交互协议。
@freezed
abstract class AppShellFeedbackMessage with _$AppShellFeedbackMessage {
  /// 创建一条共享壳层反馈消息。
  const factory AppShellFeedbackMessage({
    required AppShellFeedbackLevel level,
    required String text,
  }) = _AppShellFeedbackMessage;
}

/// 共享壳层 UI 状态只承载跨页面共享的轻量交互状态，
/// 暂不接入任何业务模块数据或页面局部表单状态。
@freezed
abstract class AppShellUiState with _$AppShellUiState {
  /// 创建共享壳层 UI 状态快照。
  const factory AppShellUiState({
    @Default(false) bool quickAddSheetOpen,
    AppShellFeedbackMessage? feedback,
  }) = _AppShellUiState;
}

/// 共享壳层 UI 状态控制器负责维护全局轻量交互状态，
/// 避免页面直接共享可变字段。
@Riverpod(keepAlive: true)
class AppShellUiStateController extends _$AppShellUiStateController {
  /// 构建共享壳层默认 UI 状态。
  @override
  AppShellUiState build() => const AppShellUiState();

  /// 打开全局快速添加面板。
  void openQuickAddSheet() {
    state = state.copyWith(quickAddSheetOpen: true);
  }

  /// 关闭全局快速添加面板。
  void closeQuickAddSheet() {
    state = state.copyWith(quickAddSheetOpen: false);
  }

  /// 展示一条共享壳层反馈消息。
  void showFeedback(AppShellFeedbackMessage message) {
    state = state.copyWith(feedback: message);
  }

  /// 清空当前共享壳层反馈消息。
  void clearFeedback() {
    state = state.copyWith(feedback: null);
  }
}
