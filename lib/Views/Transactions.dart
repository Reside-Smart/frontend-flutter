import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/TransactionsController.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Widgets/InOutTransactionCard.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:reside_smart_flutter/Widgets/TransactionCardWidget.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  int selectedTab = 0;
  final AuthService authService = Get.find<AuthService>();
  final TransactionsController tranasactionsController =
      Get.find<TransactionsController>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  void fetchData() async {
    isLoading.value = true;
    await tranasactionsController.fetchTransactions();
    isLoading.value = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final userId = authService.globalUser!.id;

    final inTransactions =
        tranasactionsController.transactions
            .where((t) => t.sellerId == userId)
            .toList();
    print(inTransactions);

    final outTransactions =
        tranasactionsController.transactions
            .where((t) => t.buyerId == userId)
            .toList();

    return Scaffold(
      appBar: MyMainAppBar(title: 'Transactions'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              SizedBox(height: 10),

              Container(
                height: 40,
                width: 250,
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
                          "In",
                          style: TextStyle(
                            color:
                                selectedTab == 0
                                    ? Colors.black
                                    : const Color.fromARGB(255, 81, 81, 81),
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
                          "Out",
                          style: TextStyle(
                            color:
                                selectedTab == 1
                                    ? Colors.black
                                    : const Color.fromARGB(255, 81, 81, 81),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    fetchData();
                  },
                  child: Obx(
                    () =>
                        isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : selectedTab == 0
                            ? (inTransactions.isEmpty
                                ? const Center(
                                  child: Text("No incoming transactions"),
                                )
                                : SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: Wrap(
                                    runSpacing: 20,
                                    children:
                                        inTransactions.map((tx) {
                                          final matchingListing = tx.listing;
                                          final image =
                                              (matchingListing
                                                          ?.images
                                                          ?.isNotEmpty ??
                                                      false)
                                                  ? matchingListing!
                                                      .images!
                                                      .first
                                                  : '';
                                          return TransactionCardWidget(
                                            id: tx.id!,
                                            image: image,
                                            name:
                                                matchingListing?.name ??
                                                'no title',
                                            price:
                                                matchingListing?.price
                                                    ?.toString() ??
                                                '',
                                            rating:
                                                matchingListing?.averageReviews
                                                    ?.toString() ??
                                                '',
                                            location:
                                                matchingListing?.address ??
                                                'No address',
                                            type: tx.type ?? '',
                                            rentalOptions:
                                                matchingListing
                                                    ?.rentalOptions ??
                                                [],
                                            selectedRentalOptionId:
                                                tx.rentalOptionId,
                                            discounts:
                                                matchingListing?.discounts ??
                                                [],
                                            quantity: tx.quantity ?? 1,
                                            isClickable: true,
                                          );
                                        }).toList(),
                                  ),
                                ))
                            : (outTransactions.isEmpty
                                ? const Center(
                                  child: Text("No outgoing transactions"),
                                )
                                : SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: Wrap(
                                    runSpacing: 20,
                                    children:
                                        outTransactions.map((tx) {
                                          final matchingListing = tx.listing;
                                          final image =
                                              (matchingListing
                                                          ?.images
                                                          ?.isNotEmpty ??
                                                      false)
                                                  ? matchingListing!
                                                      .images!
                                                      .first
                                                  : '';
                                          return TransactionCardWidget(
                                            id: tx.id!,
                                            image: image,
                                            name:
                                                matchingListing?.name ??
                                                'no title',
                                            price:
                                                matchingListing?.price
                                                    ?.toString() ??
                                                '',
                                            rating:
                                                matchingListing?.averageReviews
                                                    ?.toString() ??
                                                '',
                                            location:
                                                matchingListing?.address ??
                                                'No address',
                                            type: tx.type ?? '',
                                            rentalOptions:
                                                matchingListing
                                                    ?.rentalOptions ??
                                                [],
                                            selectedRentalOptionId:
                                                tx.rentalOptionId,
                                            discounts:
                                                matchingListing?.discounts ??
                                                [],
                                            quantity: tx.quantity ?? 1,
                                            isClickable: true,
                                          );
                                        }).toList(),
                                  ),
                                )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
