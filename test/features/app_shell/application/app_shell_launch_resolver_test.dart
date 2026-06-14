import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/app_shell/application/app_shell_launch_resolver.dart';
import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';

void main() {
  group('AppShellLaunchResolver', () {
    test('maps known shell routes to matching intents', () {
      final resolver = AppShellLaunchResolver();

      expect(
        resolver.resolve(RoutePaths.home),
        const AppShellLaunchIntent.home(),
      );
      expect(
        resolver.resolve(RoutePaths.history),
        const AppShellLaunchIntent.history(),
      );
      expect(
        resolver.resolve(RoutePaths.settings),
        const AppShellLaunchIntent.settings(),
      );
    });

    test('normalizes nested and query history locations to history', () {
      final resolver = AppShellLaunchResolver();

      expect(
        resolver.resolve('/history/detail'),
        const AppShellLaunchIntent.history(),
      );
      expect(
        resolver.resolve('/history?from=widget'),
        const AppShellLaunchIntent.history(),
      );
    });

    test('normalizes nested settings locations to settings', () {
      final resolver = AppShellLaunchResolver();

      expect(
        resolver.resolve('/settings/profile'),
        const AppShellLaunchIntent.settings(),
      );
    });

    test('preserves task editor locations with a task id', () {
      final resolver = AppShellLaunchResolver();

      expect(
        resolver.resolve('/task-editor?taskId=task-42'),
        const AppShellLaunchIntent.taskEditor(taskId: 'task-42'),
      );
    });

    test('falls back when task editor location is missing task id', () {
      final resolver = AppShellLaunchResolver();

      expect(
        resolver.resolve('/task-editor'),
        const AppShellLaunchIntent.fallbackHome(),
      );
    });

    test('falls back when task editor location contains extra path segments', () {
      final resolver = AppShellLaunchResolver();

      expect(
        resolver.resolve('/task-editor/extra?taskId=task-42'),
        const AppShellLaunchIntent.fallbackHome(),
      );
    });

    test('falls back when task editor task id is only whitespace', () {
      final resolver = AppShellLaunchResolver();

      expect(
        resolver.resolve('/task-editor?taskId=%20%20'),
        const AppShellLaunchIntent.fallbackHome(),
      );
    });

    test('falls back for prefixed lookalike shell locations', () {
      final resolver = AppShellLaunchResolver();

      expect(
        resolver.resolve('/historyX'),
        const AppShellLaunchIntent.fallbackHome(),
      );
      expect(
        resolver.resolve('/settingsBackup'),
        const AppShellLaunchIntent.fallbackHome(),
      );
    });

    test('falls back to home for unknown locations', () {
      final resolver = AppShellLaunchResolver();

      expect(
        resolver.resolve('/unknown'),
        const AppShellLaunchIntent.fallbackHome(),
      );
    });
  });
}
