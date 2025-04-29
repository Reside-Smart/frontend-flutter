// Controllers/SearchController.dart
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Models/CategoryModel.dart';
import 'package:reside_smart_flutter/Services/ListingService.dart';
import 'package:reside_smart_flutter/Services/CategoryService.dart';

class SearchController extends GetxController {
  final ListingService _listingService = Get.find<ListingService>();
  final CategoryService _categoryService = Get.find<CategoryService>();

  var query = ''.obs;
  var selectedCategory = Rxn<Category>();
  var isLoading = false.obs;
  var results = <ListingModel>[].obs;
  var categories = <Category>[].obs;
  var isCatLoading = false.obs;

  Future<void> loadCategories() async {
    if (isLoading.value) return;

    isCatLoading.value = true;
    try {
      categories.value = await _categoryService.getCategories();
    } finally {
      isCatLoading.value = false;
    }
  }

  Future<void> search() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      results.value = await _listingService.searchListings(
        query: query.value,
        categoryId: selectedCategory.value?.id,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearFilters() {
    query.value = '';
    selectedCategory.value = null;
    search();
  }
}
