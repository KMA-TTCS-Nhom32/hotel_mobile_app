import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/ui_state.dart';
import '../domain/entities/featured_hotel.dart';

/// Provider for the home controller
final homeControllerProvider =
    StateNotifierProvider<HomeController, UiState<List<FeaturedHotel>>>(
      (ref) => HomeController(),
    );

/// Controller for home screen - manages featured hotels
class HomeController extends StateNotifier<UiState<List<FeaturedHotel>>> {
  HomeController() : super(const InitialUiState());

  /// Fetch featured hotels
  Future<void> fetchFeaturedHotels() async {
    try {
      // Set loading state
      state = const LoadingUiState();

      // In a real app, this would call a repository
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for now
      final hotels = [
        FeaturedHotel(
          id: '1',
          name: 'Luxury Suite Hotel',
          description: 'Experience ultimate luxury',
          imageUrl: 'assets/images/placeholder.jpg',
          rating: 4.8,
          price: 250,
          location: 'Da Nang, Vietnam',
        ),
        FeaturedHotel(
          id: '2',
          name: 'Beach Front Resort',
          description: 'Wake up to ocean views',
          imageUrl: 'assets/images/placeholder.jpg',
          rating: 4.5,
          price: 180,
          location: 'Nha Trang, Vietnam',
        ),
      ];

      // Set success state with data
      state = SuccessUiState(hotels);
    } catch (e) {
      // Set error state
      state = ErrorUiState(
        'Failed to fetch hotels: ${e.toString()}',
        e is Exception ? e : null,
      );
    }
  }
}
