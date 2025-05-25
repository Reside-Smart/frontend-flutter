import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Services/TransactionService.dart';
import 'package:reside_smart_flutter/Services/StripeService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class PurchaseListingController extends GetxController {
  final TransactionService transactionService = Get.find<TransactionService>();
  final StripeService stripeService = Get.find<StripeService>();
  final AuthService authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  // Process the payment directly with Stripe
  Future<void> processDirectPayment({
    required String productName,
    required double amount,
    required int listingId,
    required int sellerId,
    String transactionType = 'purchase',
    int? rentalOptionId,
    int? discountId,
    int quantity = 1,
    String? checkInDate,
    String? checkOutDate,
  }) async {
    try {
      isLoading.value = true;

      final String email = authService.globalUser!.email;
      final int buyerId = authService.globalUser!.id;

      // Make the payment directly with Stripe
      final paymentResult = await stripeService.makePayment(
        productName: productName,
        amount: amount,
        currency: 'usd',
        email: email,
      );

      if (paymentResult.status == PaymentStatus.success) {
        // Create a transaction record in your backend
        dio.FormData formData = dio.FormData.fromMap({
          'transaction_type': transactionType,
          'total_price': amount,
          'amount_paid': amount,
          'payment_status': 'paid',
          'payment_method': 'stripe',
          'payment_intent_id': paymentResult.paymentIntentId,
          if (checkInDate != null) 'check_in_date': checkInDate,
          if (checkOutDate != null) 'check_out_date': checkOutDate,
          'listing_id': listingId,
          'buyer_id': buyerId,
          'seller_id': sellerId,
          if (discountId != null) 'discount_id': discountId,
          if (rentalOptionId != null) 'rental_option_id': rentalOptionId,
          'quantity': quantity,
        });

        await transactionService.purchaseListing(formData: formData);

        AppDialog.showSuccess('Payment successful');
        Get.toNamed('/transactions');
      } else {
        AppDialog.showError(paymentResult.message);
      }
    } catch (e) {
      AppDialog.showError('Payment failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Original cash payment method (keep this)
  Future<void> createCashTransaction({
    required String transactionType,
    required double totalPrice,
    required double amountPaid,
    required int listingId,
    required int buyerId,
    required int sellerId,
    int? discountId,
    int? rentalOptionId,
    int quantity = 1,
    String? checkInDate,
    String? checkOutDate,
  }) async {
    try {
      isLoading.value = true;
      fieldErrors.clear();

      dio.FormData formData = dio.FormData.fromMap({
        'transaction_type': transactionType,
        'total_price': totalPrice,
        'amount_paid': amountPaid,
        'payment_status': 'unpaid',
        'payment_method': 'cash',
        if (checkInDate != null) 'check_in_date': checkInDate,
        if (checkOutDate != null) 'check_out_date': checkOutDate,
        'listing_id': listingId,
        'buyer_id': buyerId,
        'seller_id': sellerId,
        if (discountId != null) 'discount_id': discountId,
        if (rentalOptionId != null) 'rental_option_id': rentalOptionId,
        'quantity': quantity,
      });

      await transactionService.purchaseListing(formData: formData);

      AppDialog.showSuccess('Transaction created successfully');
      Get.offAllNamed('/transactions');
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(dynamic e) {
    // Your existing error handling code
  }
}
