import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/FavoritesController.dart';
import 'package:reside_smart_flutter/Widgets/MyHomeListingCard.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();

  @override
  void initState() {
    super.initState();
    favoritesController.loadFavorites();
  }

  Future<void> _onRefresh() {
    return favoritesController.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'My Favorites'),
      body: SafeArea(
        child: Obx(() {
          if (favoritesController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (favoritesController.favorites.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RichText(
                  text: TextSpan(
                    style: tt.bodyLarge,
                    children: [
                      const TextSpan(text: 'You have '),
                      TextSpan(
                        text: '${favoritesController.favorites.length}',
                        style: tt.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' favorites'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset),
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: favoritesController.favorites.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder:
                          (ctx, i) => MyHomeListingCard(
                            listingModel: favoritesController.favorites[i],
                          ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
