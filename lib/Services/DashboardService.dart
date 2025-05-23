import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Models/DashboardModels.dart';

class DashboardService extends GetxController {
  final RxBool isLoading = true.obs;

  // Dashboard data
  final Rx<OverviewData> overview = OverviewData().obs;
  final Rx<RevenueData> revenueData = RevenueData().obs;
  final Rx<ListingPerformanceData> listingPerformance =
      ListingPerformanceData().obs;
  final Rx<ActivityData> activity = ActivityData().obs;
  final Rx<CategoryData> categories = CategoryData().obs;
  final Rx<TransactionAnalysisData> transactions =
      TransactionAnalysisData().obs;
  final Rx<SpendingAnalysisData> spending = SpendingAnalysisData().obs;
  final Rx<RentalPerformanceData> rentalPerformance =
      RentalPerformanceData().obs;
  final Rx<ReviewAnalysisData> reviews = ReviewAnalysisData().obs;
  final Rx<DiscountPerformanceData> discounts = DiscountPerformanceData().obs;

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      // Fetch all dashboard data in parallel
      await Future.wait([
        fetchOverview(),
        fetchRevenueOverTime('month'),
        fetchListingPerformance(),
        fetchActivityBreakdown(),
        fetchCategoryDistribution(),
        fetchTransactionAnalysis(),
        fetchSpendingAnalysis(),
        fetchRentalPerformance(),
        fetchReviewAnalytics(),
        fetchDiscountPerformance(),
      ]);
    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOverview() async {
    try {
      final response = await Api.dio.get('/dashboard/overview');
      overview.value = OverviewData.fromJson(response.data);
    } catch (e) {
      print('Error fetching overview: $e');
    }
  }

  Future<void> fetchRevenueOverTime(String timeframe) async {
    try {
      final response = await Api.dio.get(
        '/dashboard/revenue?timeframe=$timeframe',
      );
      revenueData.value = RevenueData.fromJson(response.data);
    } catch (e) {
      print('Error fetching revenue: $e');
    }
  }

  Future<void> fetchListingPerformance() async {
    try {
      final response = await Api.dio.get('/dashboard/listing-performance');
      listingPerformance.value = ListingPerformanceData.fromJson(response.data);
    } catch (e) {
      print('Error fetching listing performance: $e');
    }
  }

  Future<void> fetchActivityBreakdown() async {
    try {
      final response = await Api.dio.get('/dashboard/activity');
      activity.value = ActivityData.fromJson(response.data);
    } catch (e) {
      print('Error fetching activity: $e');
    }
  }

  Future<void> fetchCategoryDistribution() async {
    try {
      final response = await Api.dio.get('/dashboard/categories');
      categories.value = CategoryData.fromJson(response.data);
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchTransactionAnalysis() async {
    try {
      final response = await Api.dio.get('/dashboard/transactions');
      transactions.value = TransactionAnalysisData.fromJson(response.data);
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  Future<void> fetchSpendingAnalysis() async {
    try {
      final response = await Api.dio.get('/dashboard/spending');
      spending.value = SpendingAnalysisData.fromJson(response.data);
    } catch (e) {
      print('Error fetching spending: $e');
    }
  }

  Future<void> fetchRentalPerformance() async {
    try {
      final response = await Api.dio.get('/dashboard/rental-analytics');
      rentalPerformance.value = RentalPerformanceData.fromJson(response.data);
    } catch (e) {
      print('Error fetching rental performance: $e');
    }
  }

  Future<void> fetchReviewAnalytics() async {
    try {
      final response = await Api.dio.get('/dashboard/reviews');
      reviews.value = ReviewAnalysisData.fromJson(response.data);
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  Future<void> fetchDiscountPerformance() async {
    try {
      final response = await Api.dio.get('/dashboard/discounts');
      discounts.value = DiscountPerformanceData.fromJson(response.data);
    } catch (e) {
      print('Error fetching discounts: $e');
    }
  }
}
