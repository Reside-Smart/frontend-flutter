import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RentingOption {
  int? id;
  final TextEditingController duration = TextEditingController();
  final RxString unit = ''.obs;
  final TextEditingController price = TextEditingController();
  final RxBool isCancelled = true.obs;
}

class RentingOptionController extends GetxController {
  var rentOptions = <RentingOption>[].obs;

  // void addOption() {
  //   rentOptions.add(RentingOption());
  // }
  void addOption() {
    RentingOption newOption =
        RentingOption()
          ..duration.clear()
          ..unit.value = ''
          ..price.clear();

    rentOptions.add(newOption);
  }

  void removeOption(int index) {
    rentOptions.removeAt(index);
  }
}
