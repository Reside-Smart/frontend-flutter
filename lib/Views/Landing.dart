import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:reside_smart_flutter/Utils/Theme.dart';
import 'package:reside_smart_flutter/Widgets/MyAppBar.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late int selectedPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> pages = [
    {
      "image": "images/ResideSmart-landing-1.png",
      "text": "Discover Your Dream Home with Reside Smart",
    },
    {
      "image": "images/residesmart-landing-2.png",
      "text":
          "Get Instant Notifications on New Listings, Property Updates and More",
    },
    {
      "image": "images/ResideSmart-landing-3.png",
      "text": "Close Deals Seamlessly with Reside Smart",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                if (selectedPage == (pages.length - 1)) {
                  // Get.toNamed('login');
                  print('hello');
                }

                setState(() {
                  selectedPage = index;
                });
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Image Section
                    const SizedBox(height: 120),
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Image.asset(
                          pages[index]["image"]!,
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                      ),
                    ),

                    // Text Section
                    Flexible(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              pages[index]["text"]!,
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 42),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
          // Page Indicator
          PageViewDotIndicator(
            currentItem: selectedPage,
            count: pages.length,
            unselectedColor: Colors.black26,
            selectedColor: AppTheme.lightTheme.primaryColor,
            duration: const Duration(milliseconds: 200),
            size: Size(30, 8),
            unselectedSize: Size(8, 8),
            borderRadius: BorderRadius.circular(50),
            boxShape: BoxShape.rectangle,
            onItemClicked: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (selectedPage == pages.length - 1) {
                        Get.offAndToNamed('/signUp');
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
