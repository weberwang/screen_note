import 'package:freezed_annotation/freezed_annotation.dart';

import 'quick_add_defaults.dart';
import 'quick_add_entry_source.dart';

part 'quick_add_draft.freezed.dart';
part 'quick_add_draft.g.dart';

/// 快速添加草稿实体。
///
/// 这份草稿是所有轻入口、失败回流与页面恢复共享的唯一上下文，
/// 只保留后续流程层真正需要的字段，避免把 UI 局部状态泄漏进应用契约。
@freezed
abstract class QuickAddDraft with _$QuickAddDraft {
  /// 创建快速添加草稿实体。
  const factory QuickAddDraft({
    @Default('') String draftText,
    required QuickAddEntrySource source,
    DateTime? dueAt,
    @Default(false) bool isPinned,
    @Default(false) bool isPrivate,
    @Default(false) bool hasUnsavedChanges,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _QuickAddDraft;

  /// 从 JSON 还原快速添加草稿。
  factory QuickAddDraft.fromJson(Map<String, Object?> json) =>
      _$QuickAddDraftFromJson(json);

  /// 用入口来源与默认值初始化一份新草稿。
  factory QuickAddDraft.create({
    required QuickAddEntrySource source,
    QuickAddDefaults? defaults,
    DateTime? timestamp,
    String draftText = '',
  }) {
    final DateTime effectiveTimestamp = timestamp ?? DateTime.now();
    final QuickAddDefaults effectiveDefaults =
        defaults ?? QuickAddDefaults.forSource(source);

    return QuickAddDraft(
      draftText: draftText,
      source: source,
      dueAt: effectiveDefaults.dueAt,
      isPinned: effectiveDefaults.isPinned,
      isPrivate: effectiveDefaults.isPrivate,
      hasUnsavedChanges: false,
      createdAt: effectiveTimestamp,
      updatedAt: effectiveTimestamp,
    );
  }
}

/// 快速添加草稿行为扩展。
extension QuickAddDraftX on QuickAddDraft {
  /// 应用草稿修改，并在内容变化时记录未保存痕迹。
  ///
  /// 这里把“改时间”和“清空时间”拆成两个强类型入口，避免调用方误传任意对象，
  /// 同时保留显式撤销截止时间的能力，减少后续页面层和系统桥接的歧义。
  QuickAddDraft applyChanges({
    String? draftText,
    DateTime? dueAt,
    bool clearDueAt = false,
    bool? isPinned,
    bool? isPrivate,
    DateTime? timestamp,
  }) {
    final String nextDraftText = draftText ?? this.draftText;
    final DateTime? nextDueAt = clearDueAt ? null : dueAt ?? this.dueAt;
    final bool nextIsPinned = isPinned ?? this.isPinned;
    final bool nextIsPrivate = isPrivate ?? this.isPrivate;

    final bool hasChanged =
        nextDraftText != this.draftText ||
        nextDueAt != this.dueAt ||
        nextIsPinned != this.isPinned ||
        nextIsPrivate != this.isPrivate;

    if (!hasChanged) {
      return this;
    }

    return copyWith(
      draftText: nextDraftText,
      dueAt: nextDueAt,
      isPinned: nextIsPinned,
      isPrivate: nextIsPrivate,
      hasUnsavedChanges: true,
      updatedAt: timestamp ?? DateTime.now(),
    );
  }
}
