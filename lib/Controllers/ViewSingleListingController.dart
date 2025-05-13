import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/ListingService.dart';

class ViewSingleListingController extends GetxController {
  final ListingService listingService = Get.find<ListingService>();

  final RxBool isLoading = false.obs;
  final Rxn<ListingModel> listing = Rxn<ListingModel>();
  var fieldErrors = <String, String>{}.obs;

  Future<void> getSingleListing(int id) async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      fieldErrors.clear();

      final result = await listingService.getSingleListing(id);
      listing.value = result;
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
