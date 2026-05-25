import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/src/widget_bridge/data/widget_snapshot_storage_driver.dart';
import 'package:screen_note/src/widget_bridge/data/widget_snapshot_store_impl.dart';
import 'package:screen_note/src/widget_bridge/domain/enums/widget_display_mode.dart';
import 'package:screen_note/src/widget_bridge/domain/models/widget_snapshot.dart';
import 'package:screen_note/src/widget_bridge/domain/models/widget_snapshot_item.dart';

/// 验证 Widget 快照共享存储实现。
void main() {
  test('保存快照时同时写入当前内容、最后有效内容并触发刷新', () async {
    final _RecordingStorageDriver driver = _RecordingStorageDriver();
    final WidgetSnapshotStoreImpl store = WidgetSnapshotStoreImpl(driver: driver);
    final WidgetSnapshot snapshot = _snapshot();

    await store.save(snapshot);

    expect(driver.values[WidgetSnapshotStoreImpl.currentSnapshotKey], isNotNull);
    expect(driver.values[WidgetSnapshotStoreImpl.lastValidSnapshotKey], isNotNull);
    expect(driver.reloadCount, 1);

    final WidgetSnapshot? current = await store.read();
    final WidgetSnapshot? lastValid = await store.readLastValid();
    expect(current, snapshot);
    expect(lastValid, snapshot);
  });

  test('保存 fallback 快照时不把 fallback 标记污染最后有效快照', () async {
    final _RecordingStorageDriver driver = _RecordingStorageDriver();
    final WidgetSnapshotStoreImpl store = WidgetSnapshotStoreImpl(driver: driver);
    final WidgetSnapshot fallbackSnapshot = _snapshot().copyWith(
      hasFallbackContent: true,
    );

    await store.save(fallbackSnapshot);

    final Map<String, Object?> currentJson = jsonDecode(
      driver.values[WidgetSnapshotStoreImpl.currentSnapshotKey]!,
    ) as Map<String, Object?>;
    final Map<String, Object?> lastValidJson = jsonDecode(
      driver.values[WidgetSnapshotStoreImpl.lastValidSnapshotKey]!,
    ) as Map<String, Object?>;

    expect(currentJson['hasFallbackContent'], isTrue);
    expect(lastValidJson['hasFallbackContent'], isFalse);
  });

  test('读取到损坏 JSON 时返回 null 而不是抛异常', () async {
    final _RecordingStorageDriver driver = _RecordingStorageDriver(
      values: <String, String>{
        WidgetSnapshotStoreImpl.currentSnapshotKey: '{broken',
        WidgetSnapshotStoreImpl.lastValidSnapshotKey: '{broken',
      },
    );
    final WidgetSnapshotStoreImpl store = WidgetSnapshotStoreImpl(driver: driver);

    expect(await store.read(), isNull);
    expect(await store.readLastValid(), isNull);
  });
}

WidgetSnapshot _snapshot() {
  return WidgetSnapshot(
    snapshotId: 'snapshot-1',
    generatedAt: DateTime(2026, 5, 25, 10),
    displayMode: WidgetDisplayMode.single,
    items: const <WidgetSnapshotItem>[
      WidgetSnapshotItem(
        title: '事项',
        statusLabel: '置顶',
        dueLabel: '',
        isPinned: true,
        isOverdue: false,
        isPrivate: false,
        rank: 1,
      ),
    ],
    hasPrivateContent: false,
    hasFallbackContent: false,
    version: 1,
  );
}

class _RecordingStorageDriver implements WidgetSnapshotStorageDriver {
  _RecordingStorageDriver({Map<String, String>? values})
    : values = values ?? <String, String>{};

  final Map<String, String> values;
  int reloadCount = 0;

  @override
  Future<String?> readString(String key) async => values[key];

  @override
  Future<void> reloadWidget() async {
    reloadCount += 1;
  }

  @override
  Future<void> writeString(String key, String value) async {
    values[key] = value;
  }
}
