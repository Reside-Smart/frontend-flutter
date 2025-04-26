import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/UpdateListingController.dart';

class Updatelistingbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateListingController());
  }
}
