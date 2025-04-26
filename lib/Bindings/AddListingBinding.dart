import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/AddListingController.dart';

class AddListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddListingController());
  }
}
