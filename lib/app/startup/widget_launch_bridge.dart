import 'dart:async';

import 'package:home_widget/home_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'widget_launch_bridge.g.dart';

/// Widget 回流桥接，统一隔离 HomeWidget 点击事件与初始启动 URI 读取。
abstract interface class WidgetLaunchBridge {
  /// 读取应用是否由 Widget 首次唤起。
  Future<Uri?> initiallyLaunchedUri();

  /// 监听运行中来自 Widget 的点击回流事件。
  Stream<Uri?> get widgetClicked;
}

/// HomeWidget 版桥接实现，直接复用插件提供的启动 URI 与点击事件流。
final class HomeWidgetLaunchBridge implements WidgetLaunchBridge {
  /// 创建 HomeWidget 版桥接实现。
  const HomeWidgetLaunchBridge();

  @override
  Future<Uri?> initiallyLaunchedUri() {
    return HomeWidget.initiallyLaunchedFromHomeWidget();
  }

  @override
  Stream<Uri?> get widgetClicked => HomeWidget.widgetClicked;
}

/// Widget 回流桥接提供器，允许测试替换启动 URI 和点击事件。
@riverpod
WidgetLaunchBridge widgetLaunchBridge(Ref ref) {
  return const HomeWidgetLaunchBridge();
}
