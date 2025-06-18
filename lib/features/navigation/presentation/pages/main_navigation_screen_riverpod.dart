import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.local_offer_outlined),
          activeIcon: Icon(Icons.local_offer),
          label: 'Promotions',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline),
          activeIcon: Icon(Icons.bookmark),
          label: 'Bookings',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard_outlined),
          activeIcon: Icon(Icons.card_giftcard),
          label: 'Offers',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
    );
  }
}
