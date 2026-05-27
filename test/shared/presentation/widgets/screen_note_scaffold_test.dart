import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_scaffold.dart';

/// 验证共享壳层背景跟随当前主题切换，避免暗色模式仍停留在亮色纸面。
void main() {
  Future<BoxDecoration> pumpScaffold(
    WidgetTester tester, {
    required ThemeData theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: ScreenNoteScaffold(
          title: const Text('Theme Test'),
          body: const SizedBox.expand(),
        ),
      ),
    );
    await tester.pump();

    final DecoratedBox decoratedBox = tester.widget<DecoratedBox>(
      find.byType(DecoratedBox).first,
    );

    return decoratedBox.decoration as BoxDecoration;
  }

  testWidgets('ScreenNoteScaffold 在亮色主题使用亮色背景渐变', (
    WidgetTester tester,
  ) async {
    final BoxDecoration decoration = await pumpScaffold(
      tester,
      theme: buildScreenNoteLightTheme(),
    );
    final LinearGradient gradient = decoration.gradient! as LinearGradient;

    expect(
      gradient.colors,
      <Color>[
        ScreenNotePalettes.light.backgroundTop,
        ScreenNotePalettes.light.backgroundBottom,
      ],
    );
  });

  testWidgets('ScreenNoteScaffold 在暗色主题使用暗色背景渐变', (
    WidgetTester tester,
  ) async {
    final BoxDecoration decoration = await pumpScaffold(
      tester,
      theme: buildScreenNoteDarkTheme(),
    );
    final LinearGradient gradient = decoration.gradient! as LinearGradient;

    expect(
      gradient.colors,
      <Color>[
        ScreenNotePalettes.dark.backgroundTop,
        ScreenNotePalettes.dark.backgroundBottom,
      ],
    );
  });
}
