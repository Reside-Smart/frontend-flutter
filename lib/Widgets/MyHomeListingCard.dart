import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Services/FavoriteService.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';

class MyHomeListingCard extends StatefulWidget {
  final ListingModel listingModel;

  const MyHomeListingCard({super.key, required this.listingModel});

  @override
  State<MyHomeListingCard> createState() => _MyHomeListingCardState();
}

class _MyHomeListingCardState extends State<MyHomeListingCard> {
  final FavoriteService _favService = Get.find<FavoriteService>();
  final AuthService _authService = Get.find<AuthService>();
  final RxBool _isFavorite = false.obs;
  final RxBool _isToggling = false.obs;

  @override
  void initState() {
    super.initState();
    _isFavorite.value = widget.listingModel.isFavorite;
    print(_isFavorite.value);
  }

  Future<void> _toggleFavorite() async {
    if (_isToggling.value) return;
    _isToggling.value = true;

    final id = widget.listingModel.id;
    bool success;
    if (_isFavorite.value) {
      success = await _favService.removeFavorite(id!);
    } else {
      success = await _favService.addFavorite(id!);
    }

    if (success) {
      _isFavorite.value = !_isFavorite.value;
    } else {
      Get.snackbar(
        'Error',
        'Could not update favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    _isToggling.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/view-Single-listing',
          arguments: {'id': widget.listingModel.id},
        );
      },
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    widget.listingModel.images != null &&
                            widget.listingModel.images!.isNotEmpty
                        ? MyNetworkImage(
                          url: "storage/${widget.listingModel.images![0]}",
                          fit: BoxFit.cover,
                        )
                        : Container(),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 8,
                      right: 8,
                      child: Obx(() {
                        return GestureDetector(
                          onTap: _toggleFavorite,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                _isFavorite.value
                                    ? Colors.redAccent
                                    : Colors.white.withOpacity(0.8),
                            child:
                                _isToggling.value
                                    ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Icon(
                                      _isFavorite.value
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 16,
                                      color:
                                          _isFavorite.value
                                              ? Colors.white
                                              : Colors.redAccent,
                                    ),
                          ),
                        );
                      }),
                    ),

                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.listingModel.type == 'rent' &&
                                  widget.listingModel.rentalOptions != null &&
                                  widget.listingModel.rentalOptions!.isNotEmpty
                              ? '${widget.listingModel.rentalOptions!.first.price}/${widget.listingModel.rentalOptions!.first.duration} ${widget.listingModel.rentalOptions!.first.unit}'
                              : '\$${widget.listingModel.price}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.listingModel.name!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "⭐ ${widget.listingModel.averageReviews}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          widget.listingModel.address!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
}
