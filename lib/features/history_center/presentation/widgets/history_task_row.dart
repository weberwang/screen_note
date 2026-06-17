import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 历史事项行组件，统一承接标题、时间元信息和已删除分区的恢复动作。
class HistoryTaskRow extends StatelessWidget {
  /// 创建最近完成事项行。
  const HistoryTaskRow.completed({
    required this.task,
    required this.metadataText,
    super.key,
  }) : restoreLabel = null,
       onRestore = null,
       _tone = _HistoryRowTone.completed;

  /// 创建最近删除事项行。
  const HistoryTaskRow.deleted({
    required this.task,
    required this.metadataText,
    required this.restoreLabel,
    required this.onRestore,
    super.key,
  }) : _tone = _HistoryRowTone.deleted;

  /// 当前事项。
  final TaskEntity task;

  /// 次级时间元信息。
  final String metadataText;

  /// 恢复动作文案，仅最近删除分区需要。
  final String? restoreLabel;

  /// 恢复动作回调，仅最近删除分区需要。
  final VoidCallback? onRestore;

  final _HistoryRowTone _tone;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _HistoryRowToneStyle style = _tone.resolveStyle(context);
    final bool isDeletedPreview = onRestore != null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: style.iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              style.icon,
              size: 22.sp,
              color: style.foregroundColor,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  metadataText,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: style.metadataColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          if (isDeletedPreview)
            OutlinedButton(
              onPressed: onRestore,
              style: OutlinedButton.styleFrom(
                minimumSize: Size(106.w, 44.h),
                side: BorderSide(color: style.foregroundColor.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              ),
              child: Text(
                restoreLabel!,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: style.foregroundColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            Icon(
              Icons.chevron_right_rounded,
              size: 24.sp,
              color: style.metadataColor.withValues(alpha: 0.8),
            ),
        ],
      ),
    );
  }
}

enum _HistoryRowTone { completed, deleted }

/// 行语义样式只在组件内部使用，避免不同分区在页面层重复手写颜色逻辑。
final class _HistoryRowToneStyle {
  const _HistoryRowToneStyle({
    required this.icon,
    required this.foregroundColor,
    required this.metadataColor,
    required this.iconBackgroundColor,
  });

  final IconData icon;
  final Color foregroundColor;
  final Color metadataColor;
  final Color iconBackgroundColor;
}

extension on _HistoryRowTone {
  /// 根据行类型解析颜色语义，保持完成和删除分区既稳定又容易区分。
  _HistoryRowToneStyle resolveStyle(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    return switch (this) {
      _HistoryRowTone.completed => _HistoryRowToneStyle(
        icon: Icons.check_rounded,
        foregroundColor: palette.statusDone,
        metadataColor: palette.inkSecondary,
        iconBackgroundColor: palette.statusDone.withValues(alpha: 0.18),
      ),
      _HistoryRowTone.deleted => _HistoryRowToneStyle(
        icon: Icons.delete_outline_rounded,
        foregroundColor: palette.statusPrivate,
        metadataColor: palette.inkSecondary,
        iconBackgroundColor: palette.statusPrivate.withValues(alpha: 0.10),
      ),
    };
  }
}
