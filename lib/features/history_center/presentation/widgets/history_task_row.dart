import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';

/// 历史事项行组件，统一承接标题、时间元信息和已删除分区的恢复动作。
class HistoryTaskRow extends StatelessWidget {
  /// 创建最近完成事项行。
  const HistoryTaskRow.completed({
    required this.task,
    required this.metadataText,
    super.key,
  }) : restoreLabel = null,
       onRestore = null;

  /// 创建最近删除事项行。
  const HistoryTaskRow.deleted({
    required this.task,
    required this.metadataText,
    required this.restoreLabel,
    required this.onRestore,
    super.key,
  });

  /// 当前事项。
  final TaskEntity task;

  /// 次级时间元信息。
  final String metadataText;

  /// 恢复动作文案，仅最近删除分区需要。
  final String? restoreLabel;

  /// 恢复动作回调，仅最近删除分区需要。
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDeletedPreview = onRestore != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  metadataText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF5F6762),
                  ),
                ),
              ],
            ),
          ),
          if (isDeletedPreview) ...<Widget>[
            SizedBox(width: 12.w),
            OutlinedButton(
              onPressed: onRestore,
              child: Text(restoreLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
