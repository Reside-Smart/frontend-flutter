import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:reside_smart_flutter/Models/TransactionModel.dart';
import 'package:reside_smart_flutter/Services/TransactionService.dart';

class TransactionsController extends GetxController {
  final TransactionService transactionService = Get.find<TransactionService>();
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> fetchTransactions() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      fieldErrors.clear();

      final result = await transactionService.getUserTransactions();
      transactions.assignAll(result);
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
