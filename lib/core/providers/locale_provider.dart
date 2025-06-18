import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for the locale notifier
final localeNotifierProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

/// Provides the current locale for the app
class LocaleNotifier extends StateNotifier<Locale> {
  static const String _languageKey = 'selected_language';

  LocaleNotifier() : super(const Locale('vi')) {
    _loadSavedLocale();
  }

  /// Load the locale from shared preferences
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_languageKey);

    // If language was previously saved, use it
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  /// Update the locale
  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);

    // Update the state
    state = locale;
  }

  /// Get display name of current language
  String getDisplayLanguage() {
    switch (state.languageCode) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      default:
        return 'Tiếng Việt';
    }
  }
}
