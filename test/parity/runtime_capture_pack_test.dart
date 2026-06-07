import 'package:flutter_test/flutter_test.dart';

import 'support/runtime_capture_harness.dart';

/// 生成关键模块运行态证据包，确保 parity reviewer 不再缺少实现态截图输入。
void main() {
  testWidgets('生成关键模块运行态证据包', (WidgetTester tester) async {
    final RuntimeCaptureHarness harness = await pumpRuntimeCaptureHarness(
      tester,
      fixture: RuntimeCaptureFixture.runtimePack,
    );

    await expectRouteGolden(
      tester,
      harness: harness,
      route: '/',
      goldenPath: 'goldens/runtime_pack_home.png',
    );
    await expectRouteGolden(
      tester,
      harness: harness,
      route: '/task-editor',
      goldenPath: 'goldens/runtime_pack_task_editor.png',
    );
    await expectRouteGolden(
      tester,
      harness: harness,
      route: '/settings',
      goldenPath: 'goldens/runtime_pack_settings.png',
    );
    await expectRouteGolden(
      tester,
      harness: harness,
      route: '/history?section=deleted',
      goldenPath: 'goldens/runtime_pack_history_deleted.png',
    );
    await expectRouteGolden(
      tester,
      harness: harness,
      route: '/widget',
      goldenPath: 'goldens/runtime_pack_widget_private.png',
    );
  });
}
