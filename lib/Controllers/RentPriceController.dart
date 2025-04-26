import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RentingOption {
  final TextEditingController duration = TextEditingController();
  final RxString unit = ''.obs;
  final TextEditingController price = TextEditingController();
}

class RentingOptionController extends GetxController {
  var rentOptions = <RentingOption>[].obs;

  void addOption() {
    rentOptions.add(RentingOption());
  }

  void removeOption(int index) {
    rentOptions.removeAt(index);
  }
}
