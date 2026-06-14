import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/features/app_shell/application/app_shell_launch_resolver.dart';
import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';
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
    required this.currentLocation,
    super.key,
  });

  /// 当前根级分支宿主。
  final StatefulNavigationShell navigationShell;

  /// 当前命中的壳层子路由路径，供壳层决定是否展示全局 quick add。
  final String currentLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final uiState = ref.watch(appShellUiStateControllerProvider);
    final uiStateController = ref.read(
      appShellUiStateControllerProvider.notifier,
    );
    final WidgetLaunchBridge launchBridge = ref.watch(widgetLaunchBridgeProvider);
    final bool isTaskEditorRoute = currentLocation.endsWith(
      '/${RoutePaths.taskEditor}',
    );
    const AppShellLaunchResolver launchResolver = AppShellLaunchResolver();

    useEffect(() {
      Future<void> handleWidgetLaunch(String location) async {
        try {
          if (!context.mounted) {
            return;
          }

          final currentUiState = ref.read(appShellUiStateControllerProvider);
          if (currentUiState.quickAddSheetOpen) {
            uiStateController.closeQuickAddSheet();
            await Navigator.of(context).maybePop();
            if (!context.mounted) {
              return;
            }
          }

          final intent = launchResolver.resolve(location);
          final targetLocation = locationForAppShellIntent(intent);
          if (intent.maybeMap(taskEditor: (_) => true, orElse: () => false)) {
            await context.push(targetLocation);
            return;
          }

          context.go(targetLocation);
        } catch (_) {
          if (context.mounted) {
            context.go(defaultAppShellLocation);
          }
        }
      }

      final subscription = launchBridge.launchLocations.listen(
        (String location) {
          handleWidgetLaunch(location);
        },
        onError: (Object error, StackTrace stackTrace) {
          handleWidgetLaunch(defaultAppShellLocation);
        },
      );
      return subscription.cancel;
    }, <Object>[launchBridge]);

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
      floatingActionButton: isTaskEditorRoute
          ? null
          : FloatingActionButton(
              onPressed: () async {
                if (uiState.quickAddSheetOpen) {
                  return;
                }

                uiStateController.openQuickAddSheet();
                final bool shouldOpenEditor;
                try {
                  shouldOpenEditor =
                          await showModalBottomSheet<bool>(
                            context: context,
                            showDragHandle: true,
                            builder: (context) {
                              return const AppShellQuickAddSheet();
                            },
                          ) ??
                      false;
                } finally {
                  // 无论用户是点击关闭、下拉收起还是系统返回，都要把壳层共享状态复位。
                  uiStateController.closeQuickAddSheet();
                }

                // Quick add 只负责把用户带进正式编辑页，新建事项仍由 task-flow 页面承接。
                if (shouldOpenEditor && context.mounted) {
                  await context.push('${RoutePaths.home}${RoutePaths.taskEditor}');
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
