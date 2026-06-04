import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/features/settings_center/application/use_cases/load_settings_preferences_use_case.dart';
import 'package:screen_note/features/settings_center/application/use_cases/update_settings_preferences_use_case.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/infrastructure/settings_preferences_repository_impl.dart';
import 'package:screen_note/features/settings_center/infrastructure/settings_side_effect_noop_port.dart';

/// 验证 settings-center 的最小正式能力：偏好读取、写入与即时回显。
void main() {
  late SettingsPreferencesRepositoryImpl repository;
  late LoadSettingsPreferencesUseCase loadUseCase;
  late UpdateSettingsPreferencesUseCase updateUseCase;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    repository = SettingsPreferencesRepositoryImpl(preferences: preferences);
    loadUseCase = LoadSettingsPreferencesUseCase(repository: repository);
    updateUseCase = UpdateSettingsPreferencesUseCase(
      repository: repository,
      sideEffectPort: const SettingsSideEffectNoopPort(),
    );
  });

  test('默认偏好会采用隐私优先与三条展示样式', () async {
    final SettingsPreferences snapshot = await loadUseCase.execute();

    expect(snapshot.maskPrivateContent, isTrue);
    expect(snapshot.notificationsEnabled, isTrue);
    expect(snapshot.widgetDisplayMode, WidgetDisplayMode.list3);
  });

  test('更新偏好后会持久化隐私开关和锁屏样式', () async {
    await updateUseCase.execute(
      const SettingsPreferences(
        maskPrivateContent: false,
        notificationsEnabled: false,
        widgetDisplayMode: WidgetDisplayMode.today,
      ),
    );

    final SettingsPreferences snapshot = await loadUseCase.execute();
    expect(snapshot.maskPrivateContent, isFalse);
    expect(snapshot.notificationsEnabled, isFalse);
    expect(snapshot.widgetDisplayMode, WidgetDisplayMode.today);
  });
}
