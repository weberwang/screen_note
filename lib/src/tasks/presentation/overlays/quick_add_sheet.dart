import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/src/quick_add/application/quick_add_entry_source.dart';
import 'package:screen_note/src/quick_add/application/quick_add_flow_result.dart';
import 'package:screen_note/src/quick_add/presentation/providers/quick_add_providers.dart';
import 'package:screen_note/src/quick_add/presentation/widgets/quick_add_default_option_row.dart';
import 'package:screen_note/src/quick_add/presentation/widgets/quick_add_error_hint.dart';
import 'package:screen_note/src/quick_add/presentation/widgets/quick_add_input.dart';
import 'package:screen_note/src/quick_add/presentation/widgets/quick_add_non_blocking_hint.dart';
import 'package:screen_note/src/quick_add/presentation/widgets/quick_add_source_chip.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';

/// 首页轻入口快速添加底部弹层。
class QuickAddSheet extends ConsumerStatefulWidget {
  /// 创建首页轻入口快速添加底部弹层。
  const QuickAddSheet({
    super.key,
    this.initialText = '',
  });

  /// 首页已输入但尚未提交的文本。
  final String initialText;

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  late QuickAddDraft _draft;
  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _draft = ref
        .read(quickAddFlowServiceProvider)
        .prepareDraft(
          source: QuickAddEntrySource.home,
          draftText: widget.initialText,
        );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.82;

    return SafeArea(
      child: SizedBox(
        height: maxHeight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 64,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: ScreenNoteColors.lineSoft,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        localizations.quickAddPageTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.quickAddSheetBody,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      QuickAddSourceChip(source: _draft.source),
                      const SizedBox(height: 16),
                      if (_errorMessage != null) ...<Widget>[
                        QuickAddErrorHint(message: _errorMessage!),
                        const SizedBox(height: 16),
                      ],
                      QuickAddInput(
                        draft: _draft,
                        isSubmitting: _isSubmitting,
                        onChanged: (QuickAddDraft draft) {
                          setState(() {
                            _draft = draft;
                            _errorMessage = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      QuickAddDefaultOptionRow(
                        title: localizations.quickAddDefaultPinnedTitle,
                        body: _draft.isPinned
                            ? localizations.valueEnabled
                            : localizations.valueDisabled,
                        actionLabel: _draft.isPinned
                            ? localizations.quickAddDefaultDisableAction
                            : localizations.quickAddDefaultEnableAction,
                        onTap: () {
                          setState(() {
                            _draft = _draft.applyChanges(
                              isPinned: !_draft.isPinned,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      QuickAddDefaultOptionRow(
                        title: localizations.quickAddDefaultPrivacyTitle,
                        body: _draft.isPrivate
                            ? localizations.valueEnabled
                            : localizations.valueDisabled,
                        actionLabel: _draft.isPrivate
                            ? localizations.quickAddDefaultDisableAction
                            : localizations.quickAddDefaultEnableAction,
                        onTap: () {
                          setState(() {
                            _draft = _draft.applyChanges(
                              isPrivate: !_draft.isPrivate,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      QuickAddNonBlockingHint(
                        title: localizations.quickAddNonBlockingTitle,
                        body: localizations.quickAddSheetHintBody,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: _isSubmitting ? null : _cancel,
                      child: Text(localizations.cancelAction),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
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
      ),
    );
  }

  Future<void> _submit() async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    if (_draft.draftText.trim().isEmpty) {
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
        .submitDraft(_draft);

    if (!mounted) {
      return;
    }

    switch (result.status) {
      case QuickAddFlowStatus.createdTask:
        Navigator.of(context).pop(result);
      case QuickAddFlowStatus.failedButRecovered:
        setState(() {
          _draft = result.draft ?? _draft;
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

  Future<void> _cancel() async {
    final QuickAddFlowResult result = await ref
        .read(quickAddFlowServiceProvider)
        .saveDraft(_draft);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(result);
  }
}
