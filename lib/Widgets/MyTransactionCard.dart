import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/ListingDiscountModel.dart';
import 'package:reside_smart_flutter/Models/RentalOption.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';

class TransactionCard extends StatelessWidget {
  final int id;
  final String image;
  final String name;
  final String price;
  final String rating;
  final String location;
  final String type;
  final List<RentalOption>? rentalOptions;
  final int? selectedRentalOptionId;
  final List<ListingDiscountModel> discounts;
  final int quantity; // Add quantity field

  const TransactionCard({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
    required this.location,
    required this.type,
    this.rentalOptions,
    this.selectedRentalOptionId,
    required this.discounts,
    this.quantity = 1, // Add quantity parameter with default value
  });

  @override
  Widget build(BuildContext context) {
    RentalOption? selectedOption;

    if (type == 'rent' &&
        selectedRentalOptionId != null &&
        rentalOptions != null &&
        rentalOptions!.isNotEmpty) {
      selectedOption = rentalOptions!.firstWhereOrNull(
        (opt) => opt.id == selectedRentalOptionId,
      );
    }

    ListingDiscountModel? getActiveDiscountForSelectedOption() {
      if (type == 'rent' && selectedOption != null) {
        return discounts.firstWhereOrNull(
          (d) =>
              d.status.toLowerCase() == 'active' &&
              d.rentalOptionId == selectedOption!.id,
        );
      } else {
        return discounts.firstWhereOrNull(
          (d) => d.status.toLowerCase() == 'active',
        );
      }
    }

    String getFormattedPrice() {
      double originalPrice;
      final activeDiscount = getActiveDiscountForSelectedOption();

      if (type == 'rent' && selectedOption != null) {
        originalPrice = selectedOption.price * quantity; // Multiply by quantity
        if (activeDiscount != null && activeDiscount.percentage != null) {
          double discounted =
              originalPrice -
              (originalPrice * (activeDiscount.percentage! / 100));
          return '\$${discounted.toStringAsFixed(2)} (${activeDiscount.percentage!}% off)';
        }
        return '\$${originalPrice.toStringAsFixed(2)} × $quantity ${selectedOption.unit}';
      } else {
        originalPrice = double.tryParse(price) ?? 0.0;
        if (activeDiscount != null && activeDiscount.percentage != null) {
          double discounted =
              originalPrice -
              (originalPrice * (activeDiscount.percentage! / 100));
          return '\$${discounted.toStringAsFixed(2)} (${activeDiscount.percentage!}% off)';
        }
        return '\$${originalPrice.toStringAsFixed(2)}';
      }
    }

    String? getOriginalPriceText() {
      final activeDiscount = getActiveDiscountForSelectedOption();

      if (activeDiscount != null && activeDiscount.percentage != null) {
        if (type == 'rent' && selectedOption != null) {
          return '\$${selectedOption.price.toStringAsFixed(2)}/${selectedOption.duration} ${selectedOption.unit}';
        } else {
          return '\$$price';
        }
      }
      return null;
    }

    return GestureDetector(
      onTap: () {
        // Get.toNamed('/view-Single-listing', arguments: {'id': id});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 150,
              height: 130,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MyNetworkImage(url: "storage/$image", fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      if (getOriginalPriceText() != null)
                        Text(
                          getOriginalPriceText()!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Text(
                        getFormattedPrice(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(rating, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "For $type",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
