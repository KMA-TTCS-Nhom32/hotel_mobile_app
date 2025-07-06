import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../theme/app_colors.dart';

/// Custom AppBar with logo for the application
class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a custom app bar with the app logo
  const LogoAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.useLight = false,
    this.showLogo = true,
  });

  /// The title displayed in the app bar
  final String title;

  /// Actions displayed on the right side of the app bar
  final List<Widget>? actions;

  /// Whether to center the title
  final bool centerTitle;

  /// Whether to use light theme logo (for dark backgrounds)
  final bool useLight;

  /// Whether to show the logo
  final bool showLogo;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      actions: actions,
      leading:
          showLogo
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  useLight ? AppAssets.logoDark : AppAssets.logoLight,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 24),
                ),
              )
              : null,
    );
  }
}

/// Large logo widget for use in various screens
class LargeLogo extends StatelessWidget {
  /// Creates a large logo widget
  const LargeLogo({super.key, this.height = 80.0, this.useLight = false});

  /// Height of the logo
  final double height;

  /// Whether to use light theme logo (for dark backgrounds)
  final bool useLight;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      useLight ? AppAssets.logoLargeLight : AppAssets.logoLargeDark,
      height: height,
      fit: BoxFit.contain,
      errorBuilder:
          (context, error, stackTrace) => const Icon(Icons.error, size: 24),
    );
  }
}

/// Extension on Scaffold to easily create a scaffold with logo app bar
// Extension methods for LogoAppBar
extension LogoAppBarExtension on LogoAppBar {
  /// Creates a scaffold with this logo app bar
  Scaffold scaffold({
    required Widget body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? bottomNavigationBar,
    bool? resizeToAvoidBottomInset,
    Color? backgroundColor,
  }) {
    return Scaffold(
      appBar: this,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
    );
  }
}
