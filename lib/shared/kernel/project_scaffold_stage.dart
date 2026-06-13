import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_scaffold_stage.freezed.dart';
part 'project_scaffold_stage.g.dart';

/// 该实体只描述初始化脚手架完成度，
/// 用来验证 `freezed` 与 JSON 生成链，不承载真实业务状态。
@freezed
abstract class ProjectScaffoldStage with _$ProjectScaffoldStage {
  /// 记录当前目录初始化的阶段名称和后续代码阶段是否已开启。
  const factory ProjectScaffoldStage({
    required String stageName,
    required bool bootstrapCodeReady,
    required bool featureCodeReady,
  }) = _ProjectScaffoldStage;

  /// 从 JSON 恢复初始化阶段快照，便于后续脚手架检查和测试。
  factory ProjectScaffoldStage.fromJson(Map<String, dynamic> json) =>
      _$ProjectScaffoldStageFromJson(json);
}
