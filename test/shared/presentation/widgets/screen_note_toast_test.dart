import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_toast.dart';

void main() {
  testWidgets('ScreenNoteToast 会展示 iOS 风格 HUD 并在计时结束后消失', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenNoteScreenUtilContract(
        designSize: screenNoteDesignSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            theme: ScreenNoteTheme.light(),
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return Center(
                    child: FilledButton(
                      onPressed: () {
                        ScreenNoteToast.show(
                          context,
                          '测试提示',
                          duration: const Duration(milliseconds: 1200),
                        );
                      },
                      child: const Text('show'),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );

    await tester.tap(find.text('show'));
    await tester.pump();

    expect(find.byType(CupertinoPopupSurface), findsOneWidget);
    expect(find.text('测试提示'), findsOneWidget);
    expect(find.byType(FadeTransition), findsWidgets);
    expect(find.byType(ScaleTransition), findsWidgets);

    await tester.pump(const Duration(milliseconds: 900));
    expect(find.byType(CupertinoPopupSurface), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.byType(CupertinoPopupSurface), findsNothing);
  });
}
