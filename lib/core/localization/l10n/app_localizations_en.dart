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
  String get loginWelcome => 'Welcome back!';

  @override
  String get loginSubtitle => 'Please login to your account';

  @override
  String get loginEmailPhonePlaceholder => 'Email or Phone Number';

  @override
  String get loginPasswordPlaceholder => 'Password';

  @override
  String get loginButton => 'Log In';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginSignUp => 'Sign Up';

  @override
  String get loginInvalidCredentials => 'Invalid email/phone or password.';

  @override
  String get loginNetworkError => 'Network error. Please check your connection.';

  @override
  String get loginGenericError => 'Login failed. Please try again.';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get validationEmailPhone => 'Please enter a valid email or phone number.';

  @override
  String get validationPassword => 'Password must be at least 8 characters with at least one uppercase letter, one lowercase letter, one number, and one special character.';

  @override
  String get validationEmptyEmail => 'Please enter your email or phone number.';

  @override
  String get validationEmptyPassword => 'Please enter your password.';

  @override
  String get validationPhone => 'Please enter a valid phone number.';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Create your account to enjoy exclusive benefits';

  @override
  String get registerFullName => 'Full Name';

  @override
  String get registerEmail => 'Email';

  @override
  String get registerPhone => 'Phone Number';

  @override
  String get registerPassword => 'Password';

  @override
  String get registerButton => 'Create Account';

  @override
  String get registerTerms => 'By creating an account, you agree to our Terms of Service and Privacy Policy';

  @override
  String get registerInProgress => 'Registration feature coming soon!';

  @override
  String get registerUsePhone => 'Tap the phone icon to register with a phone number instead';

  @override
  String get registerUseEmail => 'Tap the email icon to register with an email instead';

  @override
  String get verificationTitle => 'Verification';

  @override
  String verificationSubtitle(String identifier) {
    return 'We\'ve sent a verification code to your $identifier';
  }

  @override
  String get verificationEmailHeader => 'Verify Your Email';

  @override
  String get verificationPhoneHeader => 'Verify Your Phone Number';

  @override
  String get verificationSentTo => 'We\'ve sent a verification code to:';

  @override
  String get verificationCodeHint => 'Enter 6-digit code';

  @override
  String get verificationButton => 'Verify';

  @override
  String get verificationResend => 'Resend Code';

  @override
  String verificationResendIn(int seconds) {
    return 'Resend Code in $seconds seconds';
  }

  @override
  String get verificationSuccess => 'Verification successful! You can now log in.';

  @override
  String get verificationIncomplete => 'Please enter the complete verification code.';

  @override
  String get verificationFailed => 'Verification failed. Please check your code and try again.';

  @override
  String get verificationCodeResent => 'Verification code resent!';

  @override
  String get verificationInfo => 'Please complete the verification process. If you close the app, you\'ll need to login to receive a new code.';

  @override
  String get forgotPasswordTitle => 'Reset Your Password';

  @override
  String get forgotPasswordSubtitle => 'Enter your email or phone number and we\'ll send you a code';

  @override
  String get forgotPasswordEmailPhone => 'Email or Phone';

  @override
  String get forgotPasswordButton => 'Send Reset Code';

  @override
  String get forgotPasswordInProgress => 'Password reset feature coming soon!';

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
  String get accountEmail => 'Email';

  @override
  String get accountPhone => 'Phone';

  @override
  String get accountRole => 'Member Status';

  @override
  String get accountVerified => 'Verified';

  @override
  String get accountUnverified => 'Not Verified';

  @override
  String get accountEditProfile => 'Edit Profile';

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
  String get accountLogoutConfirm => 'Are you sure you want to sign out?';

  @override
  String get accountLogoutProgress => 'Signing out...';

  @override
  String accountWelcome(String name) {
    return 'Welcome, $name';
  }

  @override
  String accountVersion(String version) {
    return 'Version $version';
  }

  @override
  String get accountGender => 'Gender';

  @override
  String get accountMale => 'Male';

  @override
  String get accountFemale => 'Female';

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
