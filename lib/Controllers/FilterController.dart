import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Models/CategoryModel.dart';
import 'package:reside_smart_flutter/Services/ListingService.dart';
import 'package:reside_smart_flutter/Services/CategoryService.dart';

class FilterController extends GetxController {
  final ListingService _listingService = Get.find<ListingService>();
  final CategoryService _categoryService = Get.find<CategoryService>();

  var selectedType = 'sell'.obs;
  var priceRange = const RangeValues(0, 10000).obs;
  var selectedCategories = <int>[].obs;
  var searchQuery = ''.obs;
  var isFilterApplied = false.obs;

  var isLoading = false.obs;
  var isCatLoading = false.obs;

  var filteredResults = <ListingModel>[].obs;
  var categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    if (isCatLoading.value) return;
    isCatLoading.value = true;
    try {
      categories.value = await _categoryService.getCategories();
    } finally {
      isCatLoading.value = false;
    }
  }

  Future<void> applyFilter() async {
    if (isLoading.value) return;
    isLoading.value = true;
    isFilterApplied.value = true;
    try {
      final results = await _listingService.filterListings(
        type: selectedType.value,
        minPrice: priceRange.value.start,
        maxPrice: priceRange.value.end,
        categoryIds: selectedCategories.toList(),
        search: searchQuery.value,
      );
      filteredResults.value = results;
    } finally {
      isLoading.value = false;
    }
  }

  void resetFilters() {
    selectedType.value = 'sell';
    priceRange.value = const RangeValues(0, 10000);
    selectedCategories.clear();
    searchQuery.value = '';
    applyFilter();
  }
}
