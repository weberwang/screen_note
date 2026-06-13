// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_scaffold_stage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectScaffoldStage _$ProjectScaffoldStageFromJson(
  Map<String, dynamic> json,
) => _ProjectScaffoldStage(
  stageName: json['stageName'] as String,
  bootstrapCodeReady: json['bootstrapCodeReady'] as bool,
  featureCodeReady: json['featureCodeReady'] as bool,
);

Map<String, dynamic> _$ProjectScaffoldStageToJson(
  _ProjectScaffoldStage instance,
) => <String, dynamic>{
  'stageName': instance.stageName,
  'bootstrapCodeReady': instance.bootstrapCodeReady,
  'featureCodeReady': instance.featureCodeReady,
};
