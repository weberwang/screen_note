import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/src/app/app.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/presentation/providers/task_feature_providers.dart';

/// 验证锁屏显示设置页的预览与隐私开关。
void main() {
  testWidgets('锁屏显示设置页支持切换隐私预览', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeTasksProvider.overrideWith(
            (Ref ref) => Stream.value(<Task>[]),
          ),
        ],
        child: const ScreenNoteApp(
          locale: Locale('zh'),
          initialLocation: '/settings/widget',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('锁屏显示'), findsWidgets);
    expect(find.text('预览里隐藏隐私事项正文'), findsOneWidget);
    expect(find.text('隐私事项内容已隐藏'), findsOneWidget);
  });
}
