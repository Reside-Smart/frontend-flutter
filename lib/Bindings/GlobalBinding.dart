import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/AnalyticsService.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Services/CategoryService.dart';
import 'package:reside_smart_flutter/Services/FavoriteService.dart';
import 'package:reside_smart_flutter/Services/ListingDiscountService.dart';
import 'package:reside_smart_flutter/Services/ListingService.dart';
import 'package:reside_smart_flutter/Services/ReviewService.dart';
import 'package:reside_smart_flutter/Services/StripeService.dart';
import 'package:reside_smart_flutter/Services/TransactionService.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    // Get.put(BottomNavController(), permanent: true);
    Get.put(ListingService(), permanent: true);
    Get.put(ListingDiscountService(), permanent: true);
    Get.put(CategoryService(), permanent: true);
    Get.put(FavoriteService(), permanent: true);
    Get.put(TransactionService(), permanent: true);
    Get.put(ReviewsService(), permanent: true);
    Get.put(AnalyticsService(), permanent: true);
    Get.put(StripeService(), permanent: true);
  }
}
