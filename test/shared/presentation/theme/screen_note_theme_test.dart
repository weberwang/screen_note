import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 验证阶段一主题同时提供亮暗两套运行时调色板。
void main() {
  test('screen note 亮暗主题拥有不同亮度与调色板', () {
    final ThemeData lightTheme = buildScreenNoteLightTheme();
    final ThemeData darkTheme = buildScreenNoteDarkTheme();
    final ScreenNoteThemePalette? lightPalette =
        lightTheme.extension<ScreenNoteThemePalette>();
    final ScreenNoteThemePalette? darkPalette =
        darkTheme.extension<ScreenNoteThemePalette>();

    expect(lightTheme.brightness, Brightness.light);
    expect(darkTheme.brightness, Brightness.dark);
    expect(lightPalette, isNotNull);
    expect(darkPalette, isNotNull);
    expect(lightPalette!.surfacePaper, isNot(darkPalette!.surfacePaper));
    expect(lightPalette.backgroundTop, isNot(darkPalette.backgroundTop));
    expect(lightPalette.inkPrimary, isNot(darkPalette.inkPrimary));
  });
}
