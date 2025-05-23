import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/TransactionsController.dart';

class TransactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionsController());
  }
}
