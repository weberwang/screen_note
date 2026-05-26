import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/src/quick_add/application/quick_add_defaults.dart';
import 'package:screen_note/src/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/src/quick_add/application/quick_add_entry_source.dart';
import 'package:screen_note/src/quick_add/data/quick_add_draft_store.dart';

/// 验证快速添加草稿存储接口与默认实现。
void main() {
  test('save 和 read 会保留草稿字段、默认值结果与修改痕迹', () async {
    final _RecordingQuickAddDraftStorageDriver driver =
        _RecordingQuickAddDraftStorageDriver();
    final QuickAddDraftStore store = QuickAddDraftStoreImpl(driver: driver);
    final QuickAddDraft draft = _buildChangedDraft();

    await store.save(draft);

    expect(
      driver.values[QuickAddDraftStoreImpl.draftStorageKey],
      isNotNull,
    );
    expect(await store.read(), draft);
  });

  test('save 会覆盖旧草稿并让 read 返回最新内容', () async {
    final _RecordingQuickAddDraftStorageDriver driver =
        _RecordingQuickAddDraftStorageDriver();
    final QuickAddDraftStore store = QuickAddDraftStoreImpl(driver: driver);

    await store.save(_buildChangedDraft());
    await store.save(
      QuickAddDraft.create(
        source: QuickAddEntrySource.fallback,
        defaults: const QuickAddDefaults(isPinned: true),
        timestamp: DateTime(2026, 5, 26, 11),
      ),
    );

    final QuickAddDraft? restored = await store.read();

    expect(restored?.source, QuickAddEntrySource.fallback);
    expect(restored?.isPinned, isTrue);
    expect(restored?.draftText, '');
  });

  test('clear 会清空已保存草稿', () async {
    final _RecordingQuickAddDraftStorageDriver driver =
        _RecordingQuickAddDraftStorageDriver();
    final QuickAddDraftStore store = QuickAddDraftStoreImpl(driver: driver);

    await store.save(_buildChangedDraft());
    await store.clear();

    expect(await store.read(), isNull);
    expect(
      driver.deletedKeys,
      contains(QuickAddDraftStoreImpl.draftStorageKey),
    );
  });

  test('read 遇到损坏 JSON 时返回 null 并清理坏草稿', () async {
    final _RecordingQuickAddDraftStorageDriver driver =
        _RecordingQuickAddDraftStorageDriver(
          values: <String, String>{
            QuickAddDraftStoreImpl.draftStorageKey: '{broken',
          },
        );
    final QuickAddDraftStore store = QuickAddDraftStoreImpl(driver: driver);

    expect(await store.read(), isNull);
    expect(driver.values, isEmpty);
    expect(
      driver.deletedKeys,
      contains(QuickAddDraftStoreImpl.draftStorageKey),
    );
  });
}

/// 构造一个带修改痕迹的快速添加草稿，方便复用断言。
QuickAddDraft _buildChangedDraft() {
  return QuickAddDraft.create(
    source: QuickAddEntrySource.lockScreen,
    defaults: QuickAddDefaults(
      dueAt: DateTime(2026, 5, 27, 9),
      isPrivate: true,
    ),
    timestamp: DateTime(2026, 5, 26, 8),
  ).applyChanges(
    draftText: '给妈妈买生日蛋糕',
    dueAt: DateTime(2026, 5, 27, 9),
    isPinned: true,
    isPrivate: true,
    timestamp: DateTime(2026, 5, 26, 8, 30),
  );
}

/// 记录读写行为的假驱动，用来隔离真实持久化细节。
class _RecordingQuickAddDraftStorageDriver
    implements QuickAddDraftStorageDriver {
  /// 创建一个带初始数据的快速添加草稿驱动桩。
  _RecordingQuickAddDraftStorageDriver({Map<String, String>? values})
    : values = values ?? <String, String>{};

  final Map<String, String> values;
  final List<String> deletedKeys = <String>[];

  @override
  Future<void> delete(String key) async {
    deletedKeys.add(key);
    values.remove(key);
  }

  @override
  Future<String?> readString(String key) async => values[key];

  @override
  Future<void> writeString(String key, String value) async {
    values[key] = value;
  }
}
