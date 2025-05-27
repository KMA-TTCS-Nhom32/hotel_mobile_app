import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/index.dart';
import '../../cubit/main_tab_cubit.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../promotions/presentation/pages/promotions_page.dart';
import '../../../bookings/presentation/pages/bookings_page.dart';
import '../../../offers/presentation/pages/offers_page.dart';
import '../../../account/presentation/pages/account_page.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainTabCubit(),
      child: const _MainNavigationView(),
    );
  }
}

class _MainNavigationView extends StatelessWidget {
  const _MainNavigationView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainTabCubit, MainTabState>(
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state.currentTab),
          bottomNavigationBar: _buildBottomNavigationBar(
            context,
            state.currentTab,
          ),
        );
      },
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

  Widget _buildBottomNavigationBar(BuildContext context, MainTab currentTab) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentTab.index,
        onTap:
            (index) =>
                context.read<MainTabCubit>().setTab(MainTab.values[index]),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        selectedIconTheme: IconThemeData(
          size: 28,
          color: Theme.of(context).colorScheme.primary,
        ),
        unselectedIconTheme: IconThemeData(
          size: 24,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
        ),
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
            icon: const Icon(Icons.book_outlined),
            activeIcon: const Icon(Icons.book),
            label: loc.navBookings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.hotel_outlined),
            activeIcon: const Icon(Icons.hotel),
            label: loc.navOffers,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle_outlined),
            activeIcon: const Icon(Icons.account_circle),
            label: loc.navAccount,
          ),
        ],
      ),
    );
  }
}
