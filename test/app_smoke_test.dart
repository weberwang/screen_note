import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/app/app.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';

/// 验证初始化基线至少能成功挂载根应用与底部壳层导航。
void main() {
  testWidgets('应用基线可成功启动并显示根导航', (WidgetTester tester) async {
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [taskFlowDatabaseProvider.overrideWithValue(database)],
        child: const ScreenNoteApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
