import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class QuickBookingSection extends StatelessWidget {
  const QuickBookingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.06 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Booking',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Destination Field
          _buildSearchField(
            icon: Icons.location_on_outlined,
            hint: 'Where do you want to stay?',
            onTap: () {
              // Open destination search
            },
          ),
          const SizedBox(height: 12),
          // Date Range Field
          _buildSearchField(
            icon: Icons.calendar_today_outlined,
            hint: 'Check-in — Check-out',
            onTap: () {
              // Open date picker
            },
          ),
          const SizedBox(height: 12),
          // Guests Field
          _buildSearchField(
            icon: Icons.person_outline,
            hint: '2 adults, 0 children',
            onTap: () {
              // Open guests selector
            },
          ),
          const SizedBox(height: 16),
          // Search Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Perform search
              },
              child: const Text(
                'Search Hotels',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required IconData icon,
    required String hint,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hint,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
