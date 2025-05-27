import 'package:flutter/material.dart';
import '../../../../core/localization/index.dart';
import '../widgets/hotel_offer_card.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  // Use getter for localization for easier access
  AppLocalizations get loc => AppLocalizations.of(context)!;
  // We'll use these keys to store category data
  late final List<String> _categories;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Initialize categories
    _categories = [
      'All Offers',
      'Hotels',
      'Resorts',
      'Vacations',
      'Flights',
      'Packages',
    ];
    _selectedCategory = _categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.navOffers),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Refresh data
                await Future.delayed(const Duration(seconds: 1));
              },
              child: _buildOffersList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children:
              _categories.map((category) {
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Theme.of(
                      context,
                    ).primaryColor.withAlpha((0.15 * 255).toInt()),
                    labelStyle: TextStyle(
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildOffersList() {
    // Sample data - In a real app, this would come from an API
    final offers = [
      {
        'id': '1',
        'hotelName': 'Grand Plaza Hotel',
        'location': 'New York, USA',
        'image':
            'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg',
        'offerTitle': 'Summer Special Deal',
        'discount': '25% OFF',
        'originalPrice': '\$180',
        'discountedPrice': '\$135',
        'rating': 4.7,
        'amenities': ['Pool', 'Spa', 'Gym', 'Restaurant'],
      },
      {
        'id': '2',
        'hotelName': 'Ocean View Resort',
        'location': 'Miami, USA',
        'image':
            'https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg',
        'offerTitle': 'Weekend Getaway',
        'discount': '20% OFF',
        'originalPrice': '\$220',
        'discountedPrice': '\$176',
        'rating': 4.8,
        'amenities': ['Beach', 'Pool', 'Bar', 'Breakfast'],
      },
      {
        'id': '3',
        'hotelName': 'Mountain Retreat',
        'location': 'Denver, USA',
        'image':
            'https://images.pexels.com/photos/2034335/pexels-photo-2034335.jpeg',
        'offerTitle': 'Adventure Package',
        'discount': '15% OFF',
        'originalPrice': '\$150',
        'discountedPrice': '\$127.5',
        'rating': 4.5,
        'amenities': ['Hiking', 'View', 'Restaurant', 'Parking'],
      },
      {
        'id': '4',
        'hotelName': 'City Central Hotel',
        'location': 'Chicago, USA',
        'image':
            'https://images.pexels.com/photos/2869215/pexels-photo-2869215.jpeg',
        'offerTitle': 'Business Travel Deal',
        'discount': '15% OFF',
        'originalPrice': '\$200',
        'discountedPrice': '\$170',
        'rating': 4.6,
        'amenities': ['WiFi', 'Breakfast', 'Fitness Center', 'Business Lounge'],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return HotelOfferCard(
          hotelName: offer['hotelName'] as String,
          location: offer['location'] as String,
          imageUrl: offer['image'] as String,
          offerTitle: offer['offerTitle'] as String,
          discount: offer['discount'] as String,
          originalPrice: offer['originalPrice'] as String,
          discountedPrice: offer['discountedPrice'] as String,
          rating: offer['rating'] as double,
          amenities: List<String>.from(offer['amenities'] as List),
          onPressed: () {
            // Navigate to hotel details
          },
        );
      },
    );
  }
}
