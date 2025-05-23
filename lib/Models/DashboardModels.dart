class OverviewData {
  final ListingsStats? listingsStats;
  final TransactionStats? transactionStats;
  final FeedbackStats? feedbackStats;

  OverviewData({this.listingsStats, this.transactionStats, this.feedbackStats});

  factory OverviewData.fromJson(Map<String, dynamic> json) {
    return OverviewData(
      listingsStats:
          json['listings_stats'] != null
              ? ListingsStats.fromJson(json['listings_stats'])
              : null,
      transactionStats:
          json['transaction_stats'] != null
              ? TransactionStats.fromJson(json['transaction_stats'])
              : null,
      feedbackStats:
          json['feedback_stats'] != null
              ? FeedbackStats.fromJson(json['feedback_stats'])
              : null,
    );
  }
}

class ListingsStats {
  final int total;
  final int active;
  final int rent;
  final int sell;

  ListingsStats({
    required this.total,
    required this.active,
    required this.rent,
    required this.sell,
  });

  factory ListingsStats.fromJson(Map<String, dynamic> json) {
    return ListingsStats(
      total: json['total'] ?? 0,
      active: json['active'] ?? 0,
      rent: json['rent'] ?? 0,
      sell: json['sell'] ?? 0,
    );
  }
}

class TransactionStats {
  final int totalSales;
  final int pendingPayments;
  final double totalRevenue;
  final int totalPurchases;
  final double totalSpent;

  TransactionStats({
    required this.totalSales,
    required this.pendingPayments,
    required this.totalRevenue,
    required this.totalPurchases,
    required this.totalSpent,
  });

  factory TransactionStats.fromJson(Map<String, dynamic> json) {
    return TransactionStats(
      totalSales: json['total_sales'] ?? 0,
      pendingPayments: json['pending_payments'] ?? 0,
      totalRevenue: double.parse((json['total_revenue'] ?? 0).toString()),
      totalPurchases: json['total_purchases'] ?? 0,
      totalSpent: double.parse((json['total_spent'] ?? 0).toString()),
    );
  }
}

class FeedbackStats {
  final double averageRating;
  final int totalReviews;

  FeedbackStats({required this.averageRating, required this.totalReviews});

  factory FeedbackStats.fromJson(Map<String, dynamic> json) {
    return FeedbackStats(
      averageRating: double.parse((json['average_rating'] ?? 0).toString()),
      totalReviews: json['total_reviews'] ?? 0,
    );
  }
}

class RevenueData {
  final String timeframe;
  final RevenueChartData data;

  RevenueData({this.timeframe = '', this.data = const RevenueChartData()});

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      timeframe: json['timeframe'] ?? '',
      data:
          json['data'] != null
              ? RevenueChartData.fromJson(json['data'])
              : const RevenueChartData(),
    );
  }
}

class RevenueChartData {
  final List<String> labels;
  final List<double> values;

  const RevenueChartData({this.labels = const [], this.values = const []});

  factory RevenueChartData.fromJson(Map<String, dynamic> json) {
    return RevenueChartData(
      labels: List<String>.from(json['labels'] ?? []),
      values: List<double>.from(
        (json['values'] ?? []).map((v) => double.parse(v.toString())),
      ),
    );
  }
}

class ListingPerformanceData {
  final List<ListingPerformance> topPerformers;
  final PerformanceAverages averages;

  ListingPerformanceData({
    this.topPerformers = const [],
    this.averages = const PerformanceAverages(),
  });

  factory ListingPerformanceData.fromJson(Map<String, dynamic> json) {
    return ListingPerformanceData(
      topPerformers:
          json['top_performers'] != null
              ? List<ListingPerformance>.from(
                json['top_performers'].map(
                  (x) => ListingPerformance.fromJson(x),
                ),
              )
              : [],
      averages:
          json['averages'] != null
              ? PerformanceAverages.fromJson(json['averages'])
              : const PerformanceAverages(),
    );
  }
}

class ListingPerformance {
  final int id;
  final String name;
  final String type;
  final int transactionsCount;
  final int favoritesCount;
  final int reviewsCount;
  final double averageRating;
  final String createdAt;
  final double viewEfficiency;

  ListingPerformance({
    required this.id,
    required this.name,
    required this.type,
    required this.transactionsCount,
    required this.favoritesCount,
    required this.reviewsCount,
    required this.averageRating,
    required this.createdAt,
    required this.viewEfficiency,
  });

  factory ListingPerformance.fromJson(Map<String, dynamic> json) {
    return ListingPerformance(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      transactionsCount: json['transactions_count'] ?? 0,
      favoritesCount: json['favorites_count'] ?? 0,
      reviewsCount: json['reviews_count'] ?? 0,
      averageRating: double.parse((json['average_rating'] ?? 0).toString()),
      createdAt: json['created_at'] ?? '',
      viewEfficiency: double.parse((json['view_efficiency'] ?? 0).toString()),
    );
  }
}

class PerformanceAverages {
  final double transactions;
  final double favorites;
  final double rating;

  const PerformanceAverages({
    this.transactions = 0,
    this.favorites = 0,
    this.rating = 0,
  });

  factory PerformanceAverages.fromJson(Map<String, dynamic> json) {
    return PerformanceAverages(
      transactions: double.parse((json['transactions'] ?? 0).toString()),
      favorites: double.parse((json['favorites'] ?? 0).toString()),
      rating: double.parse((json['rating'] ?? 0).toString()),
    );
  }
}

class ActivityData {
  final String period;
  final SellerActivity? asSeller;
  final BuyerActivity? asBuyer;

  ActivityData({this.period = '', this.asSeller, this.asBuyer});

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      period: json['period'] ?? '',
      asSeller:
          json['as_seller'] != null
              ? SellerActivity.fromJson(json['as_seller'])
              : null,
      asBuyer:
          json['as_buyer'] != null
              ? BuyerActivity.fromJson(json['as_buyer'])
              : null,
    );
  }
}

class SellerActivity {
  final int sales;
  final int newListings;
  final int updatedListings;
  final int receivedReviews;

  SellerActivity({
    required this.sales,
    required this.newListings,
    required this.updatedListings,
    required this.receivedReviews,
  });

  factory SellerActivity.fromJson(Map<String, dynamic> json) {
    return SellerActivity(
      sales: json['sales'] ?? 0,
      newListings: json['new_listings'] ?? 0,
      updatedListings: json['updated_listings'] ?? 0,
      receivedReviews: json['received_reviews'] ?? 0,
    );
  }
}

class BuyerActivity {
  final int purchases;
  final int reviewsPosted;
  final int ratingsPosted;
  final int propertiesFavorited;

  BuyerActivity({
    required this.purchases,
    required this.reviewsPosted,
    required this.ratingsPosted,
    required this.propertiesFavorited,
  });

  factory BuyerActivity.fromJson(Map<String, dynamic> json) {
    return BuyerActivity(
      purchases: json['purchases'] ?? 0,
      reviewsPosted: json['reviews_posted'] ?? 0,
      ratingsPosted: json['ratings_posted'] ?? 0,
      propertiesFavorited: json['properties_favorited'] ?? 0,
    );
  }
}

class CategoryData {
  final List<CategoryCount> allListings;
  final List<CategoryCount> rentListings;
  final List<CategoryCount> sellListings;

  CategoryData({
    this.allListings = const [],
    this.rentListings = const [],
    this.sellListings = const [],
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      allListings:
          json['all_listings'] != null
              ? List<CategoryCount>.from(
                json['all_listings'].map((x) => CategoryCount.fromJson(x)),
              )
              : [],
      rentListings:
          json['rent_listings'] != null
              ? List<CategoryCount>.from(
                json['rent_listings'].map((x) => CategoryCount.fromJson(x)),
              )
              : [],
      sellListings:
          json['sell_listings'] != null
              ? List<CategoryCount>.from(
                json['sell_listings'].map((x) => CategoryCount.fromJson(x)),
              )
              : [],
    );
  }
}

class CategoryCount {
  final String category;
  final int count;

  CategoryCount({required this.category, required this.count});

  factory CategoryCount.fromJson(Map<String, dynamic> json) {
    return CategoryCount(
      category: json['category'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class TransactionAnalysisData {
  final Map<String, int> transactionTypes;
  final Map<String, int> paymentMethods;
  final Map<String, int> paymentStatuses;
  final Map<String, double> revenueByType;
  final Map<String, int> transactionsByDay;

  TransactionAnalysisData({
    this.transactionTypes = const {},
    this.paymentMethods = const {},
    this.paymentStatuses = const {},
    this.revenueByType = const {},
    this.transactionsByDay = const {},
  });

  factory TransactionAnalysisData.fromJson(Map<String, dynamic> json) {
    return TransactionAnalysisData(
      transactionTypes:
          json['transaction_types'] != null
              ? Map<String, int>.from(json['transaction_types'])
              : {},
      paymentMethods:
          json['payment_methods'] != null
              ? Map<String, int>.from(json['payment_methods'])
              : {},
      paymentStatuses:
          json['payment_statuses'] != null
              ? Map<String, int>.from(json['payment_statuses'])
              : {},
      revenueByType:
          json['revenue_by_type'] != null
              ? Map<String, double>.from(
                json['revenue_by_type'].map(
                  (k, v) => MapEntry(k, double.parse(v.toString())),
                ),
              )
              : {},
      transactionsByDay:
          json['transactions_by_day'] != null
              ? Map<String, int>.from(json['transactions_by_day'])
              : {},
    );
  }
}

class SpendingAnalysisData {
  final SpendingChartData monthlySpending;
  final Map<String, double> spendingByType;
  final Map<String, double> spendingByCategory;

  SpendingAnalysisData({
    this.monthlySpending = const SpendingChartData(),
    this.spendingByType = const {},
    this.spendingByCategory = const {},
  });

  factory SpendingAnalysisData.fromJson(Map<String, dynamic> json) {
    return SpendingAnalysisData(
      monthlySpending:
          json['monthly_spending'] != null
              ? SpendingChartData.fromJson(json['monthly_spending'])
              : const SpendingChartData(),
      spendingByType:
          json['spending_by_type'] != null
              ? Map<String, double>.from(
                json['spending_by_type'].map(
                  (k, v) => MapEntry(k, double.parse(v.toString())),
                ),
              )
              : {},
      spendingByCategory:
          json['spending_by_category'] != null
              ? Map<String, double>.from(
                json['spending_by_category'].map(
                  (k, v) => MapEntry(k, double.parse(v.toString())),
                ),
              )
              : {},
    );
  }
}

class SpendingChartData {
  final List<String> labels;
  final List<double> values;

  const SpendingChartData({this.labels = const [], this.values = const []});

  factory SpendingChartData.fromJson(Map<String, dynamic> json) {
    return SpendingChartData(
      labels: List<String>.from(json['labels'] ?? []),
      values: List<double>.from(
        (json['values'] ?? []).map((v) => double.parse(v.toString())),
      ),
    );
  }
}

class ReviewAnalysisData {
  final Map<String, int> ratingDistribution;
  final Map<String, MonthlyRatingData> monthlyRatings;
  final List<ReviewSummary> recentReviews;

  ReviewAnalysisData({
    this.ratingDistribution = const {},
    this.monthlyRatings = const {},
    this.recentReviews = const [],
  });

  factory ReviewAnalysisData.fromJson(Map<String, dynamic> json) {
    // Parse rating distribution
    Map<String, int> ratingDist = {};
    if (json['rating_distribution'] != null) {
      json['rating_distribution'].forEach((key, value) {
        ratingDist[key.toString()] = int.parse(value.toString());
      });
    }

    // Parse monthly ratings
    Map<String, MonthlyRatingData> monthlyRatings = {};
    if (json['monthly_ratings'] != null) {
      json['monthly_ratings'].forEach((key, value) {
        monthlyRatings[key.toString()] = MonthlyRatingData.fromJson(value);
      });
    }

    return ReviewAnalysisData(
      ratingDistribution: ratingDist,
      monthlyRatings: monthlyRatings,
      recentReviews:
          json['recent_reviews'] != null
              ? List<ReviewSummary>.from(
                json['recent_reviews'].map((x) => ReviewSummary.fromJson(x)),
              )
              : [],
    );
  }
}

class MonthlyRatingData {
  final double avgRating;
  final int count;

  MonthlyRatingData({required this.avgRating, required this.count});

  factory MonthlyRatingData.fromJson(Map<String, dynamic> json) {
    return MonthlyRatingData(
      avgRating: double.parse((json['avg_rating'] ?? 0).toString()),
      count: json['count'] ?? 0,
    );
  }
}

class ReviewSummary {
  final int id;
  final int userId;
  final String userName;
  final String userImage;
  final String text;
  final double rating;
  final String createdAt;
  final String listingName;

  ReviewSummary({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.text,
    required this.rating,
    required this.createdAt,
    required this.listingName,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
      text: json['text'] ?? '',
      rating: double.parse((json['rating'] ?? 0).toString()),
      createdAt: json['created_at'] ?? '',
      listingName: json['listing_name'] ?? '',
    );
  }
}

class MarketAnalysisData {
  final Map<String, int> categoryPopularity;
  final Map<String, double> avgPriceByCategory;
  final Map<String, int> listingsByLocation;
  final Map<String, double> priceRangeDistribution;

  MarketAnalysisData({
    this.categoryPopularity = const {},
    this.avgPriceByCategory = const {},
    this.listingsByLocation = const {},
    this.priceRangeDistribution = const {},
  });

  factory MarketAnalysisData.fromJson(Map<String, dynamic> json) {
    return MarketAnalysisData(
      categoryPopularity:
          json['category_popularity'] != null
              ? Map<String, int>.from(json['category_popularity'])
              : {},
      avgPriceByCategory:
          json['avg_price_by_category'] != null
              ? Map<String, double>.from(
                json['avg_price_by_category'].map(
                  (k, v) => MapEntry(k, double.parse(v.toString())),
                ),
              )
              : {},
      listingsByLocation:
          json['listings_by_location'] != null
              ? Map<String, int>.from(json['listings_by_location'])
              : {},
      priceRangeDistribution:
          json['price_range_distribution'] != null
              ? Map<String, double>.from(
                json['price_range_distribution'].map(
                  (k, v) => MapEntry(k, double.parse(v.toString())),
                ),
              )
              : {},
    );
  }
}

class RentalListing {
  final int id;
  final String name;
  final int bookingsCount;
  final double averageStayDuration;
  final double occupancyRate;
  final double revenue;

  RentalListing({
    required this.id,
    required this.name,
    required this.bookingsCount,
    required this.averageStayDuration,
    required this.occupancyRate,
    required this.revenue,
  });

  factory RentalListing.fromJson(Map<String, dynamic> json) {
    return RentalListing(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      bookingsCount: json['bookings_count'] ?? 0,
      averageStayDuration: double.parse(
        (json['average_stay_duration'] ?? 0).toString(),
      ),
      occupancyRate: double.parse((json['occupancy_rate'] ?? 0).toString()),
      revenue: double.parse((json['revenue'] ?? 0).toString()),
    );
  }
}

class RentalAverages {
  final double bookingsPerProperty;
  final double stayDuration;
  final double occupancyRate;
  final double revenuePerBooking;

  const RentalAverages({
    this.bookingsPerProperty = 0,
    this.stayDuration = 0,
    this.occupancyRate = 0,
    this.revenuePerBooking = 0,
  });

  factory RentalAverages.fromJson(Map<String, dynamic> json) {
    return RentalAverages(
      bookingsPerProperty: double.parse(
        (json['bookings_per_property'] ?? 0).toString(),
      ),
      stayDuration: double.parse((json['stay_duration'] ?? 0).toString()),
      occupancyRate: double.parse((json['occupancy_rate'] ?? 0).toString()),
      revenuePerBooking: double.parse(
        (json['revenue_per_booking'] ?? 0).toString(),
      ),
    );
  }
}

class DiscountSummary {
  final int id;
  final String name;
  final double percentage;
  final int usageCount;
  final double revenueGenerated;
  final String status;
  final String startDate;
  final String endDate;

  DiscountSummary({
    required this.id,
    required this.name,
    required this.percentage,
    required this.usageCount,
    required this.revenueGenerated,
    required this.status,
    required this.startDate,
    required this.endDate,
  });

  factory DiscountSummary.fromJson(Map<String, dynamic> json) {
    return DiscountSummary(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      percentage: double.parse((json['percentage'] ?? 0).toString()),
      usageCount: json['usage_count'] ?? 0,
      revenueGenerated: double.parse(
        (json['revenue_generated'] ?? 0).toString(),
      ),
      status: json['status'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }
}

class DiscountMetrics {
  final double averageDiscount;
  final double totalSavingsProvided;
  final double conversionRate;
  final double additionalRevenueGenerated;

  const DiscountMetrics({
    this.averageDiscount = 0,
    this.totalSavingsProvided = 0,
    this.conversionRate = 0,
    this.additionalRevenueGenerated = 0,
  });

  factory DiscountMetrics.fromJson(Map<String, dynamic> json) {
    return DiscountMetrics(
      averageDiscount: double.parse((json['average_discount'] ?? 0).toString()),
      totalSavingsProvided: double.parse(
        (json['total_savings_provided'] ?? 0).toString(),
      ),
      conversionRate: double.parse((json['conversion_rate'] ?? 0).toString()),
      additionalRevenueGenerated: double.parse(
        (json['additional_revenue_generated'] ?? 0).toString(),
      ),
    );
  }
}

class DiscountPerformanceData {
  final DiscountStats discountStats;
  final RevenueComparison revenueComparison;
  final List<DiscountSummary> activeDiscounts;
  final Map<String, int> usageCounts;

  DiscountPerformanceData({
    this.discountStats = const DiscountStats(),
    this.revenueComparison = const RevenueComparison(),
    this.activeDiscounts = const [],
    this.usageCounts = const {},
  });

  factory DiscountPerformanceData.fromJson(Map<String, dynamic> json) {
    return DiscountPerformanceData(
      discountStats:
          json['discount_stats'] != null
              ? DiscountStats.fromJson(json['discount_stats'])
              : const DiscountStats(),
      revenueComparison:
          json['revenue_comparison'] != null
              ? RevenueComparison.fromJson(json['revenue_comparison'])
              : const RevenueComparison(),
      activeDiscounts:
          json['active_discounts'] != null
              ? List<DiscountSummary>.from(
                json['active_discounts'].map(
                  (x) => DiscountSummary.fromJson(x),
                ),
              )
              : [],
      usageCounts:
          json['usage_counts'] != null
              ? Map<String, int>.from(json['usage_counts'])
              : {},
    );
  }
}

class DiscountStats {
  final int active;
  final int inactive;
  final int expired;

  const DiscountStats({this.active = 0, this.inactive = 0, this.expired = 0});

  factory DiscountStats.fromJson(Map<String, dynamic> json) {
    return DiscountStats(
      active: json['active'] ?? 0,
      inactive: json['inactive'] ?? 0,
      expired: json['expired'] ?? 0,
    );
  }
}

class RevenueComparison {
  final double withDiscount;
  final double withoutDiscount;

  const RevenueComparison({
    this.withDiscount = 0.0,
    this.withoutDiscount = 0.0,
  });

  factory RevenueComparison.fromJson(Map<String, dynamic> json) {
    return RevenueComparison(
      withDiscount: double.parse((json['with_discount'] ?? 0).toString()),
      withoutDiscount: double.parse((json['without_discount'] ?? 0).toString()),
    );
  }
}

class RentalPerformanceData {
  final List<RentalListing> topRentals;
  final RentalAverages averages;
  final Map<String, int> rentalUnitPopularity;
  final Map<String, double> monthlyOccupancyRate;
  final Map<String, double> avgRevenueByDuration;

  RentalPerformanceData({
    this.topRentals = const [],
    this.averages = const RentalAverages(),
    this.rentalUnitPopularity = const {},
    this.monthlyOccupancyRate = const {},
    this.avgRevenueByDuration = const {},
  });

  factory RentalPerformanceData.fromJson(Map<String, dynamic> json) {
    return RentalPerformanceData(
      topRentals:
          json['top_rentals'] != null
              ? List<RentalListing>.from(
                json['top_rentals'].map((x) => RentalListing.fromJson(x)),
              )
              : [],
      averages:
          json['averages'] != null
              ? RentalAverages.fromJson(json['averages'])
              : const RentalAverages(),
      rentalUnitPopularity:
          json['rental_unit_popularity'] != null
              ? Map<String, int>.from(json['rental_unit_popularity'])
              : {},
      monthlyOccupancyRate:
          json['monthly_occupancy_rate'] != null
              ? Map<String, double>.from(
                json['monthly_occupancy_rate'].map(
                  (k, v) => MapEntry(k, double.parse(v.toString())),
                ),
              )
              : {},
      avgRevenueByDuration:
          json['avg_revenue_by_duration'] != null
              ? Map<String, double>.from(
                json['avg_revenue_by_duration'].map(
                  (k, v) => MapEntry(k, double.parse(v.toString())),
                ),
              )
              : {},
    );
  }
}
