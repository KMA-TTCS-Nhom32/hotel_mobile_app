// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hotel Booking';

  @override
  String get navHome => 'Home';

  @override
  String get navPromos => 'Promotions';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navOffers => 'Offers';

  @override
  String get navAccount => 'Account';

  @override
  String homeWelcome(String userName) {
    return 'Welcome back, $userName!';
  }

  @override
  String get homeSearchHint => 'Where are you going?';

  @override
  String get homePopularDestinations => 'Popular Destinations';

  @override
  String get homeTopRated => 'Top Rated';

  @override
  String get homeRecentlyViewed => 'Recently Viewed';

  @override
  String get homeViewAll => 'View All';

  @override
  String get bookingsTitle => 'My Bookings';

  @override
  String get bookingsUpcoming => 'Upcoming';

  @override
  String get bookingsCompleted => 'Completed';

  @override
  String get bookingsCancelled => 'Cancelled';

  @override
  String get bookingsNoBookings => 'No bookings found';

  @override
  String bookingsTotal(int count) {
    return 'Total: $count bookings';
  }

  @override
  String get accountTitle => 'My Account';

  @override
  String get accountSignIn => 'Sign In or Register';

  @override
  String get accountSignInMsg => 'Sign in to access your bookings, saved hotels, and personalized offers.';

  @override
  String get accountPersonalInfo => 'Personal Information';

  @override
  String get accountPaymentMethods => 'Payment Methods';

  @override
  String get accountLoyaltyProgram => 'Loyalty Program';

  @override
  String get accountBookingHistory => 'Booking History';

  @override
  String get accountPreferences => 'Preferences';

  @override
  String get accountLanguage => 'Language';

  @override
  String get accountSupport => 'Support';

  @override
  String get accountHelpCenter => 'Help Center';

  @override
  String get accountContactUs => 'Contact Us';

  @override
  String get accountPrivacyPolicy => 'Privacy Policy';

  @override
  String get accountTerms => 'Terms & Conditions';

  @override
  String get accountSignOut => 'Sign Out';

  @override
  String accountVersion(String version) {
    return 'Version $version';
  }

  @override
  String get languageSelect => 'Select Language';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'English';

  @override
  String languageChanged(String language) {
    return 'Language changed to: $language';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get noData => 'No data available';

  @override
  String get guest => 'Guest';
}
