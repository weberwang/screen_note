import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';
import 'package:screen_note/features/tasks/presentation/widgets/task_card.dart';

/// 验证当前事项卡片遵守隐私展示边界。
void main() {
  testWidgets('隐私事项卡片不会在列表态泄露正文', (WidgetTester tester) async {
    final DateTime now = DateTime(2026, 5, 25, 10);
    final Task task = Task(
      id: 'task-1',
      title: '银行卡密码',
      note: '敏感正文不能出现在列表',
      status: TaskStatus.active,
      isPrivate: true,
      createdAt: now.subtract(const Duration(days: 1)),
      updatedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nowProvider.overrideWithValue(() => now),
        ],
        child: _TestApp(
          child: TaskCard(
            task: task,
            onTap: () {},
            onComplete: () {},
            onDelete: () {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('敏感正文不能出现在列表'), findsNothing);
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
      home: Scaffold(body: Center(child: child)),
    );
  }
}
