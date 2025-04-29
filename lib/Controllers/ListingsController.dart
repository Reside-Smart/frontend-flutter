import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/ListingService.dart';

class ListingsController extends GetxController {
  final ListingService listingService = Get.find<ListingService>();

  final RxBool isLoading = false.obs;
  final RxList<ListingModel> listings = <ListingModel>[].obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> fetchListings(String status) async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      fieldErrors.clear();

      final result = await listingService.getUserListings(status);
      listings.assignAll(result);
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(dynamic e) {
    if (e.response?.statusCode == 422) {
      final errors = e.response?.data['errors'] as Map<String, dynamic>;
      errors.forEach((key, value) {
        fieldErrors[key] = value[0];
      });
    } else {
      fieldErrors['general'] =
          e.response?.data['message'] ?? 'Failed to load listings';
    }
  }
}
