// lib/Controllers/FavoritesController.dart

import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/ListingService.dart';

class FavoritesController extends GetxController {
  final ListingService _listingService = Get.find<ListingService>();

  var favorites = <ListingModel>[].obs;
  var isLoading = false.obs;

  Future<void> loadFavorites() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      favorites.value = await _listingService.getFavorites();
    } finally {
      isLoading.value = false;
    }
  }
}
