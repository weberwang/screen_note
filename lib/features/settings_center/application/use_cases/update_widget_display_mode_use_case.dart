import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

/// 展示模式更新用例，统一保证 Widget 展示模式不会绕开隐私模式。
final class UpdateWidgetDisplayModeUseCase {
  /// 创建展示模式更新用例。
  const UpdateWidgetDisplayModeUseCase({
    required SettingsPreferencesRepository repository,
    required SettingsSideEffectPort sideEffectPort,
  }) : _repository = repository,
       _sideEffectPort = sideEffectPort;

  final SettingsPreferencesRepository _repository;
  final SettingsSideEffectPort _sideEffectPort;

  /// 更新 Widget 展示模式。
  Future<SettingsCenterPreferences> execute({
    required WidgetDisplayMode mode,
  }) async {
    final current = await _repository.loadPreferences();
    final next = current.copyWith(
      widgetDisplayMode: current.privacyModeEnabled &&
              mode == WidgetDisplayMode.fullContent
          ? WidgetDisplayMode.previewOnly
          : mode,
    );
    await _repository.savePreferences(next);
    // 展示模式落库成功后立即联动共享快照，避免 Widget 停留在旧展示策略。
    await _sideEffectPort.onPreferencesChanged(next);
    return next;
  }
}
