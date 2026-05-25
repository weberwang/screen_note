import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/src/app/app.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/presentation/providers/task_feature_providers.dart';

/// 验证应用壳层已同时挂载亮色与暗色主题，并允许测试覆盖主题模式。
void main() {
  Future<void> pumpThemeApp(
    WidgetTester tester, {
    required ThemeMode themeMode,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeTasksProvider.overrideWith(
            (Ref ref) => Stream.value(<Task>[]),
          ),
        ],
        child: ScreenNoteApp(
          locale: const Locale('en'),
          themeMode: themeMode,
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('ScreenNoteApp 暴露亮色与暗色主题配置', (WidgetTester tester) async {
    await pumpThemeApp(tester, themeMode: ThemeMode.dark);

    final MaterialApp materialApp = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );

    expect(materialApp.theme, isNotNull);
    expect(materialApp.darkTheme, isNotNull);
    expect(materialApp.themeMode, ThemeMode.dark);
  });
}
