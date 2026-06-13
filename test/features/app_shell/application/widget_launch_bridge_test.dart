import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';

void main() {
  group('NoopWidgetLaunchBridge', () {
    test('exposes home as raw launch location', () {
      const bridge = NoopWidgetLaunchBridge();

      expect(bridge.rawLaunchLocation, RoutePaths.home);
    });
  });
}
