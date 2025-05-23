import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:reside_smart_flutter/Services/DashboardService.dart';
import 'package:reside_smart_flutter/Models/DashboardModels.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  final DashboardService dashboardService = Get.put(DashboardService());

  // Tab controller
  late TabController _tabController;

  // Timeframe for revenue chart
  String _revenueTimeframe = 'month';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    dashboardService.fetchDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyMainAppBar(title: 'Dashboard'),
      body: Obx(() {
        if (dashboardService.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Container(
              // color: Theme.of(context).primaryColor,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Listings'),
                  Tab(text: 'Sales'),
                  Tab(text: 'Rentals'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildListingsTab(),
                  _buildSalesTab(),
                  _buildRentalsTab(),
                  _buildPerformanceTab(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildOverviewTab() {
    final overview = dashboardService.overview.value;
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Properties',
                  overview.listingsStats?.total.toString() ?? '0',
                  Icons.home,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  'Revenue',
                  currencyFormat.format(
                    overview.transactionStats?.totalRevenue ?? 0,
                  ),
                  Icons.attach_money,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Sales',
                  overview.transactionStats?.totalSales.toString() ?? '0',
                  Icons.shopping_cart,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  'Rating',
                  '${overview.feedbackStats?.averageRating ?? 0} ★',
                  Icons.star,
                  Colors.amber,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('Revenue Over Time'),

          // Revenue timeframe selector
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeframeChip('Week', 'week'),
                const SizedBox(width: 8),
                _buildTimeframeChip('Month', 'month'),
                const SizedBox(width: 8),
                _buildTimeframeChip('Year', 'year'),
              ],
            ),
          ),

          // Revenue chart
          Obx(() {
            if (dashboardService.revenueData.value.timeframe.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No revenue data available'),
                ),
              );
            }

            return SizedBox(height: 250, child: _buildRevenueChart());
          }),

          const SizedBox(height: 24),
          _buildSectionTitle('Recent Activity'),

          // Activity stats
          Obx(() {
            final activity = dashboardService.activity.value;
            return Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.add_home, color: Colors.white),
                  ),
                  title: Text(
                    '${activity.asSeller?.newListings ?? 0} new listings',
                  ),
                  subtitle: const Text('Last 30 days'),
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.shopping_bag, color: Colors.white),
                  ),
                  title: Text('${activity.asSeller?.sales ?? 0} sales'),
                  subtitle: const Text('Last 30 days'),
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.rate_review, color: Colors.white),
                  ),
                  title: Text(
                    '${activity.asSeller?.receivedReviews ?? 0} reviews received',
                  ),
                  subtitle: const Text('Last 30 days'),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildListingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Your Listings'),

          // Listing type breakdown
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'For Rent',
                  dashboardService.overview.value.listingsStats?.rent
                          .toString() ??
                      '0',
                  Icons.home,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  'For Sale',
                  dashboardService.overview.value.listingsStats?.sell
                          .toString() ??
                      '0',
                  Icons.sell,
                  Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('Category Distribution'),

          // Category distribution chart
          Obx(() {
            final categories = dashboardService.categories.value;
            if (categories.allListings.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No category data available'),
                ),
              );
            }

            return SizedBox(height: 250, child: _buildCategoryPieChart());
          }),

          const SizedBox(height: 24),
          _buildSectionTitle('Top Performing Listings'),

          // Top listings
          Obx(() {
            final performance = dashboardService.listingPerformance.value;
            if (performance.topPerformers.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No listing performance data available'),
                ),
              );
            }

            return Column(
              children:
                  performance.topPerformers.map((listing) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(listing.name),
                        subtitle: Text('Type: ${listing.type}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${listing.transactionsCount} sales'),
                            Text('${listing.averageRating} ★'),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSalesTab() {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Transaction Analysis'),

          // Transaction stats
          Obx(() {
            final transactions = dashboardService.transactions.value;

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Revenue',
                        currencyFormat.format(
                          dashboardService
                                  .overview
                                  .value
                                  .transactionStats
                                  ?.totalRevenue ??
                              0,
                        ),
                        Icons.monetization_on,
                        Colors.green,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        'Pending',
                        dashboardService
                                .overview
                                .value
                                .transactionStats
                                ?.pendingPayments
                                .toString() ??
                            '0',
                        Icons.pending,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),

          const SizedBox(height: 24),
          _buildSectionTitle('Discount Performance'),

          // Discount stats
          Obx(() {
            final discounts = dashboardService.discounts.value;
            if (discounts.discountStats.active == 0 &&
                discounts.discountStats.inactive == 0 &&
                discounts.discountStats.expired == 0) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No discount data available'),
                ),
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Active',
                        discounts.discountStats.active.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        'Inactive',
                        discounts.discountStats.inactive.toString(),
                        Icons.cancel,
                        Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        'Expired',
                        discounts.discountStats.expired.toString(),
                        Icons.timer_off,
                        Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Revenue Comparison',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildRevenueComparisonItem(
                                'With Discount',
                                discounts.revenueComparison.withDiscount,
                                Colors.blue,
                              ),
                            ),
                            Expanded(
                              child: _buildRevenueComparisonItem(
                                'Without Discount',
                                discounts.revenueComparison.withoutDiscount,
                                Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRentalsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildSectionTitle('Average Revenue by Duration'),

          // Revenue by duration
          Obx(() {
            final rentalData = dashboardService.rentalPerformance.value;
            final currencyFormat = NumberFormat.currency(symbol: '\$');

            if (rentalData.avgRevenueByDuration.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No revenue by duration data available'),
                ),
              );
            }

            return Column(
              children:
                  rentalData.avgRevenueByDuration.entries.map((entry) {
                    return ListTile(
                      title: Text('Per ${entry.key}'),
                      trailing: Text(
                        currencyFormat.format(entry.value),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Review Analytics'),

          // Rating distribution chart
          Obx(() {
            final reviewData = dashboardService.reviews.value;
            if (reviewData.ratingDistribution.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No review data available'),
                ),
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Avg Rating',
                        '${dashboardService.overview.value.feedbackStats?.averageRating ?? 0} ★',
                        Icons.star,
                        Colors.amber,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        'Reviews',
                        dashboardService
                                .overview
                                .value
                                .feedbackStats
                                ?.totalReviews
                                .toString() ??
                            '0',
                        Icons.rate_review,
                        Colors.indigo,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Text(
                  'Rating Distribution',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 200, child: _buildRatingDistributionChart()),
              ],
            );
          }),

          const SizedBox(height: 24),
          _buildSectionTitle('Recent Reviews'),

          // Recent reviews
          Obx(() {
            final reviewData = dashboardService.reviews.value;
            if (reviewData.recentReviews.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No recent reviews available'),
                ),
              );
            }

            return Column(
              children:
                  reviewData.recentReviews.map((review) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              review.userImage != null &&
                                      review.userImage.isNotEmpty
                                  ? NetworkImage(review.userImage)
                                  : null,
                          child:
                              review.userImage == null ||
                                      review.userImage.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                        ),
                        title: Text(review.userName),
                        subtitle: Text(
                          review.text.length > 60
                              ? '${review.text.substring(0, 60)}...'
                              : review.text,
                        ),
                        trailing: Text(review.createdAt),
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTimeframeChip(String label, String timeframe) {
    final isSelected = _revenueTimeframe == timeframe;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _revenueTimeframe = timeframe);
          dashboardService.fetchRevenueOverTime(timeframe);
        }
      },
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }

  Widget _buildRevenueChart() {
    final revenueData = dashboardService.revenueData.value;
    if (revenueData.data.labels.isEmpty) {
      return const Center(child: Text('No revenue data available'));
    }

    final spots = List.generate(
      revenueData.data.labels.length,
      (index) =>
          FlSpot(index.toDouble(), revenueData.data.values[index].toDouble()),
    );

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const Text('');
                return Text('\$${value.toInt()}');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= revenueData.data.labels.length ||
                    value % 5 != 0) {
                  return const Text('');
                }

                final label = revenueData.data.labels[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _revenueTimeframe == 'year'
                        ? label.substring(5) // Show only MM for year view
                        : label.substring(5), // Show MM-DD for month/week view
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPieChart() {
    final categoryData = dashboardService.categories.value;
    if (categoryData.allListings.isEmpty) {
      return const Center(child: Text('No category data available'));
    }

    final categories = <String>[];
    final counts = <double>[];
    final colors = <Color>[
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
    ];

    for (int i = 0; i < categoryData.allListings.length; i++) {
      categories.add(categoryData.allListings[i].category);
      counts.add(categoryData.allListings[i].count.toDouble());
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: List.generate(categories.length, (i) {
          final percentage = counts[i] / counts.reduce((a, b) => a + b) * 100;
          return PieChartSectionData(
            color: colors[i % colors.length],
            value: counts[i],
            title:
                '${percentage.toStringAsFixed(0)}% ${categoryData.allListings[i].category}',
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRevenueComparisonItem(String title, double value, Color color) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.attach_money, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          currencyFormat.format(value),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildRentalPopularityChart() {
    final rentalData = dashboardService.rentalPerformance.value;
    if (rentalData.rentalUnitPopularity.isEmpty) {
      return const Center(child: Text('No rental data available'));
    }

    final units = <String>[];
    final counts = <double>[];

    rentalData.rentalUnitPopularity.forEach((key, value) {
      units.add(key);
      counts.add(value.toDouble());
    });

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: counts.reduce((a, b) => a > b ? a : b) * 1.2,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return Text(value.toInt().toString());
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= units.length) return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    units[value.toInt()],
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          units.length,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: counts[i],
                color: Colors.blue,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOccupancyRateChart() {
    final rentalData = dashboardService.rentalPerformance.value;
    if (rentalData.monthlyOccupancyRate.isEmpty) {
      return const Center(child: Text('No occupancy data available'));
    }

    final months = rentalData.monthlyOccupancyRate.keys.toList();
    final rates = rentalData.monthlyOccupancyRate.values.toList();

    final spots = List.generate(
      months.length,
      (i) => FlSpot(i.toDouble(), rates[i].toDouble()),
    );

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}%');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= months.length) return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    months[value.toInt()],
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDistributionChart() {
    final reviewData = dashboardService.reviews.value;
    if (reviewData.ratingDistribution.isEmpty) {
      return const Center(child: Text('No rating data available'));
    }

    final ratings = <int>[];
    final counts = <double>[];

    for (int i = 1; i <= 5; i++) {
      ratings.add(i);
      counts.add(reviewData.ratingDistribution[i.toString()]?.toDouble() ?? 0);
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: counts.reduce((a, b) => a > b ? a : b) * 1.2,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return Text(value.toInt().toString());
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= ratings.length) return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${ratings[value.toInt()]}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                    ],
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          ratings.length,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: counts[i],
                color:
                    ratings[i] >= 4
                        ? Colors.green
                        : ratings[i] == 3
                        ? Colors.amber
                        : Colors.red,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyRatingsChart() {
    final reviewData = dashboardService.reviews.value;
    if (reviewData.monthlyRatings.isEmpty) {
      return const Center(child: Text('No monthly rating data available'));
    }

    final months = reviewData.monthlyRatings.keys.toList();
    final ratings = <double>[];
    final counts = <double>[];

    for (final month in months) {
      ratings.add(reviewData.monthlyRatings[month]!.avgRating);
      counts.add(reviewData.monthlyRatings[month]!.count.toDouble());
    }

    final ratingSpots = List.generate(
      months.length,
      (i) => FlSpot(i.toDouble(), ratings[i]),
    );

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const Text('');
                return Text('${value.toInt()}★');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= months.length || value % 2 != 0) {
                  return const Text('');
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    months[value.toInt()],
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: ratingSpots,
            isCurved: true,
            color: Colors.amber,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.amber.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
