import 'package:freezed_annotation/freezed_annotation.dart';

import 'quick_add_draft.dart';

part 'quick_add_flow_result.freezed.dart';

/// 快速添加流程状态。
///
/// 阶段四所有轻入口、兜底页和系统回流都只通过这组状态沟通结果，
/// 避免页面层自行发明布尔标记导致恢复链路分叉。
enum QuickAddFlowStatus {
  openedQuickAdd,
  createdTask,
  savedDraft,
  returnedToApp,
  failedButRecovered,
}

/// 快速添加流程结果。
@freezed
abstract class QuickAddFlowResult with _$QuickAddFlowResult {
  /// 创建快速添加流程结果。
  const factory QuickAddFlowResult({
    required QuickAddFlowStatus status,
    QuickAddDraft? draft,
    String? taskId,
    String? routePath,
  }) = _QuickAddFlowResult;
}
