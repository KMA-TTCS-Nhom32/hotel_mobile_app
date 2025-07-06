import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/locale_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// A widget to select the app language
class LanguageSelector extends ConsumerWidget {
  /// Creates a language selector widget
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeNotifierProvider);
    final localeNotifier = ref.read(localeNotifierProvider.notifier);

    return PopupMenuButton<Locale>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language, color: AppColors.onPrimaryLight, size: 20),
          const SizedBox(width: 4),
          Text(
            _getLanguageCode(currentLocale),
            style: TextStyle(
              color: AppColors.onPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      onSelected: (Locale locale) {
        if (currentLocale != locale) {
          localeNotifier.setLocale(locale);
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<Locale>>[
            PopupMenuItem<Locale>(
              value: const Locale('en'),
              child: Row(
                children: [
                  const Text('🇬🇧 '),
                  const SizedBox(width: 8),
                  Text('English'),
                ],
              ),
            ),
            PopupMenuItem<Locale>(
              value: const Locale('vi'),
              child: Row(
                children: [
                  const Text('🇻🇳 '),
                  const SizedBox(width: 8),
                  Text('Tiếng Việt'),
                ],
              ),
            ),
          ],
    );
  }

  String _getLanguageCode(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'EN';
      case 'vi':
        return 'VI';
      default:
        return locale.languageCode.toUpperCase();
    }
  }
}
