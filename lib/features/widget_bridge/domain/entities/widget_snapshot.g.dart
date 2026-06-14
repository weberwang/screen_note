// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WidgetSnapshot _$WidgetSnapshotFromJson(Map<String, dynamic> json) =>
    _WidgetSnapshot(
      snapshotId: json['snapshotId'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      displayMode: $enumDecode(_$WidgetDisplayModeEnumMap, json['displayMode']),
      headerTitle: json['headerTitle'] as String,
      emptyTitle: json['emptyTitle'] as String,
      emptyBody: json['emptyBody'] as String,
      fallbackHint: json['fallbackHint'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => WidgetSnapshotItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasPrivateContent: json['hasPrivateContent'] as bool,
      hasFallbackContent: json['hasFallbackContent'] as bool,
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$WidgetSnapshotToJson(_WidgetSnapshot instance) =>
    <String, dynamic>{
      'snapshotId': instance.snapshotId,
      'generatedAt': instance.generatedAt.toIso8601String(),
      'displayMode': _$WidgetDisplayModeEnumMap[instance.displayMode]!,
      'headerTitle': instance.headerTitle,
      'emptyTitle': instance.emptyTitle,
      'emptyBody': instance.emptyBody,
      'fallbackHint': instance.fallbackHint,
      'items': instance.items,
      'hasPrivateContent': instance.hasPrivateContent,
      'hasFallbackContent': instance.hasFallbackContent,
      'version': instance.version,
    };

const _$WidgetDisplayModeEnumMap = {
  WidgetDisplayMode.previewOnly: 'previewOnly',
  WidgetDisplayMode.fullContent: 'fullContent',
};
