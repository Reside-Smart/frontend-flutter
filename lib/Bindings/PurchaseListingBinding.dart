import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/PurchaseListingController.dart';

class PurchaseListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseListingController());
  }
}
