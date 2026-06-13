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

  /// Application title used during initialization verification.
  ///
  /// In en, this message translates to:
  /// **'Screen Note'**
  String get appTitle;

  /// Bottom navigation label for the home tab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTabLabel;

  /// Bottom navigation label for the history tab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTabLabel;

  /// Bottom navigation label for the settings tab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTabLabel;

  /// Title used by the global quick add bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Quick add'**
  String get quickAddSheetTitle;

  /// Hint text shown in the bootstrap quick add sheet.
  ///
  /// In en, this message translates to:
  /// **'The real quick-add flow will be connected in the task-flow module stage.'**
  String get quickAddSheetHint;

  /// Dismiss button label for the bootstrap quick add sheet.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get quickAddSheetDismiss;

  /// Lightweight shared shell feedback shown after the quick add sheet closes.
  ///
  /// In en, this message translates to:
  /// **'Quick add will be connected in the task-flow stage.'**
  String get quickAddFeedbackPlaceholder;

  /// Dismiss button label for the shared shell feedback host.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get appShellFeedbackDismiss;

  /// Greeting headline shown on the bootstrap home placeholder.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingTitle;

  /// Supporting copy shown below the bootstrap home greeting.
  ///
  /// In en, this message translates to:
  /// **'Focus on what matters most today.'**
  String get homeGreetingSubtitle;

  /// Badge label on the bootstrap priority panel.
  ///
  /// In en, this message translates to:
  /// **'PRIORITY'**
  String get homePriorityLabel;

  /// Placeholder priority task title used during bootstrap.
  ///
  /// In en, this message translates to:
  /// **'Bootstrap the shared shell'**
  String get homePriorityTitle;

  /// Placeholder priority task body used during bootstrap.
  ///
  /// In en, this message translates to:
  /// **'Root routing, theme, and startup wiring now have a stable place to land.'**
  String get homePriorityBody;

  /// Section title for the bootstrap queue placeholder.
  ///
  /// In en, this message translates to:
  /// **'Urgent queue'**
  String get homeQueueTitle;

  /// Placeholder task row label used in the bootstrap queue.
  ///
  /// In en, this message translates to:
  /// **'Placeholder item {index}'**
  String homeQueuePlaceholder(int index);

  /// Title for the bootstrap history placeholder page.
  ///
  /// In en, this message translates to:
  /// **'History center'**
  String get historyPlaceholderTitle;

  /// Body text for the bootstrap history placeholder page.
  ///
  /// In en, this message translates to:
  /// **'Recent completed and recently deleted flows will connect here after the shared bootstrap is stable.'**
  String get historyPlaceholderBody;

  /// Title for the bootstrap settings placeholder page.
  ///
  /// In en, this message translates to:
  /// **'Settings center'**
  String get settingsPlaceholderTitle;

  /// Body text for the bootstrap settings placeholder page.
  ///
  /// In en, this message translates to:
  /// **'Notification, privacy, display, and future membership settings will land here in later module work.'**
  String get settingsPlaceholderBody;
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
