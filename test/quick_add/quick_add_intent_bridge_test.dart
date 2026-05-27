import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/features/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/features/quick_add/application/quick_add_entry_source.dart';
import 'package:screen_note/features/quick_add/data/quick_add_intent_bridge.dart';

/// 验证系统入口待处理草稿桥接。
void main() {
  test('savePendingDraft 和 consumePendingDraft 会完整往返草稿', () async {
    final _MemoryQuickAddIntentStorageDriver driver =
        _MemoryQuickAddIntentStorageDriver();
    final QuickAddIntentBridge bridge = QuickAddIntentBridgeImpl(driver: driver);
    final QuickAddDraft draft = QuickAddDraft.create(
      source: QuickAddEntrySource.appIntent,
      draftText: '记得带工牌',
      timestamp: DateTime(2026, 5, 26, 11),
    );

    await bridge.savePendingDraft(draft);
    final QuickAddDraft? restored = await bridge.consumePendingDraft();

    expect(restored, draft);
    expect(
      driver.values[QuickAddIntentBridgeImpl.pendingDraftStorageKey],
      '',
    );
  });

  test('consumePendingDraft 遇到损坏 JSON 时会清空共享值', () async {
    final _MemoryQuickAddIntentStorageDriver driver =
        _MemoryQuickAddIntentStorageDriver(
          values: <String, String>{
            QuickAddIntentBridgeImpl.pendingDraftStorageKey: '{broken',
          },
        );
    final QuickAddIntentBridge bridge = QuickAddIntentBridgeImpl(driver: driver);

    expect(await bridge.consumePendingDraft(), isNull);
    expect(
      driver.values[QuickAddIntentBridgeImpl.pendingDraftStorageKey],
      '',
    );
  });
}

class _MemoryQuickAddIntentStorageDriver implements QuickAddIntentStorageDriver {
  _MemoryQuickAddIntentStorageDriver({Map<String, String>? values})
    : values = values ?? <String, String>{};

  final Map<String, String> values;

  @override
  Future<String?> readString(String key) async => values[key];

  @override
  Future<void> writeString(String key, String value) async {
    values[key] = value;
  }
}
