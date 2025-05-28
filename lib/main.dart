import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:reside_smart_flutter/Bindings/GlobalBinding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Services/FirebaseService.dart';
import 'package:reside_smart_flutter/Services/NotificationApiService.dart';
import 'package:reside_smart_flutter/Utils/Theme.dart';
import 'Routes/AppRoutes.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  await GetStorage.init();
  Get.put(GetStorage(), permanent: true);

  // Load environment variables
  const String envFile = String.fromEnvironment('ENV', defaultValue: '.env');
  await dotenv.load(fileName: envFile);

  // Initialize API interceptors
  Api.initializeInterceptors();

  // Initialize Stripe
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  await Stripe.instance.applySettings();

  // Initialize Firebase first
  await Firebase.initializeApp();

  // FCM initialization with retry logic
  int retries = 0;
  while (retries < 3) {
    try {
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      break; // Success, exit the loop
    } catch (e) {
      retries++;
      print('FCM initialization attempt $retries failed: $e');
      await Future.delayed(Duration(seconds: 2 * retries));
      if (retries == 3) {
        print('FCM initialization failed after 3 attempts');
      }
    }
  }

  // Create services in the right order
  Get.put(NotificationApiService(), permanent: true);
  Get.put(FirebaseService(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GlobalBinding(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
