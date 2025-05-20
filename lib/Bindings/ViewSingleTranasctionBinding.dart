import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/ViewSingleTransactionController.dart';

class ViewSingleTranasctionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewSingleTransactionController());
  }
}
