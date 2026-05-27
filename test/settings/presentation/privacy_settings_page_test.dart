import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/app.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';

/// 验证隐私设置页可达并展示基础偏好开关。
void main() {
  testWidgets('隐私设置页展示外露预览控制', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeTasksProvider.overrideWith(
            (Ref ref) => Stream.value(<Task>[]),
          ),
        ],
        child: const ScreenNoteApp(
          locale: Locale('zh'),
          initialLocation: '/settings/privacy',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('隐私设置'), findsWidgets);
    expect(find.text('外露预览里隐藏隐私事项正文'), findsOneWidget);
  });
}
