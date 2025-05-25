import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  // Default locale (Vietnamese)
  Locale _locale = const Locale('vi');

  // Getter for current locale
  Locale get locale => _locale;

  // Initialize locale from shared preferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_languageKey);

    // If language was previously saved, use it
    if (languageCode != null) {
      _locale = Locale(languageCode);
    }

    // Notify listeners about the initial locale
    notifyListeners();
  }

  // Update locale
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);

    // Notify listeners about the locale change
    notifyListeners();
  }

  // Get display name of current language
  String getDisplayLanguage() {
    switch (_locale.languageCode) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      default:
        return 'Tiếng Việt';
    }
  }
}
