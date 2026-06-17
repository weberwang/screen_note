import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_flow_degradation_hint.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 首页状态提示只表达非阻断降级信息，保持主事项与队列结构继续可见。
class TaskFlowHomeStatusNotice extends StatelessWidget {
  /// 创建首页状态提示。
  const TaskFlowHomeStatusNotice({required this.hints, super.key});

  /// 当前首页需要提示的降级状态集合。
  final List<TaskFlowDegradationHint> hints;

  @override
  Widget build(BuildContext context) {
    if (hints.isEmpty) {
      return const SizedBox.shrink();
    }

    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final List<String> messages = _buildMessages(localizations);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4EE),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFECE4),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: const Color(0xFFE96A5A),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  localizations.taskFlowHomeDegradationTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFE96A5A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                for (final String message in messages) ...<Widget>[
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFB45447),
                    ),
                  ),
                  if (message != messages.last) SizedBox(height: 4.h),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 降级提示文案在页面层统一映射，避免领域枚举直接承载最终展示语言。
  List<String> _buildMessages(AppLocalizations localizations) {
    return hints
        .toSet()
        .map((TaskFlowDegradationHint hint) {
          return switch (hint) {
            TaskFlowDegradationHint.notificationPermissionDenied =>
              localizations.taskFlowHomePermissionDegradationBody,
            TaskFlowDegradationHint.refreshFailed =>
              localizations.taskFlowHomeRefreshDegradationBody,
          };
        })
        .toList(growable: false);
  }
}
