import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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
    Locale('vi'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hotel Booking'**
  String get appTitle;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please login to your account'**
  String get loginSubtitle;

  /// No description provided for @loginEmailPhonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone Number'**
  String get loginEmailPhonePlaceholder;

  /// No description provided for @loginPasswordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordPlaceholder;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginButton;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccount;

  /// No description provided for @loginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get loginSignUp;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email/phone or password.'**
  String get loginInvalidCredentials;

  /// No description provided for @loginNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get loginNetworkError;

  /// No description provided for @loginGenericError.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginGenericError;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to enjoy exclusive benefits'**
  String get registerSubtitle;

  /// No description provided for @registerFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get registerFullName;

  /// No description provided for @registerEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmail;

  /// No description provided for @registerPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get registerPhone;

  /// No description provided for @registerPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPassword;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerButton;

  /// No description provided for @registerTerms.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our Terms of Service and Privacy Policy'**
  String get registerTerms;

  /// No description provided for @registerInProgress.
  ///
  /// In en, this message translates to:
  /// **'Registration feature coming soon!'**
  String get registerInProgress;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone number and we\'ll send you a code'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordEmailPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone'**
  String get forgotPasswordEmailPhone;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Code'**
  String get forgotPasswordButton;

  /// No description provided for @forgotPasswordInProgress.
  ///
  /// In en, this message translates to:
  /// **'Password reset feature coming soon!'**
  String get forgotPasswordInProgress;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPromos.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get navPromos;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get navOffers;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {userName}!'**
  String homeWelcome(String userName);

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Where are you going?'**
  String get homeSearchHint;

  /// No description provided for @homePopularDestinations.
  ///
  /// In en, this message translates to:
  /// **'Popular Destinations'**
  String get homePopularDestinations;

  /// No description provided for @homeTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get homeTopRated;

  /// No description provided for @homeRecentlyViewed.
  ///
  /// In en, this message translates to:
  /// **'Recently Viewed'**
  String get homeRecentlyViewed;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAll;

  /// No description provided for @bookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get bookingsTitle;

  /// No description provided for @bookingsUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get bookingsUpcoming;

  /// No description provided for @bookingsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingsCompleted;

  /// No description provided for @bookingsCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingsCancelled;

  /// No description provided for @bookingsNoBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get bookingsNoBookings;

  /// No description provided for @bookingsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: {count} bookings'**
  String bookingsTotal(int count);

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get accountTitle;

  /// No description provided for @accountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In or Register'**
  String get accountSignIn;

  /// No description provided for @accountSignInMsg.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your bookings, saved hotels, and personalized offers.'**
  String get accountSignInMsg;

  /// No description provided for @accountPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get accountPersonalInfo;

  /// No description provided for @accountPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get accountPaymentMethods;

  /// No description provided for @accountLoyaltyProgram.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Program'**
  String get accountLoyaltyProgram;

  /// No description provided for @accountBookingHistory.
  ///
  /// In en, this message translates to:
  /// **'Booking History'**
  String get accountBookingHistory;

  /// No description provided for @accountPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get accountPreferences;

  /// No description provided for @accountLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get accountLanguage;

  /// No description provided for @accountSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get accountSupport;

  /// No description provided for @accountHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get accountHelpCenter;

  /// No description provided for @accountContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get accountContactUs;

  /// No description provided for @accountPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get accountPrivacyPolicy;

  /// No description provided for @accountTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get accountTerms;

  /// No description provided for @accountSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get accountSignOut;

  /// No description provided for @accountVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String accountVersion(String version);

  /// No description provided for @languageSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get languageSelect;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to: {language}'**
  String languageChanged(String language);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
