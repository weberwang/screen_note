import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// Application title shown in the app chrome and home screen.
  ///
  /// In en, this message translates to:
  /// **'Screen Note'**
  String get appTitle;

  /// Primary title shown on the phase one home page.
  ///
  /// In en, this message translates to:
  /// **'Today, don\'t forget'**
  String get homePageTitle;

  /// Supporting subtitle shown on the phase one home page.
  ///
  /// In en, this message translates to:
  /// **'Put the important little things where they stay visible.'**
  String get homePageSubtitle;

  /// Placeholder in the quick input card.
  ///
  /// In en, this message translates to:
  /// **'Write down the little thing you can\'t forget'**
  String get quickInputPlaceholder;

  /// Primary action label used to create a task quickly.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get quickInputSubmit;

  /// Supporting helper text inside the quick input card.
  ///
  /// In en, this message translates to:
  /// **'Keep the title first, then add due time, pinning, and privacy only when needed.'**
  String get quickInputHelperText;

  /// Title for the phase four quick add fallback page.
  ///
  /// In en, this message translates to:
  /// **'Quick add'**
  String get quickAddPageTitle;

  /// Top helper copy shown on the phase four quick add fallback page.
  ///
  /// In en, this message translates to:
  /// **'This page catches drafts from failed system entries so you can finish the note and continue without starting over.'**
  String get quickAddPageBody;

  /// Top helper copy shown on the home quick add bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'The home quick add sheet keeps just one line of input and a few defaults so creation stays within a few seconds.'**
  String get quickAddSheetBody;

  /// Field label used above the quick add input area.
  ///
  /// In en, this message translates to:
  /// **'Task content'**
  String get quickAddInputLabel;

  /// Title for the quick add default pinned row.
  ///
  /// In en, this message translates to:
  /// **'Pin by default'**
  String get quickAddDefaultPinnedTitle;

  /// Title for the quick add default privacy row.
  ///
  /// In en, this message translates to:
  /// **'Private by default'**
  String get quickAddDefaultPrivacyTitle;

  /// Action label used to enable a quick add default option.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get quickAddDefaultEnableAction;

  /// Action label used to disable a quick add default option.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get quickAddDefaultDisableAction;

  /// Title for the quick add non-blocking fallback hint.
  ///
  /// In en, this message translates to:
  /// **'Entry failures never block the main flow'**
  String get quickAddNonBlockingTitle;

  /// Body for the quick add non-blocking fallback hint.
  ///
  /// In en, this message translates to:
  /// **'If the system entry can\'t finish creation directly, the app keeps your content and lets you continue here.'**
  String get quickAddNonBlockingBody;

  /// Body for the non-blocking hint shown inside the home quick add bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'This sheet never expands into the full editor. If creation fails, the app still keeps the draft for later.'**
  String get quickAddSheetHintBody;

  /// Body shown when the quick add page restores a saved draft.
  ///
  /// In en, this message translates to:
  /// **'Your previous draft is already restored here, so you can finish it and submit right away.'**
  String get quickAddDraftRestoredBody;

  /// Quick add source chip label for the in-app home entry.
  ///
  /// In en, this message translates to:
  /// **'From home'**
  String get quickAddSourceHome;

  /// Quick add source chip label for the App Intent entry.
  ///
  /// In en, this message translates to:
  /// **'From App Intent'**
  String get quickAddSourceAppIntent;

  /// Quick add source chip label for the Control Center entry.
  ///
  /// In en, this message translates to:
  /// **'From Control Center'**
  String get quickAddSourceControlCenter;

  /// Quick add source chip label for the lock screen entry.
  ///
  /// In en, this message translates to:
  /// **'From Lock Screen'**
  String get quickAddSourceLockScreen;

  /// Quick add source chip label for the hardware action button entry.
  ///
  /// In en, this message translates to:
  /// **'From Action Button'**
  String get quickAddSourceActionButton;

  /// Quick add source chip label for deep-link fallback entries.
  ///
  /// In en, this message translates to:
  /// **'From deep link'**
  String get quickAddSourceDeepLink;

  /// Quick add source chip label for unified fallback recovery.
  ///
  /// In en, this message translates to:
  /// **'From fallback recovery'**
  String get quickAddSourceFallback;

  /// Validation message shown when task title is empty.
  ///
  /// In en, this message translates to:
  /// **'Write something important first.'**
  String get taskTitleRequired;

  /// Feedback shown after a task is created successfully.
  ///
  /// In en, this message translates to:
  /// **'Added to your lock screen reminder.'**
  String get taskCreateSuccess;

  /// Feedback shown when quick creation fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save it yet. Your text is still here.'**
  String get taskCreateFailed;

  /// Section title for active tasks on the home page.
  ///
  /// In en, this message translates to:
  /// **'Current tasks'**
  String get activeTasksSectionTitle;

  /// Section title for secondary tasks shown below the focus card on the home page.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get homeUpNextTitle;

  /// Entry label to open the completed history page.
  ///
  /// In en, this message translates to:
  /// **'Recently completed'**
  String get completedHistoryEntry;

  /// Entry label to open the deleted history page.
  ///
  /// In en, this message translates to:
  /// **'Recently deleted'**
  String get deletedHistoryEntry;

  /// Entry label used on the home page to open the full task editor.
  ///
  /// In en, this message translates to:
  /// **'Full editor'**
  String get taskEditorEntry;

  /// Entry label used on the home page to open settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsEntry;

  /// Bottom navigation label for the task flow module.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get taskFlowTabLabel;

  /// Bottom navigation label for the history center module.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyCenterTabLabel;

  /// Bottom navigation label for the widget bridge module.
  ///
  /// In en, this message translates to:
  /// **'Lock Screen'**
  String get widgetBridgeTabLabel;

  /// Bottom navigation label for the settings center module.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsCenterTabLabel;

  /// Badge label shown on initialization placeholder cards.
  ///
  /// In en, this message translates to:
  /// **'Initialization baseline'**
  String get bootstrapPlaceholderBadge;

  /// Generic explanation used by placeholder screens during project initialization.
  ///
  /// In en, this message translates to:
  /// **'This screen only ships routing, theming, provider wiring, and module boundaries during flutter-init. Real business behaviors are intentionally deferred to the flutter-dev stage.'**
  String get bootstrapPlaceholderBody;

  /// Metric label for active task preview readiness on the task flow placeholder page.
  ///
  /// In en, this message translates to:
  /// **'Active preview'**
  String get taskFlowActivePreviewLabel;

  /// Metric label for completed history readiness on the task flow placeholder page.
  ///
  /// In en, this message translates to:
  /// **'Completed handoff'**
  String get taskFlowCompletedPreviewLabel;

  /// Metric label for deleted history readiness on the task flow placeholder page.
  ///
  /// In en, this message translates to:
  /// **'Deleted restore'**
  String get taskFlowDeletedPreviewLabel;

  /// Empty state title when there are no active tasks.
  ///
  /// In en, this message translates to:
  /// **'Nothing to remember yet'**
  String get emptyActiveTasksTitle;

  /// Empty state message when there are no active tasks.
  ///
  /// In en, this message translates to:
  /// **'Write one down and it will stay visible here.'**
  String get emptyActiveTasksBody;

  /// Empty state title for completed history.
  ///
  /// In en, this message translates to:
  /// **'No completed tasks yet'**
  String get emptyCompletedTasksTitle;

  /// Empty state message for completed history.
  ///
  /// In en, this message translates to:
  /// **'Completed tasks will show up here so they stay traceable.'**
  String get emptyCompletedTasksBody;

  /// Empty state title for deleted history.
  ///
  /// In en, this message translates to:
  /// **'Nothing in recently deleted'**
  String get emptyDeletedTasksTitle;

  /// Empty state message for deleted history.
  ///
  /// In en, this message translates to:
  /// **'Deleted tasks stay here for 30 days so you can restore them.'**
  String get emptyDeletedTasksBody;

  /// Hint shown above deleted history list.
  ///
  /// In en, this message translates to:
  /// **'Deleted tasks stay here for 30 days.'**
  String get deletedRetentionHint;

  /// Title for the completed history page.
  ///
  /// In en, this message translates to:
  /// **'Recently completed'**
  String get historyCompletedTitle;

  /// Title for the deleted history page.
  ///
  /// In en, this message translates to:
  /// **'Recently deleted'**
  String get historyDeletedTitle;

  /// Title for the task detail page.
  ///
  /// In en, this message translates to:
  /// **'Task details'**
  String get taskDetailTitle;

  /// Title for the full task editor page.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get taskEditorTitle;

  /// Helper copy shown near the top of the full task editor page.
  ///
  /// In en, this message translates to:
  /// **'The full editor handles title, note, due time, pinning, privacy, and reminder mode in one place.'**
  String get taskEditorHelperText;

  /// Fallback message when a task cannot be loaded.
  ///
  /// In en, this message translates to:
  /// **'This task isn\'t available right now.'**
  String get taskDetailMissing;

  /// Label for the task title field.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get taskTitleLabel;

  /// Label for the task note field.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get taskNoteLabel;

  /// Placeholder value shown when the task note has not been filled yet.
  ///
  /// In en, this message translates to:
  /// **'Add notes'**
  String get taskNoteEmpty;

  /// Label for the task due time row.
  ///
  /// In en, this message translates to:
  /// **'Due time'**
  String get taskDueLabel;

  /// Placeholder shown when a task has no due time.
  ///
  /// In en, this message translates to:
  /// **'No due time yet'**
  String get taskDueEmpty;

  /// Switch label for pinning a task.
  ///
  /// In en, this message translates to:
  /// **'Pin this task'**
  String get taskPinnedLabel;

  /// Switch label for marking a task as private.
  ///
  /// In en, this message translates to:
  /// **'Hide on lock screen'**
  String get taskPrivateLabel;

  /// Label for the reminder mode row in the full editor.
  ///
  /// In en, this message translates to:
  /// **'Reminder mode'**
  String get taskReminderModeLabel;

  /// Label for the normal reminder mode.
  ///
  /// In en, this message translates to:
  /// **'Normal reminder'**
  String get taskReminderModeNormal;

  /// Label for the persistent reminder mode.
  ///
  /// In en, this message translates to:
  /// **'Persistent reminder'**
  String get taskReminderModePersistent;

  /// Title for the lock screen preview section on task detail and editor pages.
  ///
  /// In en, this message translates to:
  /// **'Lock screen preview'**
  String get taskPreviewTitle;

  /// Title for the hidden-content option in the lock screen preview.
  ///
  /// In en, this message translates to:
  /// **'Hide content'**
  String get taskPreviewHideContentTitle;

  /// Body for the hidden-content option in the lock screen preview.
  ///
  /// In en, this message translates to:
  /// **'Only show a safe summary.'**
  String get taskPreviewHideContentBody;

  /// Title for the visible-content option in the lock screen preview.
  ///
  /// In en, this message translates to:
  /// **'Show content'**
  String get taskPreviewShowContentTitle;

  /// Body for the visible-content option in the lock screen preview.
  ///
  /// In en, this message translates to:
  /// **'Keep the full content visible inside the app.'**
  String get taskPreviewShowContentBody;

  /// Title for the privacy summary at the bottom of the lock screen preview.
  ///
  /// In en, this message translates to:
  /// **'Only visible to you'**
  String get taskPreviewPrivateOnlyTitle;

  /// Body for the privacy summary at the bottom of the lock screen preview.
  ///
  /// In en, this message translates to:
  /// **'Outward surfaces hide the original text by default.'**
  String get taskPreviewPrivateOnlyBody;

  /// Primary button label to save task changes.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get taskSaveChanges;

  /// Primary button label used on the full task editor page.
  ///
  /// In en, this message translates to:
  /// **'Save task'**
  String get taskSaveAction;

  /// Action label used to complete a task.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get taskCompleteAction;

  /// Action label used to soft delete a task.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get taskDeleteAction;

  /// Action label used to restore a task.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get taskRestoreAction;

  /// Longer restore label used in detail and deleted history views.
  ///
  /// In en, this message translates to:
  /// **'Restore task'**
  String get taskRestoreItemAction;

  /// Boolean value label used when a detail setting is enabled.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get valueEnabled;

  /// Boolean value label used when a detail setting is disabled.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get valueDisabled;

  /// Feedback shown after restoring a task.
  ///
  /// In en, this message translates to:
  /// **'Restored to current tasks.'**
  String get taskRestoreSuccess;

  /// Feedback shown after deleting a task.
  ///
  /// In en, this message translates to:
  /// **'Deleted. You can restore it from recently deleted.'**
  String get taskDeleteSuccess;

  /// Feedback shown after completing a task.
  ///
  /// In en, this message translates to:
  /// **'Moved to recently completed.'**
  String get taskCompleteSuccess;

  /// Feedback shown after saving task details.
  ///
  /// In en, this message translates to:
  /// **'Saved your changes.'**
  String get taskUpdateSuccess;

  /// General task list error message.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load tasks right now.'**
  String get taskLoadFailed;

  /// General history list error message.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load history right now.'**
  String get taskHistoryLoadFailed;

  /// Generic retry action label.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryAction;

  /// Chip label for pinned tasks.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get statusPinned;

  /// Chip label for overdue tasks.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// Chip label for tasks due today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statusToday;

  /// Chip label for private tasks.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get statusPrivate;

  /// Chip label for completed tasks.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// Chip label for deleted tasks.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get statusDeleted;

  /// Placeholder title shown when task content must be masked.
  ///
  /// In en, this message translates to:
  /// **'Private task'**
  String get privateMaskedTitle;

  /// Masked body copy used in private task cards.
  ///
  /// In en, this message translates to:
  /// **'This private task is hidden here and only visible in the detail page.'**
  String get taskPrivateMaskedBody;

  /// Action label used to open the task detail page from list cards.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewTaskDetailAction;

  /// Action label used on completed history cards to open the original record.
  ///
  /// In en, this message translates to:
  /// **'View original record'**
  String get viewOriginalRecordAction;

  /// Remaining retention time label for deleted tasks.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Expires today} =1{1 day left} other{{days} days left}}'**
  String remainingDaysLabel(int days);

  /// Title of the delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete this task?'**
  String get deleteDialogTitle;

  /// Body of the delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'You can restore it from recently deleted within 30 days.'**
  String get deleteDialogBody;

  /// Title of the restore confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Restore to current tasks?'**
  String get restoreDialogTitle;

  /// Body of the restore confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'After restoring, it will join the home list and lock screen ranking again.'**
  String get restoreDialogBody;

  /// Title of the discard changes confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Discard unsaved changes?'**
  String get discardDialogTitle;

  /// Body of the discard changes confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Your edits on this page won\'t be saved.'**
  String get discardDialogBody;

  /// Generic cancel action label.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// Generic discard action label.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardAction;

  /// Title shown in the due time picker dialog.
  ///
  /// In en, this message translates to:
  /// **'Choose due time'**
  String get dueTimeDialogTitle;

  /// Action label to confirm due time selection.
  ///
  /// In en, this message translates to:
  /// **'Set time'**
  String get dueTimeSetAction;

  /// Action label to clear an existing due time.
  ///
  /// In en, this message translates to:
  /// **'Clear time'**
  String get dueTimeClearAction;

  /// Title for the privacy explanation bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'How privacy works'**
  String get privacyExplainTitle;

  /// Body for the privacy explanation bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Private tasks won\'t show their original text on lock screen previews or other outward surfaces.'**
  String get privacyExplainBody;

  /// Title for the phase two settings page.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// Helper copy shown on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Phase two only keeps lock screen display and privacy settings. Notifications, Pro, and system entries stay out of scope.'**
  String get settingsPageHelperText;

  /// Title for the display-related settings group.
  ///
  /// In en, this message translates to:
  /// **'Display preferences'**
  String get settingsDisplayGroupTitle;

  /// Title for the notification preference row on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Notification access'**
  String get notificationSettingsTitle;

  /// Supporting copy for the notification preference row on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Only manages reminder availability and keeps the main task flow non-blocking.'**
  String get notificationSettingsSubtitle;

  /// Short status label shown when notification preference is enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get notificationSettingsEnabled;

  /// Short status label shown when notification preference is disabled or downgraded.
  ///
  /// In en, this message translates to:
  /// **'Degraded'**
  String get notificationSettingsDisabled;

  /// Trailing action label shown on settings tiles.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get settingsOpenAction;

  /// Title for the fallback principle block on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Fallback rule'**
  String get settingsFallbackTitle;

  /// Body for the fallback principle block on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Any settings failure should only degrade this page. It must not block home creation, history restore, or detail state changes.'**
  String get settingsFallbackBody;

  /// Title for the lock screen preview settings page.
  ///
  /// In en, this message translates to:
  /// **'Lock screen display'**
  String get widgetSettingsTitle;

  /// Helper copy shown on the lock screen preview settings page.
  ///
  /// In en, this message translates to:
  /// **'Preview the lock screen baseline inside the app. Phase two does not connect to real widget refresh.'**
  String get widgetSettingsSubtitle;

  /// Title for the widget display style selector on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Lock screen style'**
  String get widgetStyleSelectorTitle;

  /// Title for the private preview toggle on the widget settings page.
  ///
  /// In en, this message translates to:
  /// **'Hide private task body in previews'**
  String get widgetPreviewMaskPrivateTitle;

  /// Body for the private preview toggle on the widget settings page.
  ///
  /// In en, this message translates to:
  /// **'Lock screen, widget, and other outward surfaces should not expose private task text by default.'**
  String get widgetPreviewMaskPrivateBody;

  /// Primary preview label shown when private preview mode is enabled.
  ///
  /// In en, this message translates to:
  /// **'Private task body hidden'**
  String get widgetPreviewPrivateState;

  /// Title shown when the widget has no safe content to display.
  ///
  /// In en, this message translates to:
  /// **'Nothing is pinned to the lock screen yet'**
  String get widgetPreviewEmptyHint;

  /// Hint shown when widget refresh fails and the last valid snapshot is kept.
  ///
  /// In en, this message translates to:
  /// **'Showing the last valid snapshot'**
  String get widgetPreviewFallbackHint;

  /// Button label used on the widget preview page to manually sync the latest stable snapshot.
  ///
  /// In en, this message translates to:
  /// **'Sync lock screen snapshot'**
  String get widgetSyncAction;

  /// Feedback shown after the widget preview page manually syncs the latest stable snapshot successfully.
  ///
  /// In en, this message translates to:
  /// **'Synced the latest stable snapshot.'**
  String get widgetSyncSuccess;

  /// Fallback feedback shown when the widget preview page fails to sync and keeps the last valid snapshot.
  ///
  /// In en, this message translates to:
  /// **'Sync failed. Keeping the last valid snapshot.'**
  String get widgetSyncFailed;

  /// Metric label used on the widget preview page for the current display mode.
  ///
  /// In en, this message translates to:
  /// **'Current mode'**
  String get widgetPreviewModeMetric;

  /// Metric label used on the widget preview page for the number of visible items.
  ///
  /// In en, this message translates to:
  /// **'Visible items'**
  String get widgetPreviewVisibleMetric;

  /// Metric label used on the widget preview page for the number of private items.
  ///
  /// In en, this message translates to:
  /// **'Private items'**
  String get widgetPreviewPrivateMetric;

  /// Summary shown in widget snapshots when private mode hides task bodies.
  ///
  /// In en, this message translates to:
  /// **'{itemCount, plural, =0{Private content hidden} =1{1 task hidden} other{{itemCount} tasks hidden}}'**
  String widgetPreviewPrivateSummary(int itemCount);

  /// Default body copy used in the widget preview card.
  ///
  /// In en, this message translates to:
  /// **'Shows time, state, and a safe summary.'**
  String get widgetPreviewDefaultBody;

  /// Label for the single item widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get widgetDisplayModeSingle;

  /// Label for the three item widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Three items'**
  String get widgetDisplayModeList3;

  /// Label for the today-only widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get widgetDisplayModeToday;

  /// Label for the privacy-first widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get widgetDisplayModePrivate;

  /// Label for the empty state widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get widgetDisplayModeEmpty;

  /// Title for the widget installation guide card.
  ///
  /// In en, this message translates to:
  /// **'Add it to your lock screen'**
  String get widgetInstallGuideTitle;

  /// Body copy for the widget installation guide card.
  ///
  /// In en, this message translates to:
  /// **'Add the Screen Note widget from the system lock screen editor. The app only prepares stable snapshots here and does not promise instant refresh.'**
  String get widgetInstallGuideBody;

  /// Preview title used when demonstrating widget fallback behavior.
  ///
  /// In en, this message translates to:
  /// **'Fallback keeps the last safe content'**
  String get widgetFallbackPreviewTitle;

  /// Title for the future sync placeholder entry on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Sync and backup'**
  String get syncPlaceholderTitle;

  /// Body copy for the future sync placeholder entry on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Future sync and recovery stay as a weak entry for now, without changing the local-first main flow.'**
  String get syncPlaceholderBody;

  /// Status label shown for the future sync placeholder entry.
  ///
  /// In en, this message translates to:
  /// **'Not enabled'**
  String get syncPlaceholderStatus;

  /// Title for the future premium entry card on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Member center'**
  String get proEntryTitle;

  /// Body copy for the future premium entry card on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Unlock future advanced capabilities without affecting the basic privacy baseline.'**
  String get proEntryBody;

  /// Future premium benefit label for an unlimited list.
  ///
  /// In en, this message translates to:
  /// **'Unlimited list'**
  String get proBenefitUnlimitedList;

  /// Future premium benefit label for custom reminders.
  ///
  /// In en, this message translates to:
  /// **'Custom reminder'**
  String get proBenefitCustomReminder;

  /// Future premium benefit label for data backup.
  ///
  /// In en, this message translates to:
  /// **'Data backup'**
  String get proBenefitDataBackup;

  /// Sample title shown in single widget preview mode.
  ///
  /// In en, this message translates to:
  /// **'Finish the lock screen widget review'**
  String get widgetPreviewSingleTitle;

  /// First sample item title shown in list widget preview mode.
  ///
  /// In en, this message translates to:
  /// **'Confirm the three-item layout rhythm'**
  String get widgetPreviewListItemOne;

  /// Second sample item title shown in list widget preview mode.
  ///
  /// In en, this message translates to:
  /// **'Export the latest valid fallback snapshot'**
  String get widgetPreviewListItemTwo;

  /// Third sample item title shown in list widget preview mode.
  ///
  /// In en, this message translates to:
  /// **'Keep the privacy copy unreadable outside the app'**
  String get widgetPreviewListItemThree;

  /// Sample title shown in today widget preview mode.
  ///
  /// In en, this message translates to:
  /// **'Tasks due today stay visible'**
  String get widgetPreviewTodayTitle;

  /// Sample due label shown in widget previews for items due today.
  ///
  /// In en, this message translates to:
  /// **'Today 18:00'**
  String get widgetPreviewDueToday;

  /// Sample due label shown in widget previews for overdue items.
  ///
  /// In en, this message translates to:
  /// **'Yesterday 20:00'**
  String get widgetPreviewDueYesterday;

  /// Body copy shown in the empty widget preview state.
  ///
  /// In en, this message translates to:
  /// **'Create or restore a task and the lock screen will pick up the next stable snapshot.'**
  String get widgetPreviewEmptyBody;

  /// Title for the privacy settings page.
  ///
  /// In en, this message translates to:
  /// **'Privacy settings'**
  String get privacySettingsTitle;

  /// Helper copy shown on the privacy settings page.
  ///
  /// In en, this message translates to:
  /// **'Only manage basic display preferences here. No complex permission flow in phase two.'**
  String get privacySettingsSubtitle;

  /// Title for the primary toggle on the privacy settings page.
  ///
  /// In en, this message translates to:
  /// **'Hide private task body in outward previews'**
  String get privacySettingsMaskTitle;

  /// Body for the primary toggle on the privacy settings page.
  ///
  /// In en, this message translates to:
  /// **'Lock screen, widget, notifications, and shortcut entries should not directly expose private task text.'**
  String get privacySettingsMaskBody;

  /// Title for the conservative fallback block on the privacy settings page.
  ///
  /// In en, this message translates to:
  /// **'Conservative default'**
  String get privacySettingsSafeTitle;

  /// Body for the conservative fallback block on the privacy settings page.
  ///
  /// In en, this message translates to:
  /// **'If privacy settings fail, the app must keep the safer outward behavior instead of revealing more text.'**
  String get privacySettingsSafeBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
