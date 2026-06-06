// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_snapshot_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WidgetSnapshotItem _$WidgetSnapshotItemFromJson(Map<String, dynamic> json) =>
    _WidgetSnapshotItem(
      title: json['title'] as String,
      statusLabel: json['statusLabel'] as String,
      dueLabel: json['dueLabel'] as String,
      isPinned: json['isPinned'] as bool,
      isOverdue: json['isOverdue'] as bool,
      isPrivate: json['isPrivate'] as bool,
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$WidgetSnapshotItemToJson(_WidgetSnapshotItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'statusLabel': instance.statusLabel,
      'dueLabel': instance.dueLabel,
      'isPinned': instance.isPinned,
      'isOverdue': instance.isOverdue,
      'isPrivate': instance.isPrivate,
      'rank': instance.rank,
    };
