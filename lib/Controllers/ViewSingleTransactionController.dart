import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/TransactionModel.dart';
import 'package:reside_smart_flutter/Services/TransactionService.dart';

class ViewSingleTransactionController extends GetxController {
  final TransactionService transactionService = Get.find<TransactionService>();

  final RxBool isLoading = false.obs;
  final Rxn<TransactionModel> transaction = Rxn<TransactionModel>();
  var fieldErrors = <String, String>{}.obs;

  Future<void> getSingleTransaction(int id) async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      fieldErrors.clear();

      final result = await transactionService.getSingleTransaction(id);
      transaction.value = result;
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
          e.response?.data['message'] ?? 'Failed to load transaction';
    }
  }
}
