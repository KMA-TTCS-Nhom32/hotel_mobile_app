import 'package:flutter/material.dart';
import '../../../../core/theme/index.dart';
import '../widgets/featured_hotels_carousel.dart';
import '../widgets/popular_destinations_section.dart';
import '../widgets/special_offers_section.dart';
import '../widgets/quick_booking_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LuxStay'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigation to search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigation to notifications screen
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh data
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome back, Guest!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                QuickBookingSection(),
                SizedBox(height: 16),
                FeaturedHotelsCarousel(),
                SizedBox(height: 24),
                PopularDestinationsSection(),
                SizedBox(height: 24),
                SpecialOffersSection(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
