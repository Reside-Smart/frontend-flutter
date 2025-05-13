import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/ViewSingleListingController.dart';

class Viewsinglelistingbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewSingleListingController());
  }
}
