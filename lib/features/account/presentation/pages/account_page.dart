import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/index.dart';
import '../../../../core/providers/locale_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/account_menu_item.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  // In a real app, this would come from user authentication state
  final bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountTitle),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
              _isLoggedIn
                  ? const ProfileHeader(
                    name: 'John Doe',
                    email: 'john.doe@example.com',
                    loyaltyPoints: 750,
                    membershipTier: 'Gold',
                    avatarUrl: null, // Use default avatar
                  )
                  : _buildSignInSection(context),

              const SizedBox(height: 16),
              const Divider(),

              // Account menu items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isLoggedIn) ...[
                      _buildAccountSection(context),
                      const Divider(),
                    ],
                    _buildPreferencesSection(context),
                    const Divider(),
                    _buildSupportSection(context),
                    const Divider(),
                    const SizedBox(height: 8),
                    if (_isLoggedIn)
                      AccountMenuItem(
                        icon: Icons.logout,
                        title: AppLocalizations.of(context)!.accountSignOut,
                        onTap: () {
                          // Handle sign out
                        },
                        showDivider: false,
                        iconColor: Colors.red,
                      ),
                    if (!_isLoggedIn)
                      AccountMenuItem(
                        icon: Icons.login,
                        title: AppLocalizations.of(context)!.accountSignIn,
                        onTap: () {
                          // Navigate to sign in screen
                        },
                        showDivider: false,
                        iconColor: Theme.of(context).primaryColor,
                      ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.accountVersion('1.0.0'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Column(
        children: [
          Icon(Icons.account_circle, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            loc.accountSignInMsg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to sign in screen
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(loc.accountSignIn),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            loc.accountTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        AccountMenuItem(
          icon: Icons.person_outline,
          title: loc.accountPersonalInfo,
          onTap: () {
            // Navigate to personal information
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.credit_card_outlined,
          title: loc.accountPaymentMethods,
          onTap: () {
            // Navigate to payment methods
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.card_membership_outlined,
          title: loc.accountLoyaltyProgram,
          onTap: () {
            // Navigate to loyalty program
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.history_outlined,
          title: loc.accountBookingHistory,
          onTap: () {
            // Navigate to booking history
          },
          showDivider: false,
        ),
      ],
    );
  }
  Widget _buildPreferencesSection(BuildContext context) {
    // Get localization
    final loc = AppLocalizations.of(context)!;

    // Get the current locale display name from Riverpod
    final localeNotifier = ref.watch(localeNotifierProvider.notifier);
    final String displayLanguage = localeNotifier.getDisplayLanguage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            loc.accountPreferences,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        AccountMenuItem(
          icon: Icons.language_outlined,
          title: loc.accountLanguage,
          subtitle: displayLanguage,
          onTap: () {
            _showLanguageSelectionDialog(context, displayLanguage);
          },
          showDivider: false,
        ),
      ],
    );
  } // Show language selection dialog
  void _showLanguageSelectionDialog(
    BuildContext context,
    String currentLanguage,
  ) {
    // Get the LocaleNotifier instance from Riverpod
    final localeNotifier = ref.read(localeNotifierProvider.notifier);

    // Get localized strings
    final loc = AppLocalizations.of(context);
    if (loc == null) return; // Safety check

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            loc.languageSelect,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Vietnamese option
              RadioListTile<String>(
                title: Text(loc.languageVietnamese),
                value: 'Tiếng Việt',
                groupValue: currentLanguage,
                activeColor: Theme.of(context).colorScheme.primary,                onChanged: (value) {
                  // Set locale to Vietnamese
                  localeNotifier.setLocale(const Locale('vi'));
                  Navigator.pop(context, value);
                },
                selected: currentLanguage == 'Tiếng Việt',
                secondary:
                    currentLanguage == 'Tiếng Việt'
                        ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                        : null,
              ),
              // English option
              RadioListTile<String>(
                title: Text(loc.languageEnglish),
                value: 'English',
                groupValue: currentLanguage,
                activeColor: Theme.of(context).colorScheme.primary,                onChanged: (value) {
                  // Set locale to English
                  localeNotifier.setLocale(const Locale('en'));
                  Navigator.pop(context, value);
                },
                selected: currentLanguage == 'English',
                secondary:
                    currentLanguage == 'English'
                        ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                        : null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                loc.cancel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ).then((selectedLanguage) {
      if (selectedLanguage != null) {
        // No need to update state manually as Provider will trigger rebuild

        // Dismiss any existing snackbars first
        ScaffoldMessenger.of(
          context,
        ).hideCurrentSnackBar(); // Show a brief confirmation with the new language
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.languageChanged(selectedLanguage),
            ),
            duration: const Duration(milliseconds: 800),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    });
  }

  Widget _buildSupportSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            loc.accountSupport,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        AccountMenuItem(
          icon: Icons.help_outline,
          title: loc.accountHelpCenter,
          onTap: () {
            // Navigate to help center
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.chat_outlined,
          title: loc.accountContactUs,
          onTap: () {
            // Navigate to contact us
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.security_outlined,
          title: loc.accountPrivacyPolicy,
          onTap: () {
            // Navigate to privacy policy
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.description_outlined,
          title: loc.accountTerms,
          onTap: () {
            // Navigate to terms and conditions
          },
          showDivider: false,
        ),
      ],
    );
  }
}
