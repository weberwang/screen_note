import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/home_widget_snapshot_storage_driver.dart';
import '../../data/widget_display_mode_repository_impl.dart';
import '../../data/widget_snapshot_storage_driver.dart';
import '../../data/widget_snapshot_store_impl.dart';
import '../../domain/enums/widget_display_mode.dart';
import '../../domain/repositories/widget_display_mode_repository.dart';
import '../../domain/repositories/widget_snapshot_store.dart';

/// iOS App Group 标识。
const String screenNoteWidgetAppGroupId = 'group.com.example.screenNote.shared';

/// iOS Widget kind 名称。
const String screenNoteWidgetKind = 'ScreenNoteLockScreenWidget';

/// Widget 展示模式仓储提供器。
final Provider<WidgetDisplayModeRepository> widgetDisplayModeRepositoryProvider =
    Provider<WidgetDisplayModeRepository>((Ref ref) {
      return WidgetDisplayModeRepositoryImpl(
        preferencesLoader: SharedPreferences.getInstance,
      );
    });

/// 当前 Widget 展示模式提供器。
final FutureProvider<WidgetDisplayMode> widgetDisplayModeProvider =
    FutureProvider<WidgetDisplayMode>((Ref ref) {
      return ref.watch(widgetDisplayModeRepositoryProvider).read();
    });

/// Widget 底层共享存储驱动提供器。
final Provider<WidgetSnapshotStorageDriver> widgetSnapshotStorageDriverProvider =
    Provider<WidgetSnapshotStorageDriver>((Ref ref) {
      return const HomeWidgetSnapshotStorageDriver(
        appGroupId: screenNoteWidgetAppGroupId,
        iOSWidgetName: screenNoteWidgetKind,
      );
    });

/// Widget 快照仓储提供器。
final Provider<WidgetSnapshotStore> widgetSnapshotStoreProvider =
    Provider<WidgetSnapshotStore>((Ref ref) {
      return WidgetSnapshotStoreImpl(
        driver: ref.watch(widgetSnapshotStorageDriverProvider),
      );
    });
