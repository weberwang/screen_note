import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/presentation/widgets/task_queue_row.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

void main() {
  group('TaskQueueRow', () {
    testWidgets('普通后续事项使用空心圆图标和简短日期文案', (WidgetTester tester) async {
      final DateTime dueAt = DateTime(2026, 6, 16, 9);

      await _pumpQueueRow(
        tester,
        child: TaskQueueRow(
          task: _buildTask(
            id: 'future-task',
            title: '未来后续事项',
            createdAt: DateTime(2026, 6, 14, 8),
            dueAt: dueAt,
          ),
          isOverdue: false,
        ),
      );

      final BuildContext context = tester.element(find.byType(TaskQueueRow));
      final String expectedDate = MaterialLocalizations.of(
        context,
      ).formatMediumDate(dueAt);
      expect(find.byIcon(Icons.radio_button_unchecked_rounded), findsOneWidget);
      expect(find.text('未来后续事项'), findsOneWidget);
      expect(find.text(expectedDate), findsOneWidget);
      expect(find.textContaining('截止'), findsNothing);
    });

    testWidgets('私密事项队列行不会泄露真实标题', (WidgetTester tester) async {
      await _pumpQueueRow(
        tester,
        child: TaskQueueRow(
          task: _buildTask(
            id: 'private-task',
            title: '不该直接显示的真实标题',
            createdAt: DateTime(2026, 6, 14, 8),
            isPrivate: true,
          ),
          isOverdue: false,
        ),
      );

      expect(find.text('私密事项'), findsOneWidget);
      expect(find.text('不该直接显示的真实标题'), findsNothing);
      expect(find.text('首页已隐藏内容'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    });
  });
}

/// 统一泵起队列行测试外壳，保证主题、本地化和 ScreenUtil 契约与正式环境一致。
Future<void> _pumpQueueRow(WidgetTester tester, {required Widget child}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1170, 2532);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenNoteScreenUtilContract(
      designSize: screenNoteDesignSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? _) {
        return MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ScreenNoteTheme.light(),
          darkTheme: ScreenNoteTheme.dark(),
          home: Scaffold(body: child),
        );
      },
    ),
  );
  await tester.pumpAndSettle();
}

/// 构造队列行测试事项，避免绕开真实实体结构。
TaskEntity _buildTask({
  required String id,
  required String title,
  required DateTime createdAt,
  DateTime? dueAt,
  bool isPrivate = false,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: '',
    dueAt: dueAt,
    reminderAt: null,
    isPinned: false,
    isPrivate: isPrivate,
    status: TaskStatus.active,
    reminderMode: TaskReminderMode.normal,
    createdAt: createdAt,
    updatedAt: createdAt,
    completedAt: null,
    deletedAt: null,
  );
}
