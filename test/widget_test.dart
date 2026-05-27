import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/route_paths.dart';
import 'package:screen_note/app/router.dart';
import 'package:screen_note/features/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/features/quick_add/application/quick_add_entry_source.dart';
import 'package:screen_note/features/quick_add/data/quick_add_draft_store.dart';
import 'package:screen_note/features/quick_add/data/quick_add_intent_bridge.dart';
import 'package:screen_note/features/quick_add/presentation/providers/quick_add_providers.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';

/// 验证应用壳层与路由骨架装配正常。
void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    required Locale locale,
    String initialLocation = RoutePaths.home,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeTasksProvider.overrideWith(
            (Ref ref) => Stream.value(<Task>[]),
          ),
        ],
        child: ScreenNoteApp(
          locale: locale,
          initialLocation: initialLocation,
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('ScreenNoteApp 渲染英文应用标题', (WidgetTester tester) async {
    await pumpApp(tester, locale: const Locale('en'));

    expect(find.text('Screen Note'), findsOneWidget);
    expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
  });

  testWidgets('ScreenNoteApp 渲染简体中文应用标题', (WidgetTester tester) async {
    await pumpApp(tester, locale: const Locale('zh'));

    expect(find.text('屏幕便签'), findsOneWidget);
    expect(AppLocalizations.supportedLocales, contains(const Locale('zh')));
  });

  test('createAppRouter 暴露 GoRouter 实例', () {
    final GoRouter router = createAppRouter();

    expect(router, isA<GoRouter>());
  });

  testWidgets('ScreenNoteApp 恢复前台时会消费系统入口草稿并跳转 quick add', (
    WidgetTester tester,
  ) async {
    final _MemoryQuickAddDraftStore draftStore = _MemoryQuickAddDraftStore();
    final _MemoryQuickAddIntentBridge bridge = _MemoryQuickAddIntentBridge(
      pendingDraft: QuickAddDraft.create(
        source: QuickAddEntrySource.deepLink,
        draftText: '恢复前台补充草稿',
        timestamp: DateTime(2026, 5, 26, 18),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeTasksProvider.overrideWith(
            (Ref ref) => Stream.value(<Task>[]),
          ),
          quickAddDraftStoreProvider.overrideWithValue(draftStore),
          quickAddIntentBridgeProvider.overrideWithValue(bridge),
        ],
        child: const ScreenNoteApp(locale: Locale('zh')),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('快速添加'), findsOneWidget);
    expect(find.text('恢复前台补充草稿'), findsOneWidget);
    expect(draftStore.savedDraft?.source, QuickAddEntrySource.deepLink);

    bridge.pendingDraft = QuickAddDraft.create(
      source: QuickAddEntrySource.deepLink,
      draftText: '再次恢复的草稿',
      timestamp: DateTime(2026, 5, 26, 19),
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('再次恢复的草稿'), findsOneWidget);
    expect(draftStore.savedDraft?.draftText, '再次恢复的草稿');
    expect(bridge.consumeCount, 2);
  });
}

/// 内存版待处理草稿桥接，验证应用启动与恢复前台时的统一消费行为。
class _MemoryQuickAddIntentBridge implements QuickAddIntentBridge {
  _MemoryQuickAddIntentBridge({this.pendingDraft});

  int consumeCount = 0;
  QuickAddDraft? pendingDraft;

  @override
  Future<void> clearPendingDraft() async {
    pendingDraft = null;
  }

  @override
  Future<QuickAddDraft?> consumePendingDraft() async {
    consumeCount += 1;
    final QuickAddDraft? draft = pendingDraft;
    pendingDraft = null;
    return draft;
  }

  @override
  Future<void> savePendingDraft(QuickAddDraft draft) async {
    pendingDraft = draft;
  }
}

/// 内存版草稿存储，用于验证系统入口草稿最终仍走应用层统一持久化。
class _MemoryQuickAddDraftStore implements QuickAddDraftStore {
  QuickAddDraft? savedDraft;

  @override
  Future<void> clear() async {
    savedDraft = null;
  }

  @override
  Future<QuickAddDraft?> read() async => savedDraft;

  @override
  Future<void> save(QuickAddDraft draft) async {
    savedDraft = draft;
  }
}
