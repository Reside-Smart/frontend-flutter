import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:reside_smart_flutter/Services/TransactionService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class PurchaseListingController extends GetxController {
  final TransactionService transactionService = Get.find<TransactionService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> createTransaction({
    required String transactionType,
    required double totalPrice,
    required double amountPaid,
    required String paymentStatus,
    required String paymentMethod,
    String? checkInDate,
    String? checkOutDate,
    required int listingId,
    required int buyerId,
    required int sellerId,
    int? discountId,
    int? rentalOptionId,
    int quantity = 1, // Include quantity parameter with default
  }) async {
    try {
      isLoading.value = true;
      fieldErrors.clear();

      dio.FormData formData = dio.FormData.fromMap({
        'transaction_type': transactionType,
        'total_price': totalPrice,
        'amount_paid': amountPaid,
        'payment_status': paymentStatus,
        'payment_method': paymentMethod,
        if (checkInDate != null) 'check_in_date': checkInDate,
        if (checkOutDate != null) 'check_out_date': checkOutDate,
        'listing_id': listingId,
        'buyer_id': buyerId,
        'seller_id': sellerId,
        if (discountId != null) 'discount_id': discountId,
        if (rentalOptionId != null) 'rental_option_id': rentalOptionId,
        'quantity': quantity, // Include quantity in form data
      });

      await transactionService.purchaseListing(formData: formData);

      AppDialog.showSuccess('Transaction created successfully');
      Get.back();
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(e) {
    if (e is dio.DioError && e.response?.statusCode == 422) {
      final errors = e.response?.data['errors'] as Map<String, dynamic>;
      errors.forEach((key, value) {
        fieldErrors[key] = value[0];
      });
    } else {
      fieldErrors['general'] =
          (e is dio.DioError)
              ? e.response?.data['message'] ?? 'Something went wrong.'
              : 'Something went wrong.';
    }
  }
}
