import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

import 'package:screen_note/core/config/app_environment.dart';
import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';

/// HomeWidget 版快照存储，实现 Flutter 到系统 Widget 共享容器的数据写入。
final class HomeWidgetSnapshotStore implements WidgetSnapshotStore {
  /// 创建 HomeWidget 版快照存储。
  const HomeWidgetSnapshotStore({required AppLogger logger}) : _logger = logger;

  static const String _currentSnapshotKey =
      'screen_note.widget_snapshot.current';
  static const String _lastValidSnapshotKey =
      'screen_note.widget_snapshot.last_valid';
  static const String _iosWidgetName = 'ScreenNoteLockScreenWidget';
  static const String _androidWidgetName = 'ScreenNoteWidgetProvider';

  final AppLogger _logger;

  @override
  Future<bool> saveSnapshot(WidgetSnapshot snapshot) async {
    try {
      if (Platform.isIOS) {
        await HomeWidget.setAppGroupId(AppEnvironment.sharedAppGroupId);
      }

      final String payload = jsonEncode(snapshot.toJson());
      await HomeWidget.saveWidgetData<String>(_currentSnapshotKey, payload);
      await HomeWidget.saveWidgetData<String>(_lastValidSnapshotKey, payload);

      try {
        await HomeWidget.updateWidget(
          iOSName: _iosWidgetName,
          androidName: _androidWidgetName,
        );
      } on MissingPluginException {
        _logger.warning('widget_snapshot_refresh_missing_plugin');
      } on PlatformException {
        _logger.warning('widget_snapshot_refresh_platform_exception');
      }

      _logger.info('widget_snapshot_written');
      return true;
    } on MissingPluginException {
      _logger.warning('widget_snapshot_store_missing_plugin');
      return false;
    } on PlatformException {
      _logger.warning('widget_snapshot_store_platform_exception');
      return false;
    } catch (_) {
      _logger.warning('widget_snapshot_store_failed');
      return false;
    }
  }
}

/// 创建 HomeWidget 版存储实例。
WidgetSnapshotStore createWidgetSnapshotStore({required AppLogger logger}) {
  return HomeWidgetSnapshotStore(logger: logger);
}
