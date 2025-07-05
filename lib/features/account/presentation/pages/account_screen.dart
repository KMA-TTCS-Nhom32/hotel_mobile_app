import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/index.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/logo_widgets.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/controller/auth_state.dart';
import '../../../auth/domain/entities/user_profile.dart';

/// Account screen showing user profile and settings
class AccountScreen extends ConsumerWidget {
  /// Creates an account screen
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final loc = AppLocalizations.of(context)!;

    // If user is authenticated and we have profile data
    if (authState is AuthAuthenticatedState && authState.userProfile != null) {
      return _buildAuthenticatedContent(
        context,
        authState.userProfile!,
        loc,
        ref,
      );
    }

    // If user is authenticated but we don't have profile data yet
    if (authState is AuthAuthenticatedState) {
      return Scaffold(
        appBar: LogoAppBar(title: loc.accountTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Fallback - should not reach here as navigation should redirect to login
    return Scaffold(
      appBar: LogoAppBar(title: loc.accountTitle),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LargeLogo(height: 80, useLight: true),
            const SizedBox(height: 24),
            Text(loc.accountSignIn),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedContent(
    BuildContext context,
    UserProfile profile,
    AppLocalizations loc,
    WidgetRef ref,
  ) {
    return Scaffold(
      appBar: LogoAppBar(title: loc.accountTitle, centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(authControllerProvider.notifier).refreshUserProfile();
        },
        child: ListView(
          children: [
            _buildProfileHeader(context, profile, loc),
            const SizedBox(height: 16),
            _buildPersonalInfoSection(context, profile, loc),
            const Divider(),
            _buildPreferencesSection(context, loc, ref),
            const Divider(),
            _buildSupportSection(context, loc),
            const Divider(),
            _buildSignOutSection(context, loc, ref),
            const SizedBox(height: 24),
            _buildVersionInfo(context, loc),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    UserProfile profile,
    AppLocalizations loc,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryLight,
            AppColors.primaryLight.withAlpha((0.7 * 255).toInt()),
          ],
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child:
                profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        profile.avatarUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primaryLight,
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primaryLight,
                          );
                        },
                      ),
                    )
                    : Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primaryLight,
                    ),
          ),
          const SizedBox(height: 16),
          Text(
            loc.accountWelcome(profile.fullName),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              profile.role.toString().split('.').last.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (profile.loyaltyPoints > 0)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha((0.3 * 255).toInt()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '${profile.loyaltyPoints} points',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(
    BuildContext context,
    UserProfile profile,
    AppLocalizations loc,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.accountPersonalInfo,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            context,
            icon: Icons.person_outline,
            title: "Full Name",
            subtitle: profile.fullName,
          ),
          const Divider(),
          if (profile.email != null)
            _buildInfoItem(
              context,
              icon: Icons.email_outlined,
              title: loc.accountEmail,
              subtitle: profile.email!,
              trailing:
                  profile.isEmailVerified
                      ? _buildVerifiedBadge(context, loc.accountVerified)
                      : _buildUnverifiedBadge(context, loc.accountUnverified),
            ),
          if (profile.email != null) const Divider(),
          if (profile.phone != null && profile.phone!.isNotEmpty)
            _buildInfoItem(
              context,
              icon: Icons.phone_outlined,
              title: loc.accountPhone,
              subtitle: profile.phone!,
              trailing:
                  profile.isPhoneVerified
                      ? _buildVerifiedBadge(context, loc.accountVerified)
                      : _buildUnverifiedBadge(context, loc.accountUnverified),
            ),
          if (profile.gender != null)
            Column(
              children: [
                const Divider(),
                _buildInfoItem(
                  context,
                  icon: Icons.person_outlined,
                  title: loc.accountGender,
                  subtitle:
                      profile.gender.toString().split('.').last.toLowerCase() ==
                              'male'
                          ? loc.accountMale
                          : loc.accountFemale,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(
    BuildContext context,
    AppLocalizations loc,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.accountPreferences,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildListTile(
            context,
            icon: Icons.language,
            title: loc.accountLanguage,
            onTap: () => _showLanguageSelectionDialog(context, ref),
          ),
          const Divider(),
          _buildListTile(
            context,
            icon: Icons.payments_outlined,
            title: loc.accountPaymentMethods,
            onTap: () {},
          ),
          const Divider(),
          _buildListTile(
            context,
            icon: Icons.star_outline,
            title: loc.accountLoyaltyProgram,
            onTap: () {},
          ),
          const Divider(),
          _buildListTile(
            context,
            icon: Icons.history,
            title: loc.accountBookingHistory,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.accountSupport,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildListTile(
            context,
            icon: Icons.help_outline,
            title: loc.accountHelpCenter,
            onTap: () {},
          ),
          const Divider(),
          _buildListTile(
            context,
            icon: Icons.message_outlined,
            title: loc.accountContactUs,
            onTap: () {},
          ),
          const Divider(),
          _buildListTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: loc.accountPrivacyPolicy,
            onTap: () {},
          ),
          const Divider(),
          _buildListTile(
            context,
            icon: Icons.gavel_outlined,
            title: loc.accountTerms,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutSection(
    BuildContext context,
    AppLocalizations loc,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.errorLight.withAlpha((0.1 * 255).toInt()),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.logout, color: AppColors.errorLight),
        ),
        title: Text(
          loc.accountSignOut,
          style: TextStyle(
            color: AppColors.errorLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => _confirmSignOut(context, loc, ref),
      ),
    );
  }

  Widget _buildVersionInfo(BuildContext context, AppLocalizations loc) {
    return Container(
      color: AppColors.surfaceDark,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          const LargeLogo(height: 40, useLight: true),
          const SizedBox(height: 8),
          Text(
            loc.accountVersion(
              '1.0.0',
            ), // Version should be dynamic in real app
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withAlpha((0.1 * 255).toInt()),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primaryLight),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withAlpha((0.1 * 255).toInt()),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primaryLight),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildVerifiedBadge(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.green, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildUnverifiedBadge(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline, color: Colors.orange, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: Colors.orange, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelectionDialog(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final currentLocale = ref.read(localeNotifierProvider).languageCode;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Column(
              children: [
                Image.asset('assets/icons/logo-large-dark.png', height: 42),
                const SizedBox(height: 16),
                Text(loc.languageSelect),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  value: 'en',
                  groupValue: currentLocale,
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    _changeLanguage(context, ref, const Locale('en'));
                  },
                  title: Text(loc.languageEnglish),
                  secondary: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset(
                        'assets/images/england-flag.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                RadioListTile<String>(
                  value: 'vi',
                  groupValue: currentLocale,
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    _changeLanguage(context, ref, const Locale('vi'));
                  },
                  title: Text(loc.languageVietnamese),
                  secondary: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset(
                        'assets/images/vietnam-flag.webp',
                        package: null,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _changeLanguage(BuildContext context, WidgetRef ref, Locale locale) {
    // Access the locale notifier using the WidgetRef from Riverpod
    ref.read(localeNotifierProvider.notifier).setLocale(locale);

    // Show snackbar with language changed message
    final loc = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          loc.languageChanged(
            locale.languageCode == 'en' ? 'English' : 'Tiếng Việt',
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmSignOut(
    BuildContext context,
    AppLocalizations loc,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(loc.accountSignOut),
            content: Text(loc.accountLogoutConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(loc.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  loc.accountSignOut,
                  style: TextStyle(color: AppColors.errorLight),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      // Create a dialog controller that can be dismissed safely
      BuildContext? dialogContext;

      // Show loading dialog and capture its context
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(loc.accountLogoutProgress),
              ],
            ),
          );
        },
      );

      try {
        // Perform logout
        await ref.read(authControllerProvider.notifier).logout();

        // Safely close the dialog if it's still showing
        if (dialogContext != null && Navigator.canPop(dialogContext!)) {
          Navigator.of(dialogContext!).pop();
        }
      } catch (e) {
        // Handle any errors during logout
        if (dialogContext != null && Navigator.canPop(dialogContext!)) {
          Navigator.of(dialogContext!).pop();
        }

        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
