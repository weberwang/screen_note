import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/app.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';

/// 验证阶段二完整新建页入口与草稿保护行为。
void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeTasksProvider.overrideWith(
            (Ref ref) => Stream.value(<Task>[]),
          ),
        ],
        child: const ScreenNoteApp(locale: Locale('zh')),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('首页可以进入完整新建页', (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('完整新建'));
    await tester.pumpAndSettle();

    expect(find.text('新建事项'), findsOneWidget);
    expect(find.text('保存事项'), findsOneWidget);
  });

  testWidgets('完整新建页存在未保存内容时返回会弹出放弃修改确认', (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('完整新建'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '今晚把药带回家');
    await tester.tap(find.byTooltip('返回'));
    await tester.pumpAndSettle();

    expect(find.text('放弃还没保存的修改？'), findsOneWidget);
    expect(find.text('放弃修改'), findsOneWidget);
  });
}
