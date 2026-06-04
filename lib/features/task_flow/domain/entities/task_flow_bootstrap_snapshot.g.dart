// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_flow_bootstrap_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskFlowBootstrapSnapshot _$TaskFlowBootstrapSnapshotFromJson(
  Map<String, dynamic> json,
) => _TaskFlowBootstrapSnapshot(
  activePreviewCount: (json['activePreviewCount'] as num).toInt(),
  completedPreviewCount: (json['completedPreviewCount'] as num).toInt(),
  deletedPreviewCount: (json['deletedPreviewCount'] as num).toInt(),
  widgetProjectionReady: json['widgetProjectionReady'] as bool,
  privacySafeByDefault: json['privacySafeByDefault'] as bool,
);

Map<String, dynamic> _$TaskFlowBootstrapSnapshotToJson(
  _TaskFlowBootstrapSnapshot instance,
) => <String, dynamic>{
  'activePreviewCount': instance.activePreviewCount,
  'completedPreviewCount': instance.completedPreviewCount,
  'deletedPreviewCount': instance.deletedPreviewCount,
  'widgetProjectionReady': instance.widgetProjectionReady,
  'privacySafeByDefault': instance.privacySafeByDefault,
};
