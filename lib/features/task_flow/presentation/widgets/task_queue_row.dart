import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 首页紧急队列行，只负责渲染单条事项的标题与最小元信息。
class TaskQueueRow extends StatelessWidget {
  /// 创建队列行。
  const TaskQueueRow({
    required this.task,
    required this.isOverdue,
    this.onTap,
    super.key,
  });

  /// 行内展示的事项。
  final TaskEntity task;

  /// 是否按逾期高风险样式展示。
  final bool isOverdue;

  /// 点击行后的导航由页面层决定，组件只暴露用户意图。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final Color accentColor = isOverdue
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32.r),
        child: ScreenNotePanel(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          child: Row(
            children: <Widget>[
              Icon(
                isOverdue ? Icons.error_outline_rounded : Icons.schedule_rounded,
                color: accentColor,
                size: 20.sp,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _buildMeta(localizations),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 队列元信息只做展示文案拼装，避免页面层重复做状态分组判断。
  String _buildMeta(AppLocalizations localizations) {
    if (task.isPrivate) {
      return localizations.taskFlowPrivateTaskHint;
    }
    final DateTime? dueAt = task.dueAt;
    if (dueAt == null) {
      return localizations.taskFlowNoDueDate;
    }
    final String formatted = DateFormat(
      'M/d HH:mm',
      localizations.localeName,
    ).format(dueAt);
    return isOverdue
        ? localizations.taskFlowOverdueAtLabel(formatted)
        : localizations.taskFlowDueAtLabel(formatted);
  }
}
