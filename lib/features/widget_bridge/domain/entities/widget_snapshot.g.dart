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
      'items': instance.items,
      'hasPrivateContent': instance.hasPrivateContent,
      'hasFallbackContent': instance.hasFallbackContent,
      'version': instance.version,
    };

const _$WidgetDisplayModeEnumMap = {
  WidgetDisplayMode.single: 'single',
  WidgetDisplayMode.list3: 'list3',
  WidgetDisplayMode.today: 'today',
  WidgetDisplayMode.private: 'private',
  WidgetDisplayMode.empty: 'empty',
};
