import 'package:screen_note/features/task_flow/domain/entities/task_flow_degradation_hint.dart';

/// 首页降级提示来源只负责汇总可感知的能力降级，不把平台依赖直接暴露给任务首页用例。
abstract interface class TaskFlowDegradationHintSource {
  /// 读取当前应展示的首页降级提示列表。
  Future<List<TaskFlowDegradationHint>> loadHints();
}
