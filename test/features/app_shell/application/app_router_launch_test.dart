import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/app/router/app_router.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';

void main() {
  group('appRouter', () {
    test('normalizes supported history raw locations to history', () {
      expect(_buildInitialLocation('/history/detail'), RoutePaths.history);
      expect(
        _buildInitialLocation('/history?from=widget'),
        RoutePaths.history,
      );
    });

    test('normalizes supported settings raw locations to settings', () {
      expect(_buildInitialLocation('/settings/profile'), RoutePaths.settings);
    });

    test('keeps supported task editor raw locations as task editor route', () {
      expect(
        _buildInitialLocation('/task-editor?taskId=task-42'),
        '${RoutePaths.home}${RoutePaths.taskEditor}?taskId=task-42',
      );
    });

    test('falls back to home for unsupported lookalike history location', () {
      expect(_buildInitialLocation('/history-foo'), RoutePaths.home);
    });

    test('falls back to home for unknown raw location', () {
      expect(_buildInitialLocation('/unknown'), RoutePaths.home);
    });
  });
}

String _buildInitialLocation(String rawLaunchLocation) {
  final container = ProviderContainer(
    overrides: [
      widgetLaunchBridgeProvider.overrideWithValue(
        _FakeWidgetLaunchBridge(rawLaunchLocation: rawLaunchLocation),
      ),
    ],
  );

  try {
    final router = container.read(appRouterProvider);
    return router.routeInformationProvider.value.uri.toString();
  } finally {
    container.dispose();
  }
}

final class _FakeWidgetLaunchBridge implements WidgetLaunchBridge {
  const _FakeWidgetLaunchBridge({
    required this.rawLaunchLocation,
  });

  @override
  final String rawLaunchLocation;

  @override
  Stream<String> get launchLocations => const Stream<String>.empty();
}
