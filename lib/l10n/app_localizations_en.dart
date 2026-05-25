// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Screen Note';

  @override
  String get homePageTitle => 'Today, don\'t forget';

  @override
  String get homePageSubtitle =>
      'Put the important little things where they stay visible.';

  @override
  String get quickInputPlaceholder =>
      'Write down the little thing you can\'t forget';

  @override
  String get quickInputSubmit => 'Add';

  @override
  String get quickInputHelperText =>
      'Keep the title first, then add due time, pinning, and privacy only when needed.';

  @override
  String get taskTitleRequired => 'Write something important first.';

  @override
  String get taskCreateSuccess => 'Added to your lock screen reminder.';

  @override
  String get taskCreateFailed =>
      'Couldn\'t save it yet. Your text is still here.';

  @override
  String get activeTasksSectionTitle => 'Current tasks';

  @override
  String get completedHistoryEntry => 'Recently completed';

  @override
  String get deletedHistoryEntry => 'Recently deleted';

  @override
  String get taskEditorEntry => 'Full editor';

  @override
  String get settingsEntry => 'Settings';

  @override
  String get emptyActiveTasksTitle => 'Nothing to remember yet';

  @override
  String get emptyActiveTasksBody =>
      'Write one down and it will stay visible here.';

  @override
  String get emptyCompletedTasksTitle => 'No completed tasks yet';

  @override
  String get emptyCompletedTasksBody =>
      'Completed tasks will show up here so they stay traceable.';

  @override
  String get emptyDeletedTasksTitle => 'Nothing in recently deleted';

  @override
  String get emptyDeletedTasksBody =>
      'Deleted tasks stay here for 30 days so you can restore them.';

  @override
  String get deletedRetentionHint => 'Deleted tasks stay here for 30 days.';

  @override
  String get historyCompletedTitle => 'Recently completed';

  @override
  String get historyDeletedTitle => 'Recently deleted';

  @override
  String get taskDetailTitle => 'Task details';

  @override
  String get taskEditorTitle => 'New task';

  @override
  String get taskEditorHelperText =>
      'The full editor handles title, note, due time, pinning, privacy, and reminder mode in one place.';

  @override
  String get taskDetailMissing => 'This task isn\'t available right now.';

  @override
  String get taskTitleLabel => 'Title';

  @override
  String get taskNoteLabel => 'Note';

  @override
  String get taskDueLabel => 'Due time';

  @override
  String get taskDueEmpty => 'No due time yet';

  @override
  String get taskPinnedLabel => 'Pin this task';

  @override
  String get taskPrivateLabel => 'Hide on lock screen';

  @override
  String get taskReminderModeLabel => 'Reminder mode';

  @override
  String get taskReminderModeNormal => 'Normal reminder';

  @override
  String get taskReminderModePersistent => 'Persistent reminder';

  @override
  String get taskSaveChanges => 'Save changes';

  @override
  String get taskSaveAction => 'Save task';

  @override
  String get taskCompleteAction => 'Complete';

  @override
  String get taskDeleteAction => 'Delete';

  @override
  String get taskRestoreAction => 'Restore';

  @override
  String get taskRestoreItemAction => 'Restore task';

  @override
  String get valueEnabled => 'On';

  @override
  String get valueDisabled => 'Off';

  @override
  String get taskRestoreSuccess => 'Restored to current tasks.';

  @override
  String get taskDeleteSuccess =>
      'Deleted. You can restore it from recently deleted.';

  @override
  String get taskCompleteSuccess => 'Moved to recently completed.';

  @override
  String get taskUpdateSuccess => 'Saved your changes.';

  @override
  String get taskLoadFailed => 'Couldn\'t load tasks right now.';

  @override
  String get taskHistoryLoadFailed => 'Couldn\'t load history right now.';

  @override
  String get retryAction => 'Retry';

  @override
  String get statusPinned => 'Pinned';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusToday => 'Today';

  @override
  String get statusPrivate => 'Private';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusDeleted => 'Deleted';

  @override
  String get privateMaskedTitle => 'Private task';

  @override
  String get taskPrivateMaskedBody =>
      'This private task is hidden here and only visible in the detail page.';

  @override
  String get viewTaskDetailAction => 'View details';

  @override
  String get viewOriginalRecordAction => 'View original record';

  @override
  String remainingDaysLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
      zero: 'Expires today',
    );
    return '$_temp0';
  }

  @override
  String get deleteDialogTitle => 'Delete this task?';

  @override
  String get deleteDialogBody =>
      'You can restore it from recently deleted within 30 days.';

  @override
  String get restoreDialogTitle => 'Restore to current tasks?';

  @override
  String get restoreDialogBody =>
      'After restoring, it will join the home list and lock screen ranking again.';

  @override
  String get discardDialogTitle => 'Discard unsaved changes?';

  @override
  String get discardDialogBody => 'Your edits on this page won\'t be saved.';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get discardAction => 'Discard';

  @override
  String get dueTimeDialogTitle => 'Choose due time';

  @override
  String get dueTimeSetAction => 'Set time';

  @override
  String get dueTimeClearAction => 'Clear time';

  @override
  String get privacyExplainTitle => 'How privacy works';

  @override
  String get privacyExplainBody =>
      'Private tasks won\'t show their original text on lock screen previews or other outward surfaces.';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsPageHelperText =>
      'Phase two only keeps lock screen display and privacy settings. Notifications, Pro, and system entries stay out of scope.';

  @override
  String get settingsDisplayGroupTitle => 'Display preferences';

  @override
  String get settingsOpenAction => 'Open';

  @override
  String get settingsFallbackTitle => 'Fallback rule';

  @override
  String get settingsFallbackBody =>
      'Any settings failure should only degrade this page. It must not block home creation, history restore, or detail state changes.';

  @override
  String get widgetSettingsTitle => 'Lock screen display';

  @override
  String get widgetSettingsSubtitle =>
      'Preview the lock screen baseline inside the app. Phase two does not connect to real widget refresh.';

  @override
  String get widgetPreviewMaskPrivateTitle =>
      'Hide private task body in previews';

  @override
  String get widgetPreviewMaskPrivateBody =>
      'Lock screen, widget, and other outward surfaces should not expose private task text by default.';

  @override
  String get widgetPreviewPrivateState => 'Private task body hidden';

  @override
  String get widgetPreviewDefaultBody =>
      'Shows time, state, and a safe summary.';

  @override
  String get privacySettingsTitle => 'Privacy settings';

  @override
  String get privacySettingsSubtitle =>
      'Only manage basic display preferences here. No complex permission flow in phase two.';

  @override
  String get privacySettingsMaskTitle =>
      'Hide private task body in outward previews';

  @override
  String get privacySettingsMaskBody =>
      'Lock screen, widget, notifications, and shortcut entries should not directly expose private task text.';

  @override
  String get privacySettingsSafeTitle => 'Conservative default';

  @override
  String get privacySettingsSafeBody =>
      'If privacy settings fail, the app must keep the safer outward behavior instead of revealing more text.';
}
