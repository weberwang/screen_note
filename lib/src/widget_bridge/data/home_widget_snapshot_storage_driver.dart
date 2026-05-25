import 'package:home_widget/home_widget.dart';

import 'widget_snapshot_storage_driver.dart';

/// HomeWidget 共享存储驱动。
///
/// iOS 侧通过 App Group UserDefaults 读写共享数据；Flutter 侧统一从这里完成
/// group 配置、字符串保存和 Widget 更新时间线请求。
final class HomeWidgetSnapshotStorageDriver
    implements WidgetSnapshotStorageDriver {
  /// 创建 HomeWidget 共享存储驱动。
  const HomeWidgetSnapshotStorageDriver({
    required this.appGroupId,
    required this.iOSWidgetName,
  });

  /// iOS App Group 标识。
  final String appGroupId;

  /// iOS Widget kind 名称。
  final String iOSWidgetName;

  @override
  Future<String?> readString(String key) async {
    await _ensureAppGroup();
    return HomeWidget.getWidgetData<String>(key);
  }

  @override
  Future<void> reloadWidget() async {
    await _ensureAppGroup();
    final bool? updated = await HomeWidget.updateWidget(iOSName: iOSWidgetName);
    if (updated != true) {
      throw StateError('update_widget_failed');
    }
  }

  @override
  Future<void> writeString(String key, String value) async {
    await _ensureAppGroup();
    final bool? saved = await HomeWidget.saveWidgetData<String>(key, value);
    if (saved != true) {
      throw StateError('save_widget_data_failed');
    }
  }

  Future<void> _ensureAppGroup() async {
    final bool? configured = await HomeWidget.setAppGroupId(appGroupId);
    if (configured != true) {
      throw StateError('set_app_group_failed');
    }
  }
}
