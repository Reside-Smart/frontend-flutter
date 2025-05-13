import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/ListingDiscountModel.dart';
import 'package:reside_smart_flutter/Services/ListingDiscountService.dart';

class DiscountController extends GetxController {
  final ListingDiscountService discountService =
      Get.find<ListingDiscountService>();

  final RxBool isLoading = false.obs;
  final RxList<ListingDiscountModel> listingDiscount =
      <ListingDiscountModel>[].obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> fetchDiscount(String status) async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      fieldErrors.clear();

      final result = await discountService.getUserDiscounts(status);
      listingDiscount.assignAll(result);
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
