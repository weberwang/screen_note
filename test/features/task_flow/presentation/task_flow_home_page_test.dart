import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_home_page.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 验证首页快速添加主链路会把新事项立即写入并回显到列表。
void main() {
  testWidgets('首页快速添加后会立即显示新事项', (WidgetTester tester) async {
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(database),
        ],
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildScreenNoteLightTheme(),
          darkTheme: buildScreenNoteDarkTheme(),
          home: const Scaffold(body: TaskFlowHomePage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '今天别忘了买电池');
    await tester.tap(find.text('添加'));
    await tester.pumpAndSettle();

    expect(find.text('今天别忘了买电池'), findsOneWidget);
  });
}
