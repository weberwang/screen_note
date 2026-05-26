import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/src/quick_add/application/quick_add_defaults.dart';
import 'package:screen_note/src/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/src/quick_add/application/quick_add_entry_source.dart';

/// 验证快速添加草稿契约、默认值与修改痕迹。
void main() {
  test('create 会按默认值初始化快速添加草稿', () {
    final DateTime now = DateTime(2026, 5, 26, 9, 30);
    final DateTime dueAt = DateTime(2026, 5, 27, 8);

    final QuickAddDraft draft = QuickAddDraft.create(
      source: QuickAddEntrySource.controlCenter,
      defaults: QuickAddDefaults(
        dueAt: dueAt,
        isPinned: true,
        isPrivate: true,
      ),
      timestamp: now,
    );

    expect(draft.draftText, '');
    expect(draft.source, QuickAddEntrySource.controlCenter);
    expect(draft.dueAt, dueAt);
    expect(draft.isPinned, isTrue);
    expect(draft.isPrivate, isTrue);
    expect(draft.hasUnsavedChanges, isFalse);
    expect(draft.createdAt, now);
    expect(draft.updatedAt, now);
  });

  test('applyChanges 会在字段变化时保留创建时间并记录修改痕迹', () {
    final DateTime createdAt = DateTime(2026, 5, 26, 9);
    final DateTime updatedAt = DateTime(2026, 5, 26, 10, 15);
    final DateTime dueAt = DateTime(2026, 5, 28, 18);
    final QuickAddDraft original = QuickAddDraft.create(
      source: QuickAddEntrySource.home,
      timestamp: createdAt,
    );

    final QuickAddDraft changed = original.applyChanges(
      draftText: '买牛奶',
      dueAt: dueAt,
      isPinned: true,
      isPrivate: false,
      timestamp: updatedAt,
    );

    expect(changed.draftText, '买牛奶');
    expect(changed.source, QuickAddEntrySource.home);
    expect(changed.dueAt, dueAt);
    expect(changed.isPinned, isTrue);
    expect(changed.isPrivate, isFalse);
    expect(changed.hasUnsavedChanges, isTrue);
    expect(changed.createdAt, createdAt);
    expect(changed.updatedAt, updatedAt);
  });

  test('applyChanges 在没有实际修改时保持原草稿不变', () {
    final DateTime now = DateTime(2026, 5, 26, 9);
    final QuickAddDraft original = QuickAddDraft.create(
      source: QuickAddEntrySource.deepLink,
      defaults: const QuickAddDefaults(isPinned: true),
      timestamp: now,
    );

    final QuickAddDraft unchanged = original.applyChanges(
      draftText: '',
      dueAt: null,
      isPinned: true,
      isPrivate: false,
      timestamp: now.add(const Duration(minutes: 5)),
    );

    expect(unchanged, same(original));
  });

  test('applyChanges 支持显式清空原本存在的截止时间', () {
    final DateTime createdAt = DateTime(2026, 5, 26, 9);
    final DateTime updatedAt = DateTime(2026, 5, 26, 9, 20);
    final QuickAddDraft original = QuickAddDraft.create(
      source: QuickAddEntrySource.fallback,
      defaults: QuickAddDefaults(dueAt: DateTime(2026, 5, 27, 8)),
      timestamp: createdAt,
    );

    final QuickAddDraft changed = original.applyChanges(
      clearDueAt: true,
      timestamp: updatedAt,
    );

    expect(changed.dueAt, isNull);
    expect(changed.hasUnsavedChanges, isTrue);
    expect(changed.createdAt, createdAt);
    expect(changed.updatedAt, updatedAt);
  });

  test('JSON 往返会保留来源、默认值结果与修改痕迹字段', () {
    final DateTime createdAt = DateTime(2026, 5, 26, 9);
    final DateTime updatedAt = DateTime(2026, 5, 26, 9, 45);
    final QuickAddDraft draft = QuickAddDraft.create(
      source: QuickAddEntrySource.appIntent,
      defaults: QuickAddDefaults(
        dueAt: DateTime(2026, 5, 27, 12),
        isPrivate: true,
      ),
      timestamp: createdAt,
    ).applyChanges(
      draftText: '给家里打电话',
      dueAt: DateTime(2026, 5, 27, 12),
      isPinned: false,
      isPrivate: true,
      timestamp: updatedAt,
    );

    final QuickAddDraft roundTrip = QuickAddDraft.fromJson(draft.toJson());

    expect(roundTrip, draft);
  });

  test('入口来源枚举与来源默认值策略保持阶段四白名单', () {
    expect(
      QuickAddEntrySource.values
          .map((QuickAddEntrySource source) => quickAddEntrySourceJsonMap[source])
          .toList(growable: false),
      <String>[
        'home',
        'appIntent',
        'controlCenter',
        'lockScreen',
        'actionButton',
        'deepLink',
        'fallback',
      ],
    );

    for (final QuickAddEntrySource source in QuickAddEntrySource.values) {
      expect(QuickAddDefaults.forSource(source), const QuickAddDefaults());
    }
  });
}
