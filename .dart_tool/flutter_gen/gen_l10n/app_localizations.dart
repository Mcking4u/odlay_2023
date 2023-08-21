import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fi.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fi')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, How are you?'**
  String get hello;

  /// No description provided for @title_sp_selec.
  ///
  /// In en, this message translates to:
  /// **'I\'m Service Provider'**
  String get title_sp_selec;

  /// No description provided for @title_cus_selec.
  ///
  /// In en, this message translates to:
  /// **'I\'m Customer'**
  String get title_cus_selec;

  /// No description provided for @fotter_sp_selec.
  ///
  /// In en, this message translates to:
  /// **'I\'m Customer'**
  String get fotter_sp_selec;

  /// No description provided for @fotter_cus_selec.
  ///
  /// In en, this message translates to:
  /// **'I\'m Customer'**
  String get fotter_cus_selec;

  /// No description provided for @title_apply_filter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get title_apply_filter;

  /// No description provided for @btn_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get btn_apply;

  /// No description provided for @select_address.
  ///
  /// In en, this message translates to:
  /// **'Select Address'**
  String get select_address;

  /// No description provided for @title_custom_search_filter.
  ///
  /// In en, this message translates to:
  /// **'Search With Filter'**
  String get title_custom_search_filter;

  /// No description provided for @select_skills.
  ///
  /// In en, this message translates to:
  /// **'Select Skills'**
  String get select_skills;

  /// No description provided for @btn_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get btn_reset;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// No description provided for @featured_services.
  ///
  /// In en, this message translates to:
  /// **'Featured Services'**
  String get featured_services;

  /// No description provided for @top_rated_professionals.
  ///
  /// In en, this message translates to:
  /// **'Top Rated Professionals'**
  String get top_rated_professionals;

  /// No description provided for @app_bar_cust_profile.
  ///
  /// In en, this message translates to:
  /// **'Customer Profile'**
  String get app_bar_cust_profile;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_Profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_Profile;

  /// No description provided for @nav_job_manager.
  ///
  /// In en, this message translates to:
  /// **'Job Manager'**
  String get nav_job_manager;

  /// No description provided for @nav_job_conversatin.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get nav_job_conversatin;

  /// No description provided for @nav_my_account.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get nav_my_account;

  /// No description provided for @title_my_acount_info.
  ///
  /// In en, this message translates to:
  /// **'Account info,Setting more'**
  String get title_my_acount_info;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get change_language;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notfications'**
  String get notification;

  /// No description provided for @about_odlay_service.
  ///
  /// In en, this message translates to:
  /// **'About Odlay Services'**
  String get about_odlay_service;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @help_support.
  ///
  /// In en, this message translates to:
  /// **'Help Support & tutorials'**
  String get help_support;

  /// No description provided for @rate_odlay.
  ///
  /// In en, this message translates to:
  /// **'Rate Odlay Services'**
  String get rate_odlay;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @wallet_method.
  ///
  /// In en, this message translates to:
  /// **'Wallet Method'**
  String get wallet_method;

  /// No description provided for @signout.
  ///
  /// In en, this message translates to:
  /// **'SignOut??'**
  String get signout;

  /// No description provided for @delete_my_account.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get delete_my_account;

  /// No description provided for @disable_my_account.
  ///
  /// In en, this message translates to:
  /// **'Disable My Account'**
  String get disable_my_account;

  /// No description provided for @app_bar_my_wallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get app_bar_my_wallet;

  /// No description provided for @completed_job.
  ///
  /// In en, this message translates to:
  /// **'Completed Jobs'**
  String get completed_job;

  /// No description provided for @total_spending.
  ///
  /// In en, this message translates to:
  /// **'Total Spendings'**
  String get total_spending;

  /// No description provided for @total_earnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get total_earnings;

  /// No description provided for @cash_payment.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment'**
  String get cash_payment;

  /// No description provided for @online_payment.
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get online_payment;

  /// No description provided for @payment_date.
  ///
  /// In en, this message translates to:
  /// **'Payment Date:'**
  String get payment_date;

  /// No description provided for @bid_amount_wallet.
  ///
  /// In en, this message translates to:
  /// **'Bid Amount:'**
  String get bid_amount_wallet;

  /// No description provided for @odlay_fee_wallet.
  ///
  /// In en, this message translates to:
  /// **'Odlay Fee:'**
  String get odlay_fee_wallet;

  /// No description provided for @amount_payable.
  ///
  /// In en, this message translates to:
  /// **'Amount Payable:'**
  String get amount_payable;

  /// No description provided for @by_card.
  ///
  /// In en, this message translates to:
  /// **'By Card'**
  String get by_card;

  /// No description provided for @created_at.
  ///
  /// In en, this message translates to:
  /// **'Created At:'**
  String get created_at;

  /// No description provided for @job_deadline.
  ///
  /// In en, this message translates to:
  /// **'Job Deadline:'**
  String get job_deadline;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @applicant_list.
  ///
  /// In en, this message translates to:
  /// **'Applicant list:'**
  String get applicant_list;

  /// No description provided for @invite_service_provider.
  ///
  /// In en, this message translates to:
  /// **'Invite Top Service Providers'**
  String get invite_service_provider;

  /// No description provided for @delete_job_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Job'**
  String get delete_job_title;

  /// No description provided for @delete_job_meeage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want Delete this Job!'**
  String get delete_job_meeage;

  /// No description provided for @delete_job_postive_btn.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get delete_job_postive_btn;

  /// No description provided for @bid_amount.
  ///
  /// In en, this message translates to:
  /// **'Bid Amount'**
  String get bid_amount;

  /// No description provided for @odlay_fee.
  ///
  /// In en, this message translates to:
  /// **'Odlay Fee'**
  String get odlay_fee;

  /// No description provided for @total_payable_amount.
  ///
  /// In en, this message translates to:
  /// **'Total Payable Amount'**
  String get total_payable_amount;

  /// No description provided for @no_of_days.
  ///
  /// In en, this message translates to:
  /// **'No of Days'**
  String get no_of_days;

  /// No description provided for @number_of_recomended.
  ///
  /// In en, this message translates to:
  /// **'No Recomended Providers Found'**
  String get number_of_recomended;

  /// No description provided for @invited.
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get invited;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @fully_verfied.
  ///
  /// In en, this message translates to:
  /// **'fully Verfied'**
  String get fully_verfied;

  /// No description provided for @partially_verfied.
  ///
  /// In en, this message translates to:
  /// **'partially Verfied'**
  String get partially_verfied;

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @job_budget.
  ///
  /// In en, this message translates to:
  /// **'Job Budget'**
  String get job_budget;

  /// No description provided for @note_all_vate.
  ///
  /// In en, this message translates to:
  /// **'Note:All the amounts include VAT'**
  String get note_all_vate;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get updating;

  /// No description provided for @award.
  ///
  /// In en, this message translates to:
  /// **'Award'**
  String get award;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @your_location_permission.
  ///
  /// In en, this message translates to:
  /// **'Your Location Permission'**
  String get your_location_permission;

  /// No description provided for @your_location_h1.
  ///
  /// In en, this message translates to:
  /// **'To use your location to automatically see the latest jobs or service providers around your area, please allow Odlay Services to use your location when the application is open or running.'**
  String get your_location_h1;

  /// No description provided for @your_location_h2.
  ///
  /// In en, this message translates to:
  /// **'Odlay Services will use your location to fetch the latest jobs or closest service providers around your area and will order them by distance from your location'**
  String get your_location_h2;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fi': return AppLocalizationsFi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
