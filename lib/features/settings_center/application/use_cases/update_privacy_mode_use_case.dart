import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

/// 隐私模式更新用例，统一保证隐私开启后 Widget 展示不会停留在泄露正文的模式。
final class UpdatePrivacyModeUseCase {
  /// 创建隐私模式更新用例。
  const UpdatePrivacyModeUseCase({
    required SettingsPreferencesRepository repository,
    required SettingsSideEffectPort sideEffectPort,
  }) : _repository = repository,
       _sideEffectPort = sideEffectPort;

  final SettingsPreferencesRepository _repository;
  final SettingsSideEffectPort _sideEffectPort;

  /// 更新隐私模式。
  Future<SettingsCenterPreferences> execute({required bool enabled}) async {
    final current = await _repository.loadPreferences();
    final next = current.copyWith(
      privacyModeEnabled: enabled,
      widgetDisplayMode: enabled &&
              current.widgetDisplayMode == WidgetDisplayMode.fullContent
          ? WidgetDisplayMode.previewOnly
          : current.widgetDisplayMode,
    );
    await _repository.savePreferences(next);
    // 偏好保存成功后再触发桥接联动，确保 Widget 同步失败不会反向污染设置主链路。
    await _sideEffectPort.onPreferencesChanged(next);
    return next;
  }
}
