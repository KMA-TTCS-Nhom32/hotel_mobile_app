import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/account_menu_item.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Default language (Vietnamese)
  String _currentLanguage =
      'Tiếng Việt'; // This would come from a language provider in a real app

  // In a real app, this would come from user authentication state
  final bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
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
                        title: 'Sign Out',
                        onTap: () {
                          // Handle sign out
                        },
                        showDivider: false,
                        iconColor: Colors.red,
                      ),
                    if (!_isLoggedIn)
                      AccountMenuItem(
                        icon: Icons.login,
                        title: 'Sign In',
                        onTap: () {
                          // Navigate to sign in screen
                        },
                        showDivider: false,
                        iconColor: Theme.of(context).primaryColor,
                      ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'Version 1.0.0',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Column(
        children: [
          Icon(Icons.account_circle, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Sign in to access your bookings, saved hotels, and personalized offers.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black87),
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
            child: const Text('Sign In or Register'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Account',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        AccountMenuItem(
          icon: Icons.person_outline,
          title: 'Personal Information',
          onTap: () {
            // Navigate to personal information
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.credit_card_outlined,
          title: 'Payment Methods',
          onTap: () {
            // Navigate to payment methods
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.card_membership_outlined,
          title: 'Loyalty Program',
          onTap: () {
            // Navigate to loyalty program
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.history_outlined,
          title: 'Booking History',
          onTap: () {
            // Navigate to booking history
          },
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Preferences',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        AccountMenuItem(
          icon: Icons.language_outlined,
          title: 'Language',
          subtitle: _currentLanguage,
          onTap: () {
            _showLanguageSelectionDialog(context, _currentLanguage);
          },
          showDivider: false,
        ),
      ],
    );
  }

  // Show language selection dialog
  void _showLanguageSelectionDialog(
    BuildContext context,
    String currentLanguage,
  ) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Language',
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
                title: const Text('Tiếng Việt'),
                value: 'Tiếng Việt',
                groupValue: currentLanguage,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
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
                title: const Text('English'),
                value: 'English',
                groupValue: currentLanguage,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
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
                'Cancel',
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
        // Update state with the new language
        setState(() {
          _currentLanguage = selectedLanguage;
        });

        // In a real app, this would update app's locale
        // For example: context.read<LocaleProvider>().setLocale(selectedLanguage == 'English' ? Locale('en') : Locale('vi'))

        // Dismiss any existing snackbars first
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Show a brief confirmation with the new language
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected language: $selectedLanguage'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Support',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        AccountMenuItem(
          icon: Icons.help_outline,
          title: 'Help Center',
          onTap: () {
            // Navigate to help center
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.chat_outlined,
          title: 'Contact Us',
          onTap: () {
            // Navigate to contact us
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.security_outlined,
          title: 'Privacy Policy',
          onTap: () {
            // Navigate to privacy policy
          },
          showDivider: true,
        ),
        AccountMenuItem(
          icon: Icons.description_outlined,
          title: 'Terms & Conditions',
          onTap: () {
            // Navigate to terms and conditions
          },
          showDivider: false,
        ),
      ],
    );
  }
}
