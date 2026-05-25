import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/src/app/app.dart';
import 'package:screen_note/src/widget_bridge/domain/enums/widget_display_mode.dart';
import 'package:screen_note/src/widget_bridge/domain/repositories/widget_display_mode_repository.dart';
import 'package:screen_note/src/widget_bridge/presentation/providers/widget_bridge_providers.dart';

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
    expect(find.text('单条'), findsOneWidget);
    expect(find.text('三条'), findsOneWidget);
    expect(find.text('今天'), findsOneWidget);
    expect(find.text('隐私'), findsOneWidget);
    expect(find.text('空态'), findsOneWidget);
    expect(find.text('安装到锁屏'), findsOneWidget);

    await tester.tap(find.text('隐私'));
    await tester.pumpAndSettle();

    expect(repository.savedModes, <WidgetDisplayMode>[WidgetDisplayMode.private]);
    expect(find.text('已隐藏 3 条事项'), findsOneWidget);
    expect(find.text('银行卡密码 2580'), findsNothing);
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
