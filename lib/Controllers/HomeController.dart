import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/CategoryModel.dart';
import 'package:reside_smart_flutter/Models/ListingDiscountModel.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/CategoryService.dart';
import 'package:reside_smart_flutter/Services/ListingDiscountService.dart';
import 'package:reside_smart_flutter/Services/ListingService.dart';

class HomeController extends GetxController {
  final ListingService _listingservice = Get.find<ListingService>();
  final CategoryService _categoryService = Get.find<CategoryService>();
  final ListingDiscountService _listingDiscountService =
      Get.find<ListingDiscountService>();

  List<ListingModel> nearbyEstates = [];
  List<ListingDiscountModel> discounts = [];
  List<Category> categories = [];
  final RxBool isNearbyEstatesLoading = false.obs;
  final RxBool isDiscountsLoading = false.obs;
  final RxBool isCategoriesLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;
  int selectedCategory = 0;

  final RxBool isTopLocationsLoading = false.obs;
  final RxList<dynamic> topLocations = <dynamic>[].obs;

  final RxBool isTopAgentsLoading = false.obs;
  final RxList<dynamic> topAgents = <dynamic>[].obs;

  Future<void> getTopAgents() async {
    if (isTopAgentsLoading.value) return;
    try {
      isTopAgentsLoading(true);
      final response = await _listingservice.getTopAgents();
      topAgents.assignAll(response);
      print('Top Agents Length: ${topAgents.length}');
    } catch (e) {
      _handleError(e);
    } finally {
      isTopAgentsLoading(false);
    }
  }

  Future<void> getTopLocations() async {
    if (isTopLocationsLoading.value) return;
    try {
      isTopLocationsLoading.value = true;
      final response = await _listingservice.getTopLocations();
      topLocations.assignAll(response);
      print('Top Locations Length: ${topLocations.length}');
    } catch (e) {
      _handleError(e);
    } finally {
      isTopLocationsLoading.value = false;
    }
  }

  Future<void> getNearbyEstates() async {
    if (isNearbyEstatesLoading.value) return;
    try {
      isNearbyEstatesLoading.value = true;
      final response = await _listingservice.getNearbyEstates();
      nearbyEstates = response;

      print('Nearby Estates Length: ${nearbyEstates.length}');
    } catch (e) {
    } finally {
      isNearbyEstatesLoading.value = false;
    }
  }

  Future<void> getAllDiscounts() async {
    if (isDiscountsLoading.value) return;
    try {
      isDiscountsLoading.value = true;

      discounts = await _listingDiscountService.getAllDiscounts();
    } catch (e) {
      rethrow;
    } finally {
      isDiscountsLoading.value = false;
    }
  }

  Future<void> getAllCategories() async {
    if (isCategoriesLoading.value) return;
    try {
      isCategoriesLoading.value = true;

      categories = await _categoryService.getCategories();
    } catch (e) {
      rethrow;
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  void _handleError(e) {
    if (e.response?.statusCode == 422) {
      final errors = e.response?.data['errors'] as Map<String, dynamic>;
      errors.forEach((key, value) {
        fieldErrors[key] = value[0];
      });
    } else {
      fieldErrors['general'] =
          e.response?.data['message'] ?? 'Something went wrong.';
    }
  }
}
