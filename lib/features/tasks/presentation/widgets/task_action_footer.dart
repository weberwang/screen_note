import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 任务详情与编辑页共用的底部动作区。
///
/// 这个组件固定“一个主动作 + 一行次动作”的层级，
/// 避免保存、完成、删除在不同页面里被做成同权重竞争。
class TaskActionFooter extends StatelessWidget {
  /// 创建底部动作区。
  const TaskActionFooter({
    super.key,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.isPrimaryBusy = false,
    this.primaryEnabled = true,
    this.secondaryActions = const <Widget>[],
  });

  /// 主按钮文案。
  final String primaryLabel;

  /// 主按钮点击动作。
  final VoidCallback? onPrimaryPressed;

  /// 主按钮是否展示忙碌状态。
  final bool isPrimaryBusy;

  /// 主按钮是否可用。
  final bool primaryEnabled;

  /// 次级动作列表。
  final List<Widget> secondaryActions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FilledButton(
          onPressed: primaryEnabled && !isPrimaryBusy ? onPrimaryPressed : null,
          child: isPrimaryBusy
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(primaryLabel),
        ),
        if (secondaryActions.isNotEmpty) ...<Widget>[
          const SizedBox(height: ScreenNoteSpacing.compactGap),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 12,
            runSpacing: 12,
            children: secondaryActions,
          ),
        ],
      ],
    );
  }
}
