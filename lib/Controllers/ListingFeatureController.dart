import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeatureController extends GetxController {
  var features = <FeatureField>[].obs;

  void addFeature() {
    features.add(FeatureField());
  }

  void removeFeature(int index) {
    features.removeAt(index);
  }
}

class FeatureField {
  final TextEditingController feature = TextEditingController();
  final TextEditingController number = TextEditingController();
}
