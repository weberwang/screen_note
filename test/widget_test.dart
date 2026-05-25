import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/app/app.dart';
import 'package:screen_note/src/app/route_paths.dart';
import 'package:screen_note/src/app/router.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/presentation/providers/task_feature_providers.dart';

/// 验证应用壳层与路由骨架装配正常。
void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    required Locale locale,
    String initialLocation = RoutePaths.home,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeTasksProvider.overrideWith(
            (Ref ref) => Stream.value(<Task>[]),
          ),
        ],
        child: ScreenNoteApp(
          locale: locale,
          initialLocation: initialLocation,
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('ScreenNoteApp 渲染英文应用标题', (WidgetTester tester) async {
    await pumpApp(tester, locale: const Locale('en'));

    expect(find.text('Screen Note'), findsOneWidget);
    expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
  });

  testWidgets('ScreenNoteApp 渲染简体中文应用标题', (WidgetTester tester) async {
    await pumpApp(tester, locale: const Locale('zh'));

    expect(find.text('屏幕便签'), findsOneWidget);
    expect(AppLocalizations.supportedLocales, contains(const Locale('zh')));
  });

  test('createAppRouter 暴露 GoRouter 实例', () {
    final GoRouter router = createAppRouter();

    expect(router, isA<GoRouter>());
  });
}
