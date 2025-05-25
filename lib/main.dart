import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:reside_smart_flutter/Bindings/GlobalBinding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Utils/Theme.dart';
import 'Routes/AppRoutes.dart';

void main() async {
  await GetStorage.init();
  const String envFile = String.fromEnvironment('ENV', defaultValue: '.env');
  await dotenv.load(fileName: envFile);

  Api.initializeInterceptors();

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stripe
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  // Stripe.merchantIdentifier = 'merchant.com.residesmart'; // For Apple Pay
  await Stripe.instance.applySettings();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      transitionDuration: const Duration(milliseconds: 300),
      initialBinding: GlobalBinding(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
