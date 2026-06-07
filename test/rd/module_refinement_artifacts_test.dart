import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// 读取仓库内的 RD 文档，确保断言始终针对当前工作区的真实产物。
String readRdFile(String relativePath) {
  final File file = File('${Directory.current.path}/$relativePath');
  return file.readAsStringSync();
}

void main() {
  test('当前正式模块链路不再引用旧预览图与旧模块目录', () {
    final String taskFlowUiux = readRdFile(
      'docs/rd/modules/task-flow/task-flow.ui-ux.md',
    );
    final String historyCenterUiux = readRdFile(
      'docs/rd/modules/history-center/history-center.ui-ux.md',
    );
    final String widgetBridgeUiux = readRdFile(
      'docs/rd/modules/widget-bridge/widget-bridge.ui-ux.md',
    );
    final String architecturePack = readRdFile(
      'docs/rd/10-implementation-architecture-pack.md',
    );
    final String sharedArchitecturePack = readRdFile(
      'docs/rd/03-architecture-pack.md',
    );

    expect(taskFlowUiux, contains('home-page-light-refresh-v2.png'));
    expect(taskFlowUiux, contains('task-editor-refresh-v1.png'));
    expect(taskFlowUiux, isNot(contains('home-overview.png')));

    expect(historyCenterUiux, isNot(contains('recent-completed.png')));
    expect(historyCenterUiux, contains('history-center-refresh-v1.png'));

    expect(widgetBridgeUiux, contains('widget-bridge-refresh-v1.png'));
    expect(widgetBridgeUiux, isNot(contains('home-overview')));

    expect(architecturePack, contains('lib/features/app_shell'));
    expect(architecturePack, contains('lib/features/task_flow'));
    expect(architecturePack, contains('lib/features/history_center'));
    expect(architecturePack, contains('lib/features/widget_bridge'));
    expect(architecturePack, contains('lib/features/settings_center'));
    expect(architecturePack, isNot(contains('`lib/features/tasks`')));
    expect(architecturePack, isNot(contains('`lib/features/history`')));
    expect(architecturePack, isNot(contains('`lib/features/quick_add`')));
    expect(architecturePack, isNot(contains('`lib/features/settings`')));

    expect(sharedArchitecturePack, isNot(contains('home-overview.png')));
    expect(sharedArchitecturePack, isNot(contains('recent-completed.png')));
  });

  test('缺图模块已补齐模块级效果图并接回文档', () {
    final String appShellUiux = readRdFile(
      'docs/rd/modules/app-shell/app-shell.ui-ux.md',
    );
    final String historyCenterUiux = readRdFile(
      'docs/rd/modules/history-center/history-center.ui-ux.md',
    );
    final String widgetBridgeUiux = readRdFile(
      'docs/rd/modules/widget-bridge/widget-bridge.ui-ux.md',
    );
    final String sharedPacket = readRdFile('docs/rd/02-shared-design-packet.md');

    final File appShellPreview = File(
      '${Directory.current.path}/docs/rd/modules/app-shell/app-shell-refresh-v1.png',
    );
    final File historyCenterPreview = File(
      '${Directory.current.path}/docs/rd/modules/history-center/history-center-refresh-v1.png',
    );
    final File widgetBridgePreview = File(
      '${Directory.current.path}/docs/rd/modules/widget-bridge/widget-bridge-refresh-v1.png',
    );

    expect(appShellPreview.existsSync(), isTrue);
    expect(historyCenterPreview.existsSync(), isTrue);
    expect(widgetBridgePreview.existsSync(), isTrue);

    expect(appShellUiux, contains('app-shell-refresh-v1.png'));
    expect(historyCenterUiux, contains('history-center-refresh-v1.png'));
    expect(widgetBridgeUiux, contains('widget-bridge-refresh-v1.png'));

    expect(sharedPacket, contains('app-shell-refresh-v1.png'));
    expect(sharedPacket, contains('history-center-refresh-v1.png'));
    expect(sharedPacket, contains('widget-bridge-refresh-v1.png'));
    expect(sharedPacket, isNot(contains('当前不要求模块私有静态图')));
  });
}
