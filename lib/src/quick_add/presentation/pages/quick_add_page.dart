import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/app/route_paths.dart';
import 'package:screen_note/src/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/src/quick_add/application/quick_add_entry_source.dart';
import 'package:screen_note/src/quick_add/application/quick_add_flow_result.dart';
import 'package:screen_note/src/quick_add/presentation/providers/quick_add_providers.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_scaffold.dart';
import 'package:screen_note/src/tasks/presentation/providers/task_feature_providers.dart';

import '../widgets/quick_add_default_option_row.dart';
import '../widgets/quick_add_error_hint.dart';
import '../widgets/quick_add_input.dart';
import '../widgets/quick_add_non_blocking_hint.dart';
import '../widgets/quick_add_source_chip.dart';

/// 阶段四统一快速添加兜底页。
class QuickAddPage extends ConsumerStatefulWidget {
  /// 创建阶段四统一快速添加兜底页。
  const QuickAddPage({
    super.key,
    this.initialDraft,
  });

  /// 路由或系统回流注入的初始草稿。
  final QuickAddDraft? initialDraft;

  @override
  ConsumerState<QuickAddPage> createState() => _QuickAddPageState();
}

class _QuickAddPageState extends ConsumerState<QuickAddPage> {
  QuickAddDraft? _draft;
  String? _errorMessage;
  bool _isSubmitting = false;
  bool _restoredFromStore = false;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialDraft;
    _restoreDraftIfNeeded();
  }

  Future<void> _restoreDraftIfNeeded() async {
    if (_draft != null) {
      return;
    }

    final QuickAddDraft? restored = await ref
        .read(quickAddFlowServiceProvider)
        .restoreDraft();
    if (!mounted || restored == null) {
      return;
    }

    setState(() {
      _draft = restored;
      _restoredFromStore = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final QuickAddDraft draft =
        _draft ??
        ref
            .read(quickAddFlowServiceProvider)
            .prepareDraft(source: QuickAddEntrySource.fallback);

    return ScreenNoteScaffold(
      title: Text(localizations.quickAddPageTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.quickAddPageBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            QuickAddSourceChip(source: draft.source),
            const SizedBox(height: 16),
            if (_errorMessage != null) ...<Widget>[
              QuickAddErrorHint(message: _errorMessage!),
              const SizedBox(height: 16),
            ],
            QuickAddInput(
              draft: draft,
              isSubmitting: _isSubmitting,
              onChanged: _updateDraft,
            ),
            const SizedBox(height: 16),
            QuickAddDefaultOptionRow(
              title: localizations.quickAddDefaultPinnedTitle,
              body: draft.isPinned
                  ? localizations.valueEnabled
                  : localizations.valueDisabled,
              actionLabel: draft.isPinned
                  ? localizations.quickAddDefaultDisableAction
                  : localizations.quickAddDefaultEnableAction,
              onTap: () => _togglePinned(draft),
            ),
            const SizedBox(height: 12),
            QuickAddDefaultOptionRow(
              title: localizations.quickAddDefaultPrivacyTitle,
              body: draft.isPrivate
                  ? localizations.valueEnabled
                  : localizations.valueDisabled,
              actionLabel: draft.isPrivate
                  ? localizations.quickAddDefaultDisableAction
                  : localizations.quickAddDefaultEnableAction,
              onTap: () => _togglePrivacy(draft),
            ),
            const SizedBox(height: 16),
            QuickAddNonBlockingHint(
              title: localizations.quickAddNonBlockingTitle,
              body: _restoredFromStore
                  ? localizations.quickAddDraftRestoredBody
                  : localizations.quickAddNonBlockingBody,
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: _isSubmitting ? null : () => _cancel(draft),
                    child: Text(localizations.cancelAction),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isSubmitting ? null : () => _submit(draft),
                    child: _isSubmitting
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(localizations.quickInputSubmit),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateDraft(QuickAddDraft draft) {
    setState(() {
      _draft = draft;
      _errorMessage = null;
    });
  }

  void _togglePinned(QuickAddDraft draft) {
    _updateDraft(
      draft.applyChanges(
        isPinned: !draft.isPinned,
        timestamp: ref.read(nowProvider)(),
      ),
    );
  }

  void _togglePrivacy(QuickAddDraft draft) {
    _updateDraft(
      draft.applyChanges(
        isPrivate: !draft.isPrivate,
        timestamp: ref.read(nowProvider)(),
      ),
    );
  }

  Future<void> _submit(QuickAddDraft draft) async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    if (draft.draftText.trim().isEmpty) {
      setState(() {
        _errorMessage = localizations.taskTitleRequired;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final QuickAddFlowResult result = await ref
        .read(quickAddFlowServiceProvider)
        .submitDraft(draft);

    if (!mounted) {
      return;
    }

    switch (result.status) {
      case QuickAddFlowStatus.createdTask:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizations.taskCreateSuccess)));
        context.go(RoutePaths.home);
      case QuickAddFlowStatus.failedButRecovered:
        setState(() {
          _draft = result.draft ?? draft;
          _errorMessage = localizations.taskCreateFailed;
        });
      case QuickAddFlowStatus.openedQuickAdd ||
            QuickAddFlowStatus.savedDraft ||
            QuickAddFlowStatus.returnedToApp:
        break;
    }

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _cancel(QuickAddDraft draft) async {
    await ref.read(quickAddFlowServiceProvider).returnToApp(draft);
    if (!mounted) {
      return;
    }
    context.go(RoutePaths.home);
  }
}
