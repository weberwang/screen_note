// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_add_defaults.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuickAddDefaults _$QuickAddDefaultsFromJson(Map<String, dynamic> json) =>
    _QuickAddDefaults(
      dueAt: json['dueAt'] == null
          ? null
          : DateTime.parse(json['dueAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
      isPrivate: json['isPrivate'] as bool? ?? false,
    );

Map<String, dynamic> _$QuickAddDefaultsToJson(_QuickAddDefaults instance) =>
    <String, dynamic>{
      'dueAt': instance.dueAt?.toIso8601String(),
      'isPinned': instance.isPinned,
      'isPrivate': instance.isPrivate,
    };
