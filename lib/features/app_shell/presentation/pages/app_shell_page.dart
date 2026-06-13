import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/features/app_shell/application/providers/app_shell_ui_state.dart';
import 'package:screen_note/features/app_shell/presentation/widgets/app_shell_feedback_host.dart';
import 'package:screen_note/features/app_shell/presentation/widgets/app_shell_navigation_surface.dart';
import 'package:screen_note/features/app_shell/presentation/widgets/app_shell_quick_add_sheet.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 根级共享壳层页面，负责承接分支宿主、底栏和全局快速添加入口。
class AppShellPage extends HookConsumerWidget {
  /// 创建共享壳层页面。
  const AppShellPage({
    required this.navigationShell,
    super.key,
  });

  /// 当前根级分支宿主。
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final uiState = ref.watch(appShellUiStateControllerProvider);
    final uiStateController = ref.read(
      appShellUiStateControllerProvider.notifier,
    );

    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          if (uiState.feedback case final feedback?)
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: AppShellFeedbackHost(
                  text: feedback.text,
                  dismissLabel: localizations.appShellFeedbackDismiss,
                  onClose: uiStateController.clearFeedback,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (uiState.quickAddSheetOpen) {
            return;
          }

          uiStateController.openQuickAddSheet();
          try {
            await showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (context) {
                return const AppShellQuickAddSheet();
              },
            );
          } finally {
            // 无论用户是点击关闭、下拉收起还是系统返回，都要把壳层共享状态复位。
            uiStateController.closeQuickAddSheet();
            uiStateController.showFeedback(
              AppShellFeedbackMessage(
                level: AppShellFeedbackLevel.info,
                text: localizations.quickAddFeedbackPlaceholder,
              ),
            );
          }
        },
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: AppShellNavigationSurface(
        navigationShell: navigationShell,
      ),
    );
  }
}
