import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/RentalOption.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';

class PropertyCard extends StatefulWidget {
  final int id;
  final String image;
  final String name;
  final String price;
  final String rating;
  final String location;
  final String type;
  final List<RentalOption>? rentalOptions;

  PropertyCard({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
    required this.location,
    required this.type,
    this.rentalOptions,
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  final AuthService authService = Get.find<AuthService>();
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      // height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 170,
                height: 170,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: MyNetworkImage(
                    url: "storage/${widget.image}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      '/Update-listing',
                      arguments: {'id': widget.id},
                    );
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    // Handle delete logic here
                    print('Delete clicked');
                  },
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.delete, size: 16, color: Colors.white),
                  ),
                ),
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
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.type == 'rent' &&
                            widget.rentalOptions != null &&
                            widget.rentalOptions!.isNotEmpty
                        ? '${widget.rentalOptions!.first.price}/${widget.rentalOptions!.first.duration} ${widget.rentalOptions!.first.unit}'
                        : '\$${widget.price}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      Text(
                        widget.rating,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),
                OverflowBar(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    Text(widget.location, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "For ${widget.type}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
