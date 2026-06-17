import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';

void main() {
  group('NoopWidgetLaunchBridge', () {
    test('exposes home as raw launch location', () {
      const bridge = NoopWidgetLaunchBridge();

      expect(bridge.rawLaunchLocation, RoutePaths.home);
    });

    test('exposes an empty runtime launch stream', () async {
      const bridge = NoopWidgetLaunchBridge();

      await expectLater(bridge.launchLocations, emitsDone);
    });
  });

  group('HomeWidgetLaunchBridge', () {
    test('maps widget task deep link to task editor route', () async {
      final bridge = await HomeWidgetLaunchBridge.load(
        initialUri: Uri.parse(
          'screennote://launch?source=widget&target=task&taskId=task-42',
        ),
        clickStream: const Stream<Uri?>.empty(),
      );

      expect(
        bridge.rawLaunchLocation,
        '${RoutePaths.taskEditor}?taskId=task-42',
      );
    });

    test('normalizes runtime widget clicks to safe launch routes', () async {
      final controller = StreamController<Uri?>();
      addTearDown(controller.close);
      final bridge = await HomeWidgetLaunchBridge.load(
        initialUri: Uri.parse('screennote://launch?source=widget&target=home'),
        clickStream: controller.stream,
      );

      final expectation = expectLater(
        bridge.launchLocations,
        emitsInOrder(<Object>[
          RoutePaths.home,
          '${RoutePaths.taskEditor}?taskId=task-42',
          RoutePaths.home,
          emitsDone,
        ]),
      );

      controller
        ..add(
          Uri.parse('screennote://launch?source=widget&target=home'),
        )
        ..add(
          Uri.parse(
            'screennote://launch?source=widget&target=task&taskId=task-42',
          ),
        )
        ..add(
          Uri.parse('screennote://launch?source=other&target=task'),
        );
      await controller.close();

      await expectation;
    });

    test('falls back to home when widget task id is blank', () async {
      final bridge = await HomeWidgetLaunchBridge.load(
        initialUri: Uri.parse(
          'screennote://launch?source=widget&target=task&taskId=%20%20',
        ),
        clickStream: const Stream<Uri?>.empty(),
      );

      expect(bridge.rawLaunchLocation, RoutePaths.home);
    });

    test('converts runtime click stream errors to safe home route', () async {
      final controller = StreamController<Uri?>();
      addTearDown(controller.close);
      final bridge = await HomeWidgetLaunchBridge.load(
        initialUri: Uri.parse('screennote://launch?source=widget&target=home'),
        clickStream: controller.stream,
      );

      final expectation = expectLater(
        bridge.launchLocations,
        emitsInOrder(<Object>[
          RoutePaths.home,
          emitsDone,
        ]),
      );

      controller.addError(StateError('widget click stream failed'));
      await controller.close();

      await expectation;
    });
  });

  group('loadSafeWidgetLaunchBridge', () {
    test('falls back to noop bridge when loader throws any exception', () async {
      final bridge = await loadSafeWidgetLaunchBridge(
        loader: () async => throw PlatformException(code: 'boom'),
      );

      expect(bridge, isA<NoopWidgetLaunchBridge>());
      expect(bridge.rawLaunchLocation, RoutePaths.home);
    });

    test('falls back to noop bridge when loader times out', () async {
      final bridge = await loadSafeWidgetLaunchBridge(
        loader: () => Completer<HomeWidgetLaunchBridge>().future,
        timeout: const Duration(milliseconds: 10),
      );

      expect(bridge, isA<NoopWidgetLaunchBridge>());
      expect(bridge.rawLaunchLocation, RoutePaths.home);
    });
  });
}
