import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_bridge_runtime_providers.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot_item.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_stat_tile.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_toast.dart';

/// 小组件桥接页，负责承接安装引导、稳定快照预览与手动同步动作。
class WidgetBridgePage extends ConsumerWidget {
  /// 创建小组件桥接页。
  const WidgetBridgePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AsyncValue<WidgetSnapshot> snapshotAsync = ref.watch(
      widgetBridgeControllerProvider,
    );
    final bool canRequestPinWidget =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        ScreenNoteSpacing.pageHorizontal,
        12,
        ScreenNoteSpacing.pageHorizontal,
        112,
      ),
      children: <Widget>[
        _HeaderCard(
          title: localizations.settingsWidgetInstallTitle,
          subtitle: localizations.widgetSettingsSubtitle,
        ),
        const SizedBox(height: ScreenNoteSpacing.sectionGap),
        snapshotAsync.when(
          data: (WidgetSnapshot snapshot) {
            return _WidgetBridgeContent(snapshot: snapshot);
          },
          loading: () => const _LoadingCard(),
          error: (Object _, StackTrace _) => _ErrorCard(
            onRetry: () => ref.invalidate(widgetBridgeControllerProvider),
          ),
        ),
        const SizedBox(height: 16),
        _ActionCard(
          body: localizations.widgetSettingsSubtitle,
          canRequestPinWidget: canRequestPinWidget,
          onSync: () async {
            final bool synced = await ref
                .read(widgetBridgeControllerProvider.notifier)
                .syncSnapshot();
            if (!context.mounted) {
              return;
            }
            // 同步反馈统一走全局 Toast，避免桥接页出现和壳层不一致的提示样式。
            ScreenNoteToast.show(
              context,
              synced
                  ? localizations.widgetSyncSuccess
                  : localizations.widgetSyncFailed,
            );
          },
          onRequestPin: () => ref
              .read(settingsCenterControllerProvider.notifier)
              .requestPinWidget(
                requestedFeedbackText:
                    localizations.settingsWidgetInstallRequestedFeedback,
                unsupportedFeedbackText:
                    localizations.settingsWidgetInstallUnsupportedFeedback,
                failedFeedbackText:
                    localizations.settingsWidgetInstallFailedFeedback,
              ),
        ),
        const SizedBox(height: 16),
        _InfoCard(
          title: localizations.settingsWidgetInstallTitle,
          body: localizations.settingsWidgetInstallBody,
          icon: Icons.phone_iphone_outlined,
        ),
        const SizedBox(height: 16),
        _InfoCard(
          title: localizations.settingsPrivacyModeTitle,
          body: localizations.settingsPrivacyModeBody,
          icon: Icons.lock_outline_rounded,
        ),
      ],
    );
  }
}

/// 页面头部说明区，负责固定安装引导页的阅读起点。
class _HeaderCard extends StatelessWidget {
  /// 创建头部说明区。
  const _HeaderCard({required this.title, required this.subtitle});

  /// 标题。
  final String title;

  /// 副标题。
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 12),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

/// 页面主内容区，统一承接指标概览和真实小组件预览。
class _WidgetBridgeContent extends StatelessWidget {
  /// 创建主内容区。
  const _WidgetBridgeContent({required this.snapshot});

  /// 当前稳定快照。
  final WidgetSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final int privateItemCount = snapshot.items
        .where((item) => item.isPrivate)
        .length;
    final String previewSupportText = snapshot.hasFallbackContent
        ? snapshot.fallbackHint
        : localizations.widgetSnapshotOpenInApp;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool useCompactGrid = constraints.maxWidth < 400;
        final bool useStackedHeader = constraints.maxWidth < 360;

        // 指标卡和模式标签会在窄宽度下自动收紧，避免安装页视觉层级被挤散。
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GridView.count(
              crossAxisCount: useCompactGrid ? 2 : 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: useCompactGrid ? 1.45 : 1.1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                ScreenNoteStatTile(
                  label: localizations.widgetPreviewModeMetric,
                  value: _modeLabel(localizations, snapshot.displayMode),
                  icon: Icons.dashboard_customize_outlined,
                ),
                ScreenNoteStatTile(
                  label: localizations.widgetPreviewVisibleMetric,
                  value: '${snapshot.items.length}',
                  icon: Icons.visibility_outlined,
                ),
                ScreenNoteStatTile(
                  label: localizations.widgetPreviewPrivateMetric,
                  value: '$privateItemCount',
                  icon: Icons.lock_outline_rounded,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ScreenNotePanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (useStackedHeader)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          localizations.widgetSettingsTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _ModeChip(
                            label: _modeLabel(
                              localizations,
                              snapshot.displayMode,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            localizations.widgetSettingsTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _ModeChip(
                          label: _modeLabel(
                            localizations,
                            snapshot.displayMode,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 14),
                  _WidgetPreviewFrame(snapshot: snapshot),
                  const SizedBox(height: 12),
                  Text(
                    previewSupportText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.screenNotePalette.statusDone,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// 统一映射展示模式文案，避免页面散落多处判断。
  String _modeLabel(AppLocalizations localizations, WidgetDisplayMode mode) {
    return switch (mode) {
      WidgetDisplayMode.single => localizations.widgetDisplayModeSingle,
      WidgetDisplayMode.list3 => localizations.widgetDisplayModeList3,
      WidgetDisplayMode.today => localizations.widgetDisplayModeToday,
      WidgetDisplayMode.private => localizations.widgetDisplayModePrivate,
      WidgetDisplayMode.empty => localizations.widgetDisplayModeEmpty,
      WidgetDisplayMode.previewOnly =>
        localizations.settingsWidgetDisplayPreviewOnly,
      WidgetDisplayMode.fullContent =>
        localizations.settingsWidgetDisplayFullContent,
    };
  }
}

/// 预览框，用于在 App 内模拟当前小组件的阅读结构。
class _WidgetPreviewFrame extends StatelessWidget {
  /// 创建预览框。
  const _WidgetPreviewFrame({required this.snapshot});

  /// 当前快照。
  final WidgetSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: ScreenNoteRadii.panel,
        border: Border.all(color: palette.lineSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              snapshot.headerTitle,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            if (snapshot.items.isEmpty)
              _PreviewEmptyState(
                title: snapshot.emptyTitle,
                body: snapshot.emptyBody,
              )
            else if (snapshot.displayMode == WidgetDisplayMode.list3 ||
                snapshot.displayMode == WidgetDisplayMode.fullContent)
              Column(
                children: snapshot.items
                    .map(
                      (WidgetSnapshotItem item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PreviewItemRow(item: item),
                      ),
                    )
                    .toList(growable: false),
              )
            else
              _PreviewItemRow(item: snapshot.items.first, emphasize: true),
          ],
        ),
      ),
    );
  }
}

/// 单条预览行，用于模拟小组件中的标题、状态和序号层级。
class _PreviewItemRow extends StatelessWidget {
  /// 创建单条预览行。
  const _PreviewItemRow({required this.item, this.emphasize = false});

  /// 快照项。
  final WidgetSnapshotItem item;

  /// 是否作为主焦点项强调展示。
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.title,
                maxLines: emphasize ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: emphasize
                    ? Theme.of(context).textTheme.titleLarge
                    : Theme.of(context).textTheme.titleMedium,
              ),
              if (item.statusLabel.isNotEmpty ||
                  item.dueLabel.isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                Text(
                  [
                    item.statusLabel,
                    item.dueLabel,
                  ].where((segment) => segment.isNotEmpty).join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surfacePaper,
            borderRadius: ScreenNoteRadii.small,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              '${item.rank}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ],
    );
  }
}

/// 预览空态，保持平静提示而不是制造错误感。
class _PreviewEmptyState extends StatelessWidget {
  /// 创建空态视图。
  const _PreviewEmptyState({required this.title, required this.body});

  /// 标题。
  final String title;

  /// 正文。
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(body, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

/// 操作卡，统一承接手动同步动作与安装请求。
class _ActionCard extends StatelessWidget {
  /// 创建操作卡。
  const _ActionCard({
    required this.body,
    required this.onSync,
    required this.canRequestPinWidget,
    required this.onRequestPin,
  });

  /// 操作说明文案。
  final String body;

  /// 手动同步回调。
  final Future<void> Function() onSync;

  /// 是否允许请求添加小组件。
  final bool canRequestPinWidget;

  /// 请求添加小组件的动作。
  final Future<void> Function() onRequestPin;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.widgetFallbackPreviewTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const Key('widget-bridge-sync-button'),
              onPressed: onSync,
              icon: const Icon(Icons.sync_rounded),
              label: Text(localizations.widgetSyncAction),
            ),
          ),
          if (canRequestPinWidget) ...<Widget>[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                key: const Key('widget-bridge-install-button'),
                onPressed: onRequestPin,
                icon: const Icon(Icons.add_home_outlined),
                label: Text(localizations.settingsWidgetInstallAction),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 信息卡，用于承接安装说明与隐私说明这类次级提示。
class _InfoCard extends StatelessWidget {
  /// 创建信息卡。
  const _InfoCard({
    required this.title,
    required this.body,
    required this.icon,
  });

  /// 标题。
  final String title;

  /// 正文。
  final String body;

  /// 图标。
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return ScreenNotePanel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: palette.surfaceRaised,
              borderRadius: ScreenNoteRadii.insetSurface,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: palette.statusPrivate),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 模式标签，用于弱化呈现当前展示模式而不压过预览主体。
class _ModeChip extends StatelessWidget {
  /// 创建模式标签。
  const _ModeChip({required this.label});

  /// 文案。
  final String label;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: ScreenNoteRadii.small,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

/// 加载态卡片，保持页面结构稳定。
class _LoadingCard extends StatelessWidget {
  /// 创建加载态卡片。
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const ScreenNotePanel(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

/// 错误态卡片，允许用户留在当前页重试。
class _ErrorCard extends StatelessWidget {
  /// 创建错误态卡片。
  const _ErrorCard({required this.onRetry});

  /// 重试回调。
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.widgetSyncFailed,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRetry,
            child: Text(localizations.retryAction),
          ),
        ],
      ),
    );
  }
}
