import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:screen_note/features/app_shell/application/providers/app_shell_launch_feedback_controller.dart';
import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 壳层全局反馈宿主，统一承接外部回流后的轻量提示位置与展示策略。
class AppShellFeedbackHost extends ConsumerWidget {
  /// 创建壳层全局反馈宿主。
  const AppShellFeedbackHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AppShellLaunchFeedbackEvent?>(
      appShellLaunchFeedbackControllerProvider,
      (AppShellLaunchFeedbackEvent? previous, AppShellLaunchFeedbackEvent? next) {
        if (next == null) {
          return;
        }
        final AppLocalizations localizations = AppLocalizations.of(context);
        final String destination = _destinationLabel(
          localizations,
          next.intent.target,
        );
        final String message = next.intent.isFallback
            ? localizations.appShellLaunchFallbackFeedback(destination)
            : localizations.appShellLaunchRoutedFeedback(destination);
        // 回流反馈必须克制且位置稳定，因此统一用壳层浮动 SnackBar 承接。
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
        ref
            .read(appShellLaunchFeedbackControllerProvider.notifier)
            .consume(next.sequence);
      },
    );
    return const SizedBox.shrink();
  }

  /// 把壳层目标枚举映射为当前语言下的页面名称，避免页面层散落文案判断。
  String _destinationLabel(
    AppLocalizations localizations,
    AppShellRouteTarget target,
  ) {
    return switch (target) {
      AppShellRouteTarget.home => localizations.taskFlowTabLabel,
      AppShellRouteTarget.taskEditor => localizations.taskEditorTitle,
      AppShellRouteTarget.historyCompleted => localizations.historyCompletedTitle,
      AppShellRouteTarget.historyDeleted => localizations.historyDeletedTitle,
      AppShellRouteTarget.settings => localizations.settingsPageTitle,
      AppShellRouteTarget.widgetBridge => localizations.widgetSettingsTitle,
    };
  }
}
