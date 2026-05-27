import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 锁屏小组件安装引导卡片。
///
/// 阶段三只负责解释系统安装路径和刷新边界，不承诺即时刷新或系统权限结果，
/// 这样可以把系统能力降级约束直接固定在展示层文案里。
class WidgetInstallGuideCard extends StatelessWidget {
  /// 创建锁屏小组件安装引导卡片。
  const WidgetInstallGuideCard({
    super.key,
    required this.title,
    required this.body,
  });

  /// 卡片标题。
  final String title;

  /// 卡片说明正文。
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceMuted,
        borderRadius: ScreenNoteRadii.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
