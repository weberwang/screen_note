import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/app/router/app_router.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 屏记应用根组件，统一挂载路由、主题和国际化配置。
class ScreenNoteApp extends HookConsumerWidget {
  /// 创建应用根组件。
  const ScreenNoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final WidgetLaunchBridge widgetLaunchBridge = ref.watch(
      widgetLaunchBridgeProvider,
    );

    useEffect(() {
      void routeFromWidgetUri(Uri? uri) {
        if (uri == null) {
          return;
        }
        router.go(_resolveWidgetLaunchLocation(uri));
      }

      unawaited(widgetLaunchBridge.initiallyLaunchedUri().then(routeFromWidgetUri));
      final StreamSubscription<Uri?> subscription = widgetLaunchBridge
          .widgetClicked
          .listen(routeFromWidgetUri);
      return subscription.cancel;
    }, <Object?>[router, widgetLaunchBridge]);

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildScreenNoteLightTheme(),
      darkTheme: buildScreenNoteDarkTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}

/// 把 Widget 返回的 URI 统一收口到应用的 `/launch` 网关，避免原生层直接耦合 Flutter 内部路由。
String _resolveWidgetLaunchLocation(Uri uri) {
  final bool isLaunchTarget = uri.host == 'launch' ||
      uri.path == RoutePaths.launch ||
      uri.path == '/launch';
  if (isLaunchTarget) {
    final String query = uri.query;
    return query.isEmpty ? RoutePaths.launch : '${RoutePaths.launch}?$query';
  }
  return '${RoutePaths.launch}?source=widget&target=home';
}
