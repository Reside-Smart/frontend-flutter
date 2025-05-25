import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/HomeController.dart';
import 'package:reside_smart_flutter/Models/ListingDiscountModel.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:reside_smart_flutter/Widgets/MyDrawer.dart';
import 'package:reside_smart_flutter/Widgets/MyHomeListingCard.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.find<HomeController>();
  final AuthService authService = Get.find<AuthService>();
  Future<void> openWhatsApp(String phone) async {
    try {
      final whatsappUrl = Uri.parse(
        'https://api.whatsapp.com/send?phone=$phone&text=Hello from Reside Smart',
      );
      print(whatsappUrl);
      await launchUrl(whatsappUrl);
    } catch (e) {
      AppDialog.showError(e.toString());
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _homeController.getNearbyEstates();
    _homeController.getAllDiscounts();
    _homeController.getAllCategories();
    _homeController.getTopLocations();
    _homeController.getTopAgents();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      drawer: MyDrawer(authService: authService),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 325,
                height: 325,
                decoration: BoxDecoration(
                  color: const Color(0x3325B4F8),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              top: -50,
              right: 50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0x6625B4F8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            RefreshIndicator(
              onRefresh: () async {
                _homeController.getNearbyEstates();
                _homeController.getAllDiscounts();
                _homeController.getAllCategories();
                _homeController.getTopLocations();
                _homeController.getTopAgents();
              },
              child: ListView(
                padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 32),
                children: [
                  Row(
                    children: [
                      Text(
                        authService.globalUser?.address ??
                            'No address available',
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.notifications),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  RichText(
                    text: TextSpan(
                      text: 'Hey, ',
                      style: tt.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w100,
                      ),
                      children: [
                        TextSpan(
                          text: authService!.globalUser!.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            inherit: false,
                          ),
                        ),
                        const TextSpan(text: '!\nLet\'s start exploring'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Available Categories:",
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Obx(() {
                    if (_homeController.isCategoriesLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_homeController.categories.isEmpty) {
                      return const Center(child: Text('No Categories Found.'));
                    }
                    return Wrap(
                      spacing: 8,
                      children: List.generate(
                        _homeController.categories.length,
                        (i) {
                          final isSelected =
                              i == _homeController.selectedCategory;
                          return Chip(
                            label: Text(
                              _homeController.categories[i].name,
                              style: TextStyle(
                                color: isSelected ? Colors.white : cs.onSurface,
                              ),
                            ),
                            backgroundColor:
                                isSelected
                                    ? cs.primary
                                    : const Color.fromARGB(255, 247, 249, 250),
                            shape: StadiumBorder(side: BorderSide.none),
                          );
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  Obx(() {
                    if (_homeController.isDiscountsLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_homeController.discounts.isEmpty) {
                      return const Center(child: Text('No Discounts Found.'));
                    }
                    return SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _homeController.discounts.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder:
                            (ctx, i) => DiscountCard(
                              discount: _homeController.discounts[i],
                              colorScheme: cs,
                              textTheme: tt,
                            ),
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  Text(
                    'Top Agents',
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (_homeController.isTopAgentsLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_homeController.topAgents.isEmpty) {
                      return Center(
                        child: Text(
                          'No agents found',
                          style: tt.bodyMedium?.copyWith(
                            color: cs.onSurface.withOpacity(0.5),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 150,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: _homeController.topAgents.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (ctx, index) {
                          final agent = _homeController.topAgents[index];
                          final avgReview =
                              double.tryParse(
                                agent['avg_review']?.toString() ?? '0',
                              ) ??
                              0;
                          final roundedReview = avgReview.toStringAsFixed(1);

                          return GestureDetector(
                            onTap: () {
                              openWhatsApp(agent['phone_number']);
                            },
                            child: Container(
                              width: 140,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: cs.surfaceVariant.withOpacity(0.2),
                                border: Border.all(
                                  color: cs.outline.withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: cs.primary.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: cs.primary.withOpacity(
                                        0.1,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: 24,
                                        color: cs.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    agent['name'],
                                    style: tt.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.apartment,
                                        size: 14,
                                        color: cs.onSurface.withOpacity(0.6),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${agent['listings_count']}',
                                        style: tt.bodySmall?.copyWith(
                                          color: cs.onSurface.withOpacity(0.6),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          roundedReview,
                                          style: tt.bodySmall?.copyWith(
                                            color: Colors.amber.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Popular Locations',
                              style: tt.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      Obx(() {
                        if (_homeController.isTopLocationsLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final validLocations =
                            _homeController.topLocations.where((loc) {
                              final name = loc['location_name'] as String?;
                              return name != null && name.isNotEmpty;
                            }).toList();

                        if (validLocations.isEmpty) {
                          return Center(
                            child: Text(
                              'No locations available',
                              style: tt.bodyMedium?.copyWith(
                                color: cs.onSurface.withOpacity(0.5),
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: validLocations.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 16),
                            itemBuilder: (ctx, index) {
                              final loc = validLocations[index];
                              final locationName =
                                  loc['location_name'] as String;
                              final listingsCount =
                                  loc['listings_count'] as int?;

                              return Container(
                                width: 160,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: cs.surfaceVariant.withOpacity(0.2),
                                  border: Border.all(
                                    color: cs.outline.withOpacity(0.1),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '📍$locationName',
                                      style: tt.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (listingsCount != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        '$listingsCount properties',
                                        style: tt.bodySmall?.copyWith(
                                          color: cs.onSurface.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),

                  Text(
                    'Explore Estates',
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Obx(() {
                    if (_homeController.isNearbyEstatesLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_homeController.nearbyEstates.isEmpty) {
                      return const Center(child: Text('No Estates Found.'));
                    }
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _homeController.nearbyEstates.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder:
                          (ctx, idx) => MyHomeListingCard(
                            listingModel: _homeController.nearbyEstates[idx],
                          ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscountCard extends StatelessWidget {
  final ListingDiscountModel discount;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const DiscountCard({
    super.key,
    required this.discount,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/view-Single-listing',
          arguments: {'id': discount.listingId},
        );
      },
      child: ClipRRect(
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
                                discount.listing!.averageReviews
                                        ?.toStringAsFixed(1) ??
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

class Estate {
  final String title, location;
  final int price;
  final double? rating;

  Estate({
    required this.title,
    required this.price,
    this.location = '',
    this.rating,
  });
}

class Location {
  final String name;
  Location({required this.name});
}
