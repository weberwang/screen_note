import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/shared/kernel/project_scaffold_stage.dart';

/// 该测试只验证初始化阶段的代码生成产物可被消费，
/// 不代表项目已经具备真实启动链路。
void main() {
  test('project scaffold stage supports freezed json roundtrip', () {
    const stage = ProjectScaffoldStage(
      stageName: 'project_initialized',
      bootstrapCodeReady: false,
      featureCodeReady: false,
    );

    final json = stage.toJson();
    final restored = ProjectScaffoldStage.fromJson(json);

    expect(restored, stage);
  });
}

