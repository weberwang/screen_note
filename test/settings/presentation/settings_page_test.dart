import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/src/app/app.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/presentation/providers/task_feature_providers.dart';

/// 验证设置页入口与分组。
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

  testWidgets('首页可以进入设置页并看到阶段二入口', (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();

    expect(find.text('设置'), findsWidgets);
    expect(find.text('锁屏显示'), findsOneWidget);
    expect(find.text('隐私设置'), findsOneWidget);
  });
}
