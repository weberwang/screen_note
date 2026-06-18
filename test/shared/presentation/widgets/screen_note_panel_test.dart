import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

void main() {
  testWidgets('ScreenNotePanel 在大屏设备上仍保持全局 22 圆角', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1290, 2796);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenNoteScreenUtilContract(
        designSize: screenNoteDesignSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            theme: ScreenNoteTheme.light(),
            home: const Scaffold(
              body: ScreenNotePanel(child: SizedBox(height: 80)),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    final Container panel = tester.widget<Container>(
      find.byType(Container).first,
    );
    final BoxDecoration decoration = panel.decoration! as BoxDecoration;
    final BorderRadius borderRadius = decoration.borderRadius! as BorderRadius;

    expect(borderRadius, BorderRadius.circular(22));
  });
}
