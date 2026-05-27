// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_add_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuickAddDraft _$QuickAddDraftFromJson(Map<String, dynamic> json) =>
    _QuickAddDraft(
      draftText: json['draftText'] as String? ?? '',
      source: $enumDecode(_$QuickAddEntrySourceEnumMap, json['source']),
      dueAt: json['dueAt'] == null
          ? null
          : DateTime.parse(json['dueAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
      isPrivate: json['isPrivate'] as bool? ?? false,
      hasUnsavedChanges: json['hasUnsavedChanges'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$QuickAddDraftToJson(_QuickAddDraft instance) =>
    <String, dynamic>{
      'draftText': instance.draftText,
      'source': _$QuickAddEntrySourceEnumMap[instance.source]!,
      'dueAt': instance.dueAt?.toIso8601String(),
      'isPinned': instance.isPinned,
      'isPrivate': instance.isPrivate,
      'hasUnsavedChanges': instance.hasUnsavedChanges,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$QuickAddEntrySourceEnumMap = {
  QuickAddEntrySource.home: 'home',
  QuickAddEntrySource.appIntent: 'appIntent',
  QuickAddEntrySource.controlCenter: 'controlCenter',
  QuickAddEntrySource.lockScreen: 'lockScreen',
  QuickAddEntrySource.actionButton: 'actionButton',
  QuickAddEntrySource.deepLink: 'deepLink',
  QuickAddEntrySource.fallback: 'fallback',
};
