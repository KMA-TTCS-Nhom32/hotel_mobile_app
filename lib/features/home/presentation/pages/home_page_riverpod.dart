import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/featured_hotels_carousel_riverpod.dart';
import '../widgets/popular_destinations_section.dart';
import '../widgets/special_offers_section.dart';
import '../widgets/quick_booking_section.dart';
import '../../controller/home_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch data on page load
    Future.microtask(
      () => ref.read(homeControllerProvider.notifier).fetchFeaturedHotels(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the home state
    final homeState = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AHomeVilla Hotel'),
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
            await ref
                .read(homeControllerProvider.notifier)
                .fetchFeaturedHotels();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome to AHomeVilla Hotel',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), // Featured Hotels - Use state from controller
                homeState.when(
                  initial:
                      () => const Center(
                        child: Text('Loading featured hotels...'),
                      ),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  success:
                      (hotels) => FeaturedHotelsCarouselRiverpod(
                        featuredHotels: hotels,
                      ),
                  error: (message, _) => Center(child: Text('Error: $message')),
                ),
                const PopularDestinationsSection(),
                const SpecialOffersSection(),
                const QuickBookingSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
