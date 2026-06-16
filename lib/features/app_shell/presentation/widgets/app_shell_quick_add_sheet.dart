import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 共享壳层快速添加弹层只负责把用户送进正式编辑页，不直接承接录入逻辑。
class AppShellQuickAddSheet extends StatelessWidget {
  /// 创建共享壳层快速添加弹层。
  const AppShellQuickAddSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.quickAddSheetTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12.h),
            Text(
              localizations.quickAddSheetHint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 20.h),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.quickAddSheetContinue),
            ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.quickAddSheetDismiss),
            ),
          ],
        ),
      ),
    );
  }
}
