import 'package:flutter/material.dart';
import '../../../../core/localization/index.dart';
import '../widgets/booking_card.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bookingsTitle),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white, // White text for selected tab
          unselectedLabelColor:
              Theme.of(
                context,
              ).textTheme.bodyMedium?.color, // Default text color
          indicator: BoxDecoration(
            color:
                Theme.of(
                  context,
                ).colorScheme.primary, // Background color for selected tab
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.bookingsUpcoming),
            Tab(
              text: AppLocalizations.of(context)!.bookingsCompleted,
            ), // Changed from 'Ongoing'
            Tab(
              text: AppLocalizations.of(context)!.bookingsCancelled,
            ), // Changed from 'Completed'
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(
            AppLocalizations.of(context)!.bookingsUpcoming.toLowerCase(),
          ),
          _buildBookingList(
            AppLocalizations.of(context)!.bookingsCompleted.toLowerCase(),
          ),
          _buildBookingList(
            AppLocalizations.of(context)!.bookingsCancelled.toLowerCase(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(String type) {
    // Sample data - In a real app, this would come from an API
    final bookings = [
      {
        'id': '1',
        'hotelName': 'Grand Plaza Hotel',
        'roomType': 'Deluxe Room',
        'checkInDate': 'Aug 10, 2025',
        'checkOutDate': 'Aug 15, 2025',
        'status': 'confirmed',
        'image':
            'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg',
        'bookingId': 'BK-20250810-001',
        'totalAmount': '\$580',
      },
      {
        'id': '2',
        'hotelName': 'Ocean View Resort',
        'roomType': 'Superior Suite',
        'checkInDate': 'Sep 5, 2025',
        'checkOutDate': 'Sep 8, 2025',
        'status': 'confirmed',
        'image':
            'https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg',
        'bookingId': 'BK-20250905-002',
        'totalAmount': '\$420',
      },
      {
        'id': '3',
        'hotelName': 'Mountain Retreat',
        'roomType': 'Standard Room',
        'checkInDate': 'Oct 12, 2025',
        'checkOutDate': 'Oct 14, 2025',
        'status': 'pending',
        'image':
            'https://images.pexels.com/photos/2034335/pexels-photo-2034335.jpeg',
        'bookingId': 'BK-20251012-003',
        'totalAmount': '\$320',
      },
    ];

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh data
        await Future.delayed(const Duration(seconds: 1));
      },
      child:
          bookings.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hotel_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.bookingsNoBookings,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to hotel search
                      },
                      child: Text(AppLocalizations.of(context)!.homeSearchHint),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return BookingCard(
                    hotelName: booking['hotelName'] as String,
                    roomType: booking['roomType'] as String,
                    checkInDate: booking['checkInDate'] as String,
                    checkOutDate: booking['checkOutDate'] as String,
                    status: booking['status'] as String,
                    imageUrl: booking['image'] as String,
                    bookingId: booking['bookingId'] as String,
                    totalAmount: booking['totalAmount'] as String,
                    onViewPressed: () {
                      // Navigate to booking details
                    },
                    onCancelPressed: () {
                      // Show cancel booking dialog
                    },
                  );
                },
              ),
    );
  }
}
