import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/DashboardModels.dart';
import 'package:reside_smart_flutter/Services/AnalyticsService.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Services/DashboardService.dart';
import 'package:reside_smart_flutter/Widgets/MyDrawer.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DashboardService dashboardService = Get.put(DashboardService());
  int selectedTab = 0;
  bool isLoading = false;
  final AuthService authService = Get.find<AuthService>();
  final AnalyticsService analyticsService = Get.find<AnalyticsService>();
  final Rx<OverviewData> overview = OverviewData().obs;
  final Rx<RevenueData> revenueData = RevenueData().obs;

  String? errorMessage;
  String _revenueTimeframe = 'month';

  @override
  void initState() {
    super.initState();
    fetchAnalytics();
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

  Future<void> fetchAnalytics() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Future.wait([
        dashboardService.fetchOverview(),
        dashboardService.fetchRevenueOverTime(_revenueTimeframe),
      ]);
      setState(() {});
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildDashboardCard({
    required String title,
    required IconData icon,
    required String value,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor:
                iconColor?.withOpacity(0.15) ?? Colors.blue.shade100,
            child: Icon(icon, size: 32, color: iconColor ?? Colors.blue),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
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

  Widget _buildOverviewTab() {
    final overview = dashboardService.overview.value;
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard header with view all button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Overview",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View Full Dashboard",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

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

          // Bottom view full dashboard button
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.toNamed('/dashboard');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.dashboard, color: Colors.white),
              label: Text(
                "Go to Full Dashboard",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder:
                (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.settings, color: Colors.black),
                  ),
                ),
          ),
        ],
      ),
      drawer: MyDrawer(authService: authService),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      child:
                          authService.globalUser?.image != null
                              ? isLoading
                                  ? CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  )
                                  : ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: MyNetworkImage(
                                      url:
                                          "storage/${authService.globalUser?.image}",
                                    ),
                                  )
                              : Icon(Icons.person, size: 90),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                authService.globalUser!.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                authService.globalUser!.email,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(255, 41, 40, 40)),
              ),
              SizedBox(height: 30),
              Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => selectedTab = 0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selectedTab == 0
                                  ? Colors.white
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Account",
                          style: TextStyle(
                            color:
                                selectedTab == 0
                                    ? Colors.black
                                    : Colors.grey.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => selectedTab = 1),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selectedTab == 1
                                  ? Colors.white
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Dashboard",
                          style: TextStyle(
                            color:
                                selectedTab == 1
                                    ? Colors.black
                                    : Colors.grey.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              selectedTab == 0
                  ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 50,
                    ),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            Get.toNamed('edit-profile');
                          },
                          icon: Icon(Icons.edit),
                          label: Text("Edit Profile"),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            Get.toNamed('change-password');
                          },
                          icon: Icon(Icons.lock),
                          label: Text("Change Password"),
                        ),
                      ],
                    ),
                  )
                  : isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildOverviewTab(),
            ],
          ),
        ),
      ),
    );
  }
}
