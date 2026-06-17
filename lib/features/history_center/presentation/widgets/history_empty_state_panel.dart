import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 历史空态面板，强调事项仍然可追溯，而不是把空态做成空白区域。
class HistoryEmptyStatePanel extends StatelessWidget {
  /// 创建历史空态面板。
  const HistoryEmptyStatePanel({
    required this.title,
    required this.body,
    super.key,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 12.h),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF5F6762),
            ),
          ),
        ],
      ),
    );
  }
}
