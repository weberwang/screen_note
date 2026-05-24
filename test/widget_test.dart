import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/main.dart';

/// 验证应用级国际化代理是否能按指定语言渲染文本。
void main() {
  /// 用指定语言启动应用，避免依赖宿主系统 locale 导致测试不稳定。
  Future<void> pumpAppWithLocale(WidgetTester tester, Locale locale) async {
    await tester.pumpWidget(MainApp(locale: locale));
    await tester.pump();
  }

  testWidgets('MainApp renders English localization', (
    WidgetTester tester,
  ) async {
    await pumpAppWithLocale(tester, const Locale('en'));

    expect(find.text('Screen Note'), findsWidgets);
    expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
  });

  testWidgets('MainApp renders Simplified Chinese localization', (
    WidgetTester tester,
  ) async {
    await pumpAppWithLocale(tester, const Locale('zh'));

    expect(find.text('屏幕便签'), findsWidgets);
    expect(AppLocalizations.supportedLocales, contains(const Locale('zh')));
  });
}
