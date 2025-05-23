import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/AnalyticsService.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Widgets/MyDrawer.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTab = 0;
  bool isLoading = false;
  final AuthService authService = Get.find<AuthService>();
  final AnalyticsService analyticsService = Get.find<AnalyticsService>();

  String? errorMessage;
  Map<String, dynamic>? analytics;

  @override
  void initState() {
    super.initState();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await analyticsService.fetchAnalytics();

      setState(() {
        analytics = data;
      });
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
                  : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : analytics == null
                  ? Center(child: Text("No analytics available"))
                  : GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.1,
                    children: [
                      buildDashboardCard(
                        title: "Total Listings",
                        icon: Icons.home,
                        value: "${analytics!['total_listings'] ?? 0}",
                        iconColor: Colors.blue,
                      ),
                      buildDashboardCard(
                        title: "Rent Listings",
                        icon: Icons.key,
                        value: "${analytics!['rent_listings'] ?? 0}",
                        iconColor: Colors.orange,
                      ),
                      buildDashboardCard(
                        title: "Sell Listings",
                        icon: Icons.sell,
                        value: "${analytics!['sell_listings'] ?? 0}",
                        iconColor: Colors.green,
                      ),
                      buildDashboardCard(
                        title: "Transactions",
                        icon: Icons.receipt_long,
                        value: "${analytics!['total_transactions'] ?? 0}",
                        iconColor: Colors.purple,
                      ),
                      // buildDashboardCard(
                      //   title: "Revenue",
                      //   icon: Icons.attach_money,
                      //   value:
                      //       "\$${(analytics!['total_revenue'] ?? 0).toStringAsFixed(2)}",
                      //   iconColor: Colors.teal,
                      // ),
                      buildDashboardCard(
                        title: "Avg. Rating",
                        icon: Icons.star_rate,
                        value:
                            "${(analytics!['average_rating'] ?? 0).toStringAsFixed(1)}",
                        iconColor: Colors.amber,
                      ),
                      buildDashboardCard(
                        title: "Reviews",
                        icon: Icons.rate_review,
                        value: "${analytics!['total_reviews'] ?? 0}",
                        iconColor: Colors.redAccent,
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
