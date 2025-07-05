import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/index.dart';
import '../../../../core/providers/navigation_provider.dart';
import '../../../home/presentation/pages/home_page_riverpod.dart';
import '../../../promotions/presentation/pages/promotions_page.dart';
import '../../../bookings/presentation/pages/bookings_page.dart';
import '../../../offers/presentation/pages/offers_page.dart';
import '../../../account/presentation/pages/account_page.dart';

class MainNavigationScreenRiverpod extends ConsumerWidget {
  const MainNavigationScreenRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current tab
    final currentTab = ref.watch(navigationProvider);

    return Scaffold(
      body: _buildBody(currentTab),
      bottomNavigationBar: _buildBottomNavigationBar(context, currentTab, ref),
    );
  }

  Widget _buildBody(MainTab tab) {
    switch (tab) {
      case MainTab.home:
        return const HomePage();
      case MainTab.promotions:
        return const PromotionsPage();
      case MainTab.bookings:
        return const BookingsPage();
      case MainTab.offers:
        return const OffersPage();
      case MainTab.account:
        return const AccountPage();
    }
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    MainTab currentTab,
    WidgetRef ref,
  ) {
    final loc = AppLocalizations.of(context);

    if (loc == null) {
      // Fallback to default English labels or handle error
      throw FlutterError('Localization not initialized');
    }

    return BottomNavigationBar(
      currentIndex: currentTab.index,
      onTap:
          (index) => ref
              .read(navigationProvider.notifier)
              .setTab(MainTab.values[index]),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: loc.navHome,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.local_offer_outlined),
          activeIcon: const Icon(Icons.local_offer),
          label: loc.navPromos,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bookmark_outline),
          activeIcon: const Icon(Icons.bookmark),
          label: loc.navBookings,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.card_giftcard_outlined),
          activeIcon: const Icon(Icons.card_giftcard),
          label: loc.navOffers,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          activeIcon: const Icon(Icons.person),
          label: loc.navAccount,
        ),
      ],
    );
  }
}
