import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/HomeController.dart';
import 'package:reside_smart_flutter/Models/ListingDiscountModel.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Widgets/MyDrawer.dart';
import 'package:reside_smart_flutter/Widgets/MyHomeListingCard.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.find<HomeController>();
  final AuthService authService = Get.find<AuthService>();

  final topLocations = [
    Location(name: 'Bali'),
    Location(name: 'Jakarta'),
    Location(name: 'Yogyakarta'),
  ];

  @override
  void initState() {
    super.initState();
    _homeController.getNearbyEstates();
    _homeController.getAllDiscounts();
    _homeController.getAllCategories();
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
            // Large semi-transparent circle
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 325,
                height: 325,
                decoration: BoxDecoration(
                  color: const Color(0x3325B4F8), // 20% opacity
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Smaller more opaque circle
            Positioned(
              top: -50,
              right: 50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0x6625B4F8), // 40% opacity
                  shape: BoxShape.circle,
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 32),
              children: [
                // ───── Top Bar ─────
                Row(
                  children: [
                    _LocationDropdown(colorScheme: cs, textTheme: tt),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ───── Greeting ─────
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

                // ───── Category Chips ─────
                Obx(() {
                  if (_homeController.isCategoriesLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_homeController.categories.isEmpty) {
                    return const Center(child: Text('No Categories Found.'));
                  }
                  return Wrap(
                    spacing: 8,
                    children: List.generate(_homeController.categories.length, (
                      i,
                    ) {
                      final isSelected = i == _homeController.selectedCategory;
                      return FilterChip(
                        side: BorderSide.none,
                        selected: isSelected,
                        onSelected:
                            (_) => setState(
                              () => _homeController.selectedCategory = i,
                            ),
                        label: Text(_homeController.categories[i].name),
                        labelStyle: tt.labelLarge?.copyWith(
                          color: isSelected ? cs.onPrimary : cs.onSurface,
                        ),
                        backgroundColor: const Color.fromARGB(
                          255,
                          247,
                          249,
                          250,
                        ),
                        selectedColor: cs.primary,
                        showCheckmark: false,
                      );
                    }),
                  );
                }),
                const SizedBox(height: 24),

                // ───── Discounts (Horizontal) ─────
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

                // ───── Section Header ─────
                Text(
                  'Explore Nearby Estates',
                  style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // ───── Nearby Estates Grid ─────
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
          ],
        ),
      ),
    );
  }
}

class _LocationDropdown extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _LocationDropdown({required this.colorScheme, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: 'Jakarta, Indonesia',
        items: const [
          DropdownMenuItem(
            value: 'Jakarta, Indonesia',
            child: Text('Jakarta, Indonesia'),
          ),
          DropdownMenuItem(
            value: 'Bali, Indonesia',
            child: Text('Bali, Indonesia'),
          ),
        ],
        onChanged: (_) {},
        style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
        icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.onSurface),
        borderRadius: BorderRadius.circular(12),
        dropdownColor: colorScheme.surface,
      ),
    );
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
            // Dark overlay
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
            // Discount badge
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
            // Card content
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
                              '${discount.getDiscountPrice().toStringAsFixed(2)}',
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
}

class Location {
  final String name;
  Location({required this.name});
}
