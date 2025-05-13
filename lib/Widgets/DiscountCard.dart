import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/ListingDiscountModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Services/ListingDiscountService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class DiscountCard extends StatelessWidget {
  final ListingDiscountModel discount;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final ListingDiscountService listingDiscountService =
      Get.find<ListingDiscountService>();

  DiscountCard({
    super.key,
    required this.discount,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 320,
        height: 220,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              '${Api.baseURL}/storage/${discount.listing!.images![0]}',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),

            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '-${discount.percentage.toStringAsFixed(0)}%',
                  style: textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  AppDialog.showConfirm(
                    message: "Are you sure you want to delete this discount",
                    onConfirm: () async {
                      print(discount.discountId);
                      await listingDiscountService.deleteDiscount(
                        discount.discountId,
                      );
                    },
                  );
                },
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.delete, size: 16, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    discount.name,
                    style: textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatDate(discount.startDate)} - ${_formatDate(discount.endDate)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (discount.listing != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 18,
                              color: Colors.greenAccent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              getPriceToShow(),
                              style: textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, size: 18, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              discount.listing!.averageReviews?.toStringAsFixed(
                                    1,
                                  ) ??
                                  '4.5',
                              style: textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String getPriceToShow() {
    final listing = discount.listing!;
    print('Listing Type: ${listing.type}');
    print('Discount rentalOptionId: ${discount.rentalOptionId}');
    print(
      'Rental Options: ${listing.rentalOptions?.map((e) => e.id).toList()}',
    );

    if (listing.type == 'sell') {
      return discount.getDiscountPrice().toStringAsFixed(2);
    }

    final selectedOption = listing.rentalOptions?.firstWhereOrNull(
      (option) => option.id == discount.rentalOptionId,
    );

    if (selectedOption != null) {
      final discountedPrice =
          selectedOption.price * (1 - discount.percentage / 100);
      return discountedPrice.toStringAsFixed(2);
    } else {
      return listing.price!.toStringAsFixed(2);
    }
  }
}
