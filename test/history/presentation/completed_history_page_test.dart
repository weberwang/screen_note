import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/history/presentation/pages/completed_history_page.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/presentation/providers/task_feature_providers.dart';

/// 验证最近完成页保持“可追踪历史”而不是“恢复入口”语义。
void main() {
  testWidgets('最近完成页不会直接展示恢复动作', (WidgetTester tester) async {
    final DateTime now = DateTime(2026, 5, 25, 10);
    final Task task = Task(
      id: 'task-1',
      title: '已经把水电费交完',
      note: '用于确认可靠性链路可追踪，而不是鼓励长期归档管理。',
      status: TaskStatus.completed,
      createdAt: now.subtract(const Duration(days: 2)),
      updatedAt: now,
      completedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          completedTasksProvider.overrideWith(
            (Ref ref) => Stream.value(<Task>[task]),
          ),
        ],
        child: const _TestApp(child: CompletedHistoryPage()),
      ),
    );
    await tester.pump();

    expect(find.text('恢复事项'), findsNothing);
    expect(find.text('查看原记录'), findsOneWidget);
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
