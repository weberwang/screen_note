import 'package:screen_note/features/task_flow/application/ports/task_flow_degradation_hint_source.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_flow_degradation_hint.dart';

/// 空降级提示来源用于当前没有可用能力状态接线时的安全默认实现。
final class TaskFlowNoopDegradationHintSource
    implements TaskFlowDegradationHintSource {
  /// 创建空降级提示来源。
  const TaskFlowNoopDegradationHintSource();

  @override
  Future<List<TaskFlowDegradationHint>> loadHints() async {
    return const <TaskFlowDegradationHint>[];
  }
}
