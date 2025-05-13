import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Services/ListingDiscountService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:http_parser/http_parser.dart';

class AddDiscountController extends GetxController {
  final ListingDiscountService listinDiscountService =
      Get.find<ListingDiscountService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> addDiscount({
    required String name,
    required double percentage,
    required String startDate,
    required String endDate,

    int? listingId,
    int? rentalOptionId,
  }) async {
    try {
      isLoading.value = true;
      fieldErrors.clear();

      dio.FormData formData = dio.FormData.fromMap({
        'name': name,
        'percentage': percentage,
        'start_date': startDate,
        'end_date': endDate,
        if (listingId != null) 'listing_id': listingId,
        if (rentalOptionId != null) 'rental_option_id': rentalOptionId,
      });
      await listinDiscountService.addDiscount(formData: formData);
      print('controller: ${formData.fields}');

      AppDialog.showSuccess('Discount added successfully');
      Get.back();
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
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
