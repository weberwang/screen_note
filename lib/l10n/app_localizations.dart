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

  /// Primary button label to save task changes.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get taskSaveChanges;

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
