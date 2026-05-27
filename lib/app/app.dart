import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/app/route_paths.dart';
import 'package:screen_note/app/router.dart';
import 'package:screen_note/features/quick_add/application/quick_add_flow_result.dart';
import 'package:screen_note/features/quick_add/presentation/providers/quick_add_providers.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

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

/// 应用根壳状态，负责在启动与恢复前台时承接系统入口写入的待处理草稿。
class _ScreenNoteAppState extends ConsumerState<ScreenNoteApp>
    with WidgetsBindingObserver {
  late GoRouter _router;
  bool _isConsumingPendingQuickAddDraft = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _router = createAppRouter(initialLocation: widget.initialLocation);
    _consumePendingQuickAddDraft();
  }

  Future<void> _consumePendingQuickAddDraft() async {
    if (_isConsumingPendingQuickAddDraft) {
      return;
    }

    _isConsumingPendingQuickAddDraft = true;
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
      _router.go(RoutePaths.quickAdd, extra: pendingDraft);
    } catch (_) {
      // 系统入口桥接失败只能降级，不能阻断主应用冷启动或前台恢复。
    } finally {
      _isConsumingPendingQuickAddDraft = false;
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 原生系统入口可能在应用已存活时再次写入草稿，这里统一补一次消费。
      _consumePendingQuickAddDraft();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
