// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskEvent _$TaskEventFromJson(Map<String, dynamic> json) => _TaskEvent(
  id: json['id'] as String,
  taskId: json['taskId'] as String,
  action: $enumDecode(_$TaskEventActionEnumMap, json['action']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  metadata:
      json['metadata'] as Map<String, dynamic>? ?? const <String, Object?>{},
);

Map<String, dynamic> _$TaskEventToJson(_TaskEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'action': _$TaskEventActionEnumMap[instance.action]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$TaskEventActionEnumMap = {
  TaskEventAction.create: 'create',
  TaskEventAction.update: 'update',
  TaskEventAction.complete: 'complete',
  TaskEventAction.delete: 'delete',
  TaskEventAction.restore: 'restore',
  TaskEventAction.expire: 'expire',
};
