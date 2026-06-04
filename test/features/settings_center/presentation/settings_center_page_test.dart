import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 验证设置页切换偏好后会立即回显，并持久化到共享偏好。
void main() {
  testWidgets('设置页切换隐私开关和锁屏样式后会立即回显', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsSharedPreferencesProvider.overrideWith((ref) async => preferences),
        ],
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildScreenNoteLightTheme(),
          darkTheme: buildScreenNoteDarkTheme(),
          home: const Scaffold(body: SettingsCenterPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-widget-mode-today')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('settings-privacy-switch')),
      200,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-privacy-switch')));
    await tester.pumpAndSettle();

    expect(find.text('今日'), findsWidgets);
    expect(preferences.getBool('settings.maskPrivateContent'), isFalse);
    expect(
      preferences.getString('settings.widgetDisplayMode'),
      WidgetDisplayMode.today.name,
    );
  });
}
