import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/AuthController.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Reside Smart',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}
// Image.asset(
//           'images/logo.png',
//           fit: BoxFit.contain,
//           height: MediaQuery.of(context).size.height * 0.4,
//         )