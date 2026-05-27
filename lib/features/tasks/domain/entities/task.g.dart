// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  title: json['title'] as String,
  note: json['note'] as String?,
  status: $enumDecode(_$TaskStatusEnumMap, json['status']),
  dueAt: json['dueAt'] == null ? null : DateTime.parse(json['dueAt'] as String),
  isPinned: json['isPinned'] as bool? ?? false,
  isPrivate: json['isPrivate'] as bool? ?? false,
  reminderMode:
      $enumDecodeNullable(_$TaskReminderModeEnumMap, json['reminderMode']) ??
      TaskReminderMode.normal,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'note': instance.note,
  'status': _$TaskStatusEnumMap[instance.status]!,
  'dueAt': instance.dueAt?.toIso8601String(),
  'isPinned': instance.isPinned,
  'isPrivate': instance.isPrivate,
  'reminderMode': _$TaskReminderModeEnumMap[instance.reminderMode]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
};

const _$TaskStatusEnumMap = {
  TaskStatus.active: 'active',
  TaskStatus.completed: 'completed',
  TaskStatus.deleted: 'deleted',
};

const _$TaskReminderModeEnumMap = {
  TaskReminderMode.normal: 'normal',
  TaskReminderMode.persistent: 'persistent',
};
