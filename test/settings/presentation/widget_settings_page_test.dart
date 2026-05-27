import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/app.dart';
import 'package:screen_note/features/widget_bridge/domain/enums/widget_display_mode.dart';
import 'package:screen_note/features/widget_bridge/domain/repositories/widget_display_mode_repository.dart';
import 'package:screen_note/features/widget_bridge/presentation/providers/widget_bridge_providers.dart';

/// 验证锁屏显示设置页的模式切换、预览和安装引导。
void main() {
  testWidgets('锁屏显示设置页支持模式切换并保存本地设置', (
    WidgetTester tester,
  ) async {
    final _FakeWidgetDisplayModeRepository repository =
        _FakeWidgetDisplayModeRepository(
          initialMode: WidgetDisplayMode.single,
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          widgetDisplayModeRepositoryProvider.overrideWithValue(repository),
        ],
        child: const ScreenNoteApp(
          locale: Locale('zh'),
          initialLocation: '/settings/widget',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('锁屏显示'), findsWidgets);
    expect(find.widgetWithText(ChoiceChip, '单条'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, '三条'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, '今日'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, '隐私'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, '空态'), findsOneWidget);
    expect(find.text('把它加到锁屏上'), findsOneWidget);

    await tester.tap(find.text('隐私'));
    await tester.pumpAndSettle();

    expect(repository.savedModes, <WidgetDisplayMode>[WidgetDisplayMode.private]);
    expect(find.text('已隐藏 3 条隐私事项'), findsOneWidget);
    expect(find.text('银行卡密码 2580'), findsNothing);
  });

  testWidgets('锁屏显示设置页在不同模式下切换预览内容', (
    WidgetTester tester,
  ) async {
    final _FakeWidgetDisplayModeRepository repository =
        _FakeWidgetDisplayModeRepository(
          initialMode: WidgetDisplayMode.single,
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          widgetDisplayModeRepositoryProvider.overrideWithValue(repository),
        ],
        child: const ScreenNoteApp(
          locale: Locale('zh'),
          initialLocation: '/settings/widget',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('完成锁屏小组件验收'), findsOneWidget);
    expect(find.text('置顶'), findsOneWidget);

    await tester.tap(find.text('三条'));
    await tester.pumpAndSettle();
    expect(find.text('确认三条模式的节奏'), findsOneWidget);
    expect(find.text('导出最后一次有效快照'), findsOneWidget);
    expect(find.text('确保隐私正文不外露'), findsOneWidget);

    await tester.tap(find.text('今日'));
    await tester.pumpAndSettle();
    expect(find.text('今天到期的事项保持可见'), findsOneWidget);
    expect(find.text('今天 18:00'), findsWidgets);

    await tester.tap(find.text('空态'));
    await tester.pumpAndSettle();
    expect(find.text('锁屏上还没有可展示的事项'), findsOneWidget);
    expect(find.text('刷新失败时保留最后有效内容'), findsOneWidget);
  });
}

class _FakeWidgetDisplayModeRepository implements WidgetDisplayModeRepository {
  _FakeWidgetDisplayModeRepository({required WidgetDisplayMode initialMode})
    : _mode = initialMode;

  WidgetDisplayMode _mode;
  final List<WidgetDisplayMode> savedModes = <WidgetDisplayMode>[];

  @override
  Future<WidgetDisplayMode> read() async => _mode;

  @override
  Future<void> save(WidgetDisplayMode mode) async {
    _mode = mode;
    savedModes.add(mode);
  }
}
