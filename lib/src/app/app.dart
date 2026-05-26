import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/app/route_paths.dart';
import 'package:screen_note/src/app/router.dart';
import 'package:screen_note/src/quick_add/application/quick_add_flow_result.dart';
import 'package:screen_note/src/quick_add/presentation/providers/quick_add_providers.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';

/// 应用根壳层，集中装配主题、国际化与路由。
class ScreenNoteApp extends ConsumerStatefulWidget {
  /// 创建应用根壳层。
  const ScreenNoteApp({
    super.key,
    this.locale,
    this.initialLocation = RoutePaths.home,
    this.themeMode = ThemeMode.system,
  });

  /// 供测试或设置模块覆写语言，留空时跟随系统语言。
  final Locale? locale;

  /// 供测试注入初始路由，避免测试依赖运行时导航动作。
  final String initialLocation;

  /// 供测试或后续设置页覆写主题模式，默认跟随系统亮暗模式。
  final ThemeMode themeMode;

  @override
  ConsumerState<ScreenNoteApp> createState() => _ScreenNoteAppState();
}

class _ScreenNoteAppState extends ConsumerState<ScreenNoteApp> {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(initialLocation: widget.initialLocation);
    _consumePendingQuickAddDraft();
  }

  Future<void> _consumePendingQuickAddDraft() async {
    try {
      final pendingDraft = await ref
          .read(quickAddIntentBridgeProvider)
          .consumePendingDraft();
      if (!mounted || pendingDraft == null) {
        return;
      }

      await ref.read(quickAddFlowServiceProvider).saveDraft(
        pendingDraft,
        status: QuickAddFlowStatus.failedButRecovered,
      );
      _router.go(RoutePaths.quickAdd);
    } catch (_) {
      // 系统入口桥接失败只能降级，不能阻断主应用冷启动。
    }
  }

  @override
  void didUpdateWidget(covariant ScreenNoteApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialLocation != widget.initialLocation) {
      _router = createAppRouter(initialLocation: widget.initialLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = _router;

    return MaterialApp.router(
      locale: widget.locale,
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      theme: buildScreenNoteLightTheme(),
      darkTheme: buildScreenNoteDarkTheme(),
      themeMode: widget.themeMode,
    );
  }
}
