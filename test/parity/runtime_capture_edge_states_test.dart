import 'package:flutter_test/flutter_test.dart';

import 'support/runtime_capture_harness.dart';

/// 覆盖隐私态与空态的运行态证据，防止 parity reviewer 只看到理想态。
void main() {
  testWidgets('私密 Widget 证据不会泄露正文与截止时间', (
    WidgetTester tester,
  ) async {
    final RuntimeCaptureHarness harness = await pumpRuntimeCaptureHarness(
      tester,
      fixture: RuntimeCaptureFixture.runtimePack,
    );

    harness.router.go('/widget');
    await tester.pumpAndSettle();

    expect(find.text('不该外露的正文'), findsNothing);
    expect(find.textContaining('18:00'), findsNothing);
    await expectCurrentGolden(
      tester,
      goldenPath: 'goldens/runtime_edge_widget_private.png',
    );
  });

  testWidgets('Widget 空态证据可稳定复现', (WidgetTester tester) async {
    final RuntimeCaptureHarness harness = await pumpRuntimeCaptureHarness(
      tester,
      fixture: RuntimeCaptureFixture.widgetEmpty,
    );

    await expectRouteGolden(
      tester,
      harness: harness,
      route: '/widget',
      goldenPath: 'goldens/runtime_edge_widget_empty.png',
    );
  });

  testWidgets('最近完成空态证据可稳定复现', (WidgetTester tester) async {
    final RuntimeCaptureHarness harness = await pumpRuntimeCaptureHarness(
      tester,
      fixture: RuntimeCaptureFixture.historyCompletedEmpty,
    );

    await expectRouteGolden(
      tester,
      harness: harness,
      route: '/history',
      goldenPath: 'goldens/runtime_edge_history_completed_empty.png',
    );
  });
}
