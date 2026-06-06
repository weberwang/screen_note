import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_bridge_runtime_providers.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot_item.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_stat_tile.dart';

/// Widget 桥接正式页，负责展示当前稳定快照预览并触发手动同步。
class WidgetBridgePage extends ConsumerWidget {
  /// 创建 Widget 桥接页。
  const WidgetBridgePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AsyncValue<WidgetSnapshot> snapshotAsync = ref.watch(
      widgetBridgeControllerProvider,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        ScreenNoteSpacing.pageHorizontal,
        12,
        ScreenNoteSpacing.pageHorizontal,
        112,
      ),
      children: <Widget>[
        _HeaderCard(
          title: localizations.widgetSettingsTitle,
          subtitle: localizations.widgetSettingsSubtitle,
        ),
        const SizedBox(height: ScreenNoteSpacing.sectionGap),
        snapshotAsync.when(
          data: (WidgetSnapshot snapshot) {
            return _WidgetBridgeContent(snapshot: snapshot);
          },
          loading: () => const _LoadingCard(),
          error: (Object _, StackTrace __) => _ErrorCard(
            onRetry: () => ref.invalidate(widgetBridgeControllerProvider),
          ),
        ),
        const SizedBox(height: 16),
        _ActionCard(
          onSync: () async {
            final bool synced = await ref
                .read(widgetBridgeControllerProvider.notifier)
                .syncSnapshot();
            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    synced
                        ? localizations.widgetSyncSuccess
                        : localizations.widgetSyncFailed,
                  ),
                ),
              );
          },
        ),
        const SizedBox(height: 16),
        _InfoCard(
          title: localizations.widgetInstallGuideTitle,
          body: localizations.widgetInstallGuideBody,
          icon: Icons.phone_iphone_outlined,
        ),
        const SizedBox(height: 16),
        _InfoCard(
          title: localizations.widgetPreviewMaskPrivateTitle,
          body: localizations.widgetPreviewMaskPrivateBody,
          icon: Icons.lock_outline_rounded,
        ),
      ],
    );
  }
}

/// 页首说明卡，固定预览页的阅读起点与范围边界。
class _HeaderCard extends StatelessWidget {
  /// 创建头部卡片。
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

/// 预览页主体内容，统一承接指标概览和真实锁屏快照预览。
class _WidgetBridgeContent extends StatelessWidget {
  /// 创建主体内容。
  const _WidgetBridgeContent({required this.snapshot});

  /// 当前快照。
  final WidgetSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final int privateItemCount = snapshot.items
        .where((item) => item.isPrivate)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
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
              Row(
                children: <Widget>[
                  Text(
                    localizations.widgetSettingsTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  _ModeChip(
                    label: _modeLabel(localizations, snapshot.displayMode),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _WidgetPreviewFrame(snapshot: snapshot),
              if (snapshot.hasFallbackContent) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  snapshot.fallbackHint,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// 统一映射展示模式文案，避免页面散落枚举 switch。
  String _modeLabel(AppLocalizations localizations, WidgetDisplayMode mode) {
    return switch (mode) {
      WidgetDisplayMode.single => localizations.widgetDisplayModeSingle,
      WidgetDisplayMode.list3 => localizations.widgetDisplayModeList3,
      WidgetDisplayMode.today => localizations.widgetDisplayModeToday,
      WidgetDisplayMode.private => localizations.widgetDisplayModePrivate,
      WidgetDisplayMode.empty => localizations.widgetDisplayModeEmpty,
    };
  }
}

/// 预览框，用于在 App 内模拟当前锁屏小组件的阅读结构。
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
        borderRadius: BorderRadius.circular(22),
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
            else if (snapshot.displayMode == WidgetDisplayMode.list3)
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

/// 单条预览项，用于模拟锁屏组件中的标题、状态和序号层级。
class _PreviewItemRow extends StatelessWidget {
  /// 创建预览项。
  const _PreviewItemRow({required this.item, this.emphasize = false});

  /// 快照项。
  final WidgetSnapshotItem item;

  /// 是否作为主焦点项强调显示。
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

/// 操作卡片，统一承接手动同步动作与同步失败时的保守说明。
class _ActionCard extends StatelessWidget {
  /// 创建操作卡片。
  const _ActionCard({required this.onSync});

  /// 手动同步回调。
  final Future<void> Function() onSync;

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
          Text(
            localizations.widgetPreviewFallbackHint,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const Key('widget-bridge-sync-button'),
            onPressed: onSync,
            icon: const Icon(Icons.sync_rounded),
            label: Text(localizations.widgetSyncAction),
          ),
        ],
      ),
    );
  }
}

/// 辅助信息卡片，统一呈现安装和隐私说明。
class _InfoCard extends StatelessWidget {
  /// 创建信息卡片。
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
              borderRadius: BorderRadius.circular(14),
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

/// 模式标签，弱化呈现当前展示模式而不让其压过真实预览本身。
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

/// 预览加载态，保持页面结构稳定。
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

/// 预览错误态，允许用户停留当前页重试。
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
