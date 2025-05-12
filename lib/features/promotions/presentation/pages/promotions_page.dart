import 'package:flutter/material.dart';
import '../../../../core/theme/index.dart';
import '../widgets/promotion_card.dart';

class PromotionsPage extends StatelessWidget {
  const PromotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions'),
        centerTitle: true,
        elevation: 0,
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
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Current Promotions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 5, // Sample count
                  itemBuilder: (context, index) {
                    return PromotionCard(
                      title: 'Summer Vacation ${index + 1}',
                      description:
                          'Get ${(index + 1) * 5}% off on your next booking during summer',
                      discountValue: '${(index + 1) * 5}%',
                      expiryDate: 'Valid until Aug 31, 2025',
                      promoCode: 'SUMMER${index + 1}',
                      onPressed: () {
                        // Handle promotion tap
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
