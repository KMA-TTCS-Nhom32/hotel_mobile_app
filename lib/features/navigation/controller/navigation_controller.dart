import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Enums
enum MainTab { home, promotions, bookings, offers, account }

/// Provider for navigation state
final navigationProvider = StateNotifierProvider<NavigationNotifier, MainTab>(
  (ref) => NavigationNotifier(),
);

/// Notifier for managing navigation state
class NavigationNotifier extends StateNotifier<MainTab> {
  NavigationNotifier() : super(MainTab.home);

  /// Change the current tab
  void setTab(MainTab tab) {
    state = tab;
  }
}
