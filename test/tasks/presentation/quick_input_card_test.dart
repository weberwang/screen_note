import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/features/tasks/presentation/widgets/quick_input_card.dart';

/// 验证快速输入卡保留设计稿里的次级取消动作。
void main() {
  testWidgets('快速输入卡展示取消按钮', (WidgetTester tester) async {
    await tester.pumpWidget(
      const _TestApp(
        child: QuickInputCard(
          isSubmitting: false,
          onSubmit: _onSubmit,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('取消'), findsOneWidget);
  });
}

Future<void> _onSubmit(String value) async {}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('zh'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildScreenNoteLightTheme(),
      darkTheme: buildScreenNoteDarkTheme(),
      home: Scaffold(body: Center(child: child)),
    );
  }
}
