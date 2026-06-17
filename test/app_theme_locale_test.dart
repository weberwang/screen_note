import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/router/app_router.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/l10n/app_localizations.dart';

void main() {
  testWidgets('根应用会根据偏好切换主题和语言', (WidgetTester tester) async {
    final SettingsPreferencesRepository preferencesRepository =
        _InMemorySettingsPreferencesRepository(
          initial: const SettingsCenterPreferences(
            themeModePreference: SettingsThemeModePreference.dark,
            languagePreference: SettingsLanguagePreference.en,
          ),
        );
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return Builder(
              builder: (BuildContext context) {
                return Text(AppLocalizations.of(context).settingsTitle);
              },
            );
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appRouterProvider.overrideWithValue(router),
          settingsPreferencesRepositoryProvider.overrideWithValue(
            preferencesRepository,
          ),
        ],
        child: const ScreenNoteApp(),
      ),
    );
    await tester.pumpAndSettle();

    final MaterialApp app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    expect(app.locale, const Locale('en'));
    expect(find.text('Settings Center'), findsOneWidget);
  });

  testWidgets('根应用会提供透明系统栏样式宿主', (WidgetTester tester) async {
    final SettingsPreferencesRepository preferencesRepository =
        _InMemorySettingsPreferencesRepository(
          initial: const SettingsCenterPreferences(),
        );
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const SizedBox.shrink();
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appRouterProvider.overrideWithValue(router),
          settingsPreferencesRepositoryProvider.overrideWithValue(
            preferencesRepository,
          ),
        ],
        child: const ScreenNoteApp(),
      ),
    );
    await tester.pumpAndSettle();

    final AnnotatedRegion<SystemUiOverlayStyle> overlayRegion = tester.widget(
      find.byWidgetPredicate(
        (Widget widget) => widget is AnnotatedRegion<SystemUiOverlayStyle>,
      ),
    );

    expect(overlayRegion.value.statusBarColor, Colors.transparent);
    expect(overlayRegion.value.systemNavigationBarColor, Colors.transparent);
  });
}

/// 内存偏好仓储只服务根应用联动测试，避免把 shared_preferences 带进根组件验证。
final class _InMemorySettingsPreferencesRepository
    implements SettingsPreferencesRepository {
  _InMemorySettingsPreferencesRepository({
    required SettingsCenterPreferences initial,
  }) : _current = initial;

  SettingsCenterPreferences _current;

  @override
  Future<SettingsCenterPreferences> loadPreferences() async => _current;

  @override
  Future<void> savePreferences(SettingsCenterPreferences preferences) async {
    _current = preferences;
  }
}
