import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/features/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/features/quick_add/application/quick_add_entry_source.dart';
import 'package:screen_note/features/quick_add/data/quick_add_draft_store.dart';
import 'package:screen_note/features/quick_add/presentation/pages/quick_add_page.dart';
import 'package:screen_note/features/quick_add/presentation/providers/quick_add_providers.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 验证 `/quick-add` 统一失败兜底页。
void main() {
  testWidgets('quick add 页面会恢复最近一次保留的草稿', (
    WidgetTester tester,
  ) async {
    final _MemoryQuickAddDraftStore store = _MemoryQuickAddDraftStore();
    await store.save(
      QuickAddDraft.create(
        source: QuickAddEntrySource.fallback,
        draftText: '回家浇花',
        timestamp: DateTime(2026, 5, 26, 12),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quickAddDraftStoreProvider.overrideWithValue(store),
        ],
        child: const _TestApp(child: QuickAddPage()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('回家浇花'), findsOneWidget);
    expect(find.text('刚才的草稿已经恢复到这里，你可以直接继续补完并提交。'), findsOneWidget);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('zh'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildScreenNoteLightTheme(),
      darkTheme: buildScreenNoteDarkTheme(),
      home: child,
    );
  }
}

class _MemoryQuickAddDraftStore implements QuickAddDraftStore {
  QuickAddDraft? _draft;

  @override
  Future<void> clear() async {
    _draft = null;
  }

  @override
  Future<QuickAddDraft?> read() async => _draft;

  @override
  Future<void> save(QuickAddDraft draft) async {
    _draft = draft;
  }
}
