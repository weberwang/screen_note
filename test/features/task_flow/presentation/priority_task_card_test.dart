import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/presentation/widgets/priority_task_card.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

void main() {
  group('PriorityTaskCard', () {
    testWidgets('今天到期时会同时显示状态语义和具体日期', (WidgetTester tester) async {
      final DateTime dueAt = DateTime.now().add(const Duration(hours: 2));

      await _pumpPriorityCard(
        tester,
        child: PriorityTaskCard(
          task: _buildTask(
            id: 'today-priority',
            title: '今天收尾首页状态',
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            dueAt: dueAt,
          ),
        ),
      );

      final BuildContext context = tester.element(
        find.byType(PriorityTaskCard),
      );
      final String expectedDate = MaterialLocalizations.of(
        context,
      ).formatMediumDate(dueAt);
      expect(find.text('今天收尾首页状态'), findsOneWidget);
      expect(find.text('今天截止'), findsOneWidget);
      expect(find.text(expectedDate), findsOneWidget);
      expect(find.text('继续处理'), findsOneWidget);
    });

    testWidgets('私密事项不会泄露真实标题和正文', (WidgetTester tester) async {
      await _pumpPriorityCard(
        tester,
        child: PriorityTaskCard(
          task: _buildTask(
            id: 'private-priority',
            title: '不该在首页露出的正文',
            note: '也不该直接看到这段备注',
            createdAt: DateTime(2026, 6, 14, 8),
            dueAt: DateTime(2026, 6, 14, 18),
            isPrivate: true,
          ),
        ),
      );

      expect(find.text('私密事项'), findsOneWidget);
      expect(find.text('不该在首页露出的正文'), findsNothing);
      expect(find.text('也不该直接看到这段备注'), findsNothing);
      expect(find.text('首页已隐藏内容'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    });

    testWidgets('空态时会保留开始添加动作', (WidgetTester tester) async {
      await _pumpPriorityCard(
        tester,
        child: const PriorityTaskCard(task: null),
      );

      expect(find.text('还没有待处理事项'), findsOneWidget);
      expect(find.text('开始添加'), findsOneWidget);
    });
  });
}

/// 统一泵起主卡片测试外壳，保证主题、本地化和 ScreenUtil 契约与正式环境一致。
Future<void> _pumpPriorityCard(
  WidgetTester tester, {
  required Widget child,
}) async {
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

/// 构造主卡片测试事项，避免绕开真实实体结构。
TaskEntity _buildTask({
  required String id,
  required String title,
  required DateTime createdAt,
  DateTime? dueAt,
  String note = '',
  bool isPrivate = false,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: note,
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
