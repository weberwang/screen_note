import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:screen_note/features/app_shell/presentation/widgets/app_shell_feedback_host.dart';
import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

void main() {
  testWidgets('壳层反馈会展示 iOS 风格动画并在时长结束后回调关闭', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    int closeCount = 0;

    await tester.pumpWidget(
      ScreenNoteScreenUtilContract(
        designSize: screenNoteDesignSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            theme: ScreenNoteTheme.light(),
            home: Scaffold(
              body: AppShellFeedbackHost(
                text: '设置已更新',
                dismissLabel: '关闭',
                duration: const Duration(milliseconds: 1200),
                onClose: () {
                  closeCount += 1;
                },
              ),
            ),
          );
        },
      ),
    );

    await tester.pump();

    expect(find.byType(CupertinoPopupSurface), findsOneWidget);
    expect(find.text('设置已更新'), findsOneWidget);
    expect(find.byType(FadeTransition), findsWidgets);
    expect(find.byType(ScaleTransition), findsWidgets);

    await tester.pump(const Duration(milliseconds: 900));
    expect(closeCount, 0);

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(closeCount, 1);
  });
}
