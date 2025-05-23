import 'package:flutter/services.dart';
import 'package:reside_smart_flutter/Controllers/PurchaseListingController.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Services/TransactionService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Widgets/MyTransactionCard.dart';
import 'package:table_calendar/table_calendar.dart';

class PurchaseListing extends StatefulWidget {
  const PurchaseListing({super.key});

  @override
  State<PurchaseListing> createState() => _PurchaseListingState();
}

class _PurchaseListingState extends State<PurchaseListing>
    with GlobalFunctions {
  final PurchaseListingController purchaseListingController =
      Get.find<PurchaseListingController>();
  final formKey = GlobalKey<FormState>();

  final TextEditingController noteController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TransactionService transactionService = Get.find<TransactionService>();

  String selectedMethod = 'cash';
  late final ListingModel listing;
  dynamic selectedRentalOption;
  DateTime? selectedDate;
  List<DateTime> bookedDates = [];

  Future<void> loadBookedDates() async {
    bookedDates = await transactionService.getBookedDays(
      listingId: listing.id!,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    listing = args['listing'];
    selectedRentalOption = args['selectedRentalOption'];
    loadBookedDates();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    print(listing);
    print(selectedRentalOption);
    print(listing.discounts);
    print('Selected Rental Option: $selectedRentalOption');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'Purchase Listing'),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TransactionCard(
                      id: listing.id!,
                      image:
                          (listing.images != null && listing.images!.isNotEmpty)
                              ? listing.images!.first
                              : '',
                      name: listing.name ?? 'No name',
                      price: listing.price?.toString() ?? '',
                      rating: listing.averageReviews?.toString() ?? '',
                      location: listing.address ?? 'No address',
                      type: listing.type ?? '',
                      rentalOptions: listing.rentalOptions ?? [],
                      selectedRentalOptionId: selectedRentalOption,
                      discounts: listing.discounts ?? [],
                    ),
                    SizedBox(height: 40),
                    if (listing.type == 'rent') ...[
                      const Text(
                        "Booked Days:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.utc(2100, 12, 31),
                        focusedDay: DateTime.now(),
                        daysOfWeekVisible: false,
                        headerStyle: HeaderStyle(formatButtonVisible: false),
                        selectedDayPredicate: (day) => false,
                        enabledDayPredicate: (day) {
                          final normalizedDay = DateTime(
                            day.year,
                            day.month,
                            day.day,
                          );
                          return !bookedDates.any(
                            (d) => isSameDay(d, normalizedDay),
                          );
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, _) {
                            final normalizedDay = DateTime(
                              day.year,
                              day.month,
                              day.day,
                            );
                            final isBooked = bookedDates.any(
                              (d) => isSameDay(d, normalizedDay),
                            );
                            if (isBooked) {
                              return Center(
                                child: Text(
                                  '${day.day}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              );
                            }
                            return null;
                          },

                          disabledBuilder:
                              (context, day, _) => Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      '${day.day}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Positioned(
                                      top: 9,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 2,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),

                      SizedBox(height: 20),
                      const Text(
                        "Date:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: startDateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "Start Date",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                              ),

                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );

                                if (picked != null) {
                                  final rentalOption = listing.rentalOptions
                                      ?.firstWhere(
                                        (option) =>
                                            option.id == selectedRentalOption,
                                      );

                                  if (rentalOption == null) {
                                    AppDialog.showError(
                                      "Rental option not found.",
                                    );
                                    return;
                                  }

                                  setState(() {
                                    startDateController.text =
                                        picked.toString().split(' ')[0];

                                    int duration = rentalOption.duration;
                                    String unit =
                                        rentalOption.unit.toLowerCase().trim();

                                    DateTime endDate;
                                    switch (unit) {
                                      case 'day':
                                      case 'days':
                                        endDate = picked.add(
                                          Duration(days: duration),
                                        );
                                        break;
                                      case 'week':
                                      case 'weeks':
                                        endDate = picked.add(
                                          Duration(days: duration * 7),
                                        );
                                        break;
                                      case 'month':
                                      case 'months':
                                        endDate = DateTime(
                                          picked.year,
                                          picked.month + duration,
                                          picked.day,
                                        );
                                        break;
                                      case 'year':
                                      case 'years':
                                        endDate = DateTime(
                                          picked.year + duration,
                                          picked.month,
                                          picked.day,
                                        );
                                        break;
                                      default:
                                        endDate = picked.add(
                                          Duration(days: duration),
                                        );
                                    }

                                    endDateController.text =
                                        endDate.toString().split(' ')[0];
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: endDateController,
                              readOnly: true,
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: "End Date",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    SizedBox(height: 30),
                    Text(
                      "Payment Method",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C54),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMethod = 'cash';
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: 150,
                            height: 150,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF2BC0E4), Color(0xFFEAECC6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow:
                                  selectedMethod == 'cash'
                                      ? [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 10,
                                        ),
                                      ]
                                      : [],
                            ),
                            child: Stack(
                              children: [
                                if (selectedMethod == 'cash')
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Cash",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.toggle_on,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMethod = 'stripe';
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: 150,
                            height: 150,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF635BFF),
                                  Color.fromARGB(255, 159, 152, 255),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow:
                                  selectedMethod == 'stripe'
                                      ? [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 10,
                                        ),
                                      ]
                                      : [],
                            ),
                            child: Stack(
                              children: [
                                if (selectedMethod == 'stripe')
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Stripe",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'VISA',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60),

                    Center(
                      child: SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (listing.type == 'rent' &&
                                  (startDateController.text.isEmpty ||
                                      endDateController.text.isEmpty)) {
                                AppDialog.showError(
                                  "Please select valid dates.",
                                );
                                return;
                              }

                              final start = DateTime.tryParse(
                                startDateController.text,
                              );
                              final now = DateTime.now();
                              if (start != null &&
                                  start.isBefore(
                                    DateTime(now.year, now.month, now.day),
                                  )) {
                                AppDialog.showError(
                                  "Start date cannot be in the past.",
                                );
                                return;
                              }

                              final rentalOption = listing.rentalOptions
                                  ?.firstWhereOrNull(
                                    (option) =>
                                        option.id == selectedRentalOption,
                                  );

                              final double basePrice =
                                  rentalOption?.price ?? listing.price ?? 0.0;

                              final discount = listing.discounts
                                  ?.firstWhereOrNull((d) {
                                    final isActive = d.status == 'active';
                                    final matchRental =
                                        d.rentalOptionId ==
                                        selectedRentalOption;
                                    final matchListing =
                                        d.listingId == listing.id &&
                                        d.rentalOptionId == null;
                                    return isActive &&
                                        (matchRental || matchListing);
                                  });

                              final double discountPercent =
                                  discount != null
                                      ? double.tryParse(
                                            discount.percentage.toString(),
                                          ) ??
                                          0.0
                                      : 0.0;

                              final double amountPaid =
                                  discountPercent > 0
                                      ? basePrice -
                                          (basePrice * discountPercent / 100)
                                      : basePrice;

                              final String paymentStatus =
                                  selectedMethod == 'cash' ? 'unpaid' : 'paid';

                              final buyerId =
                                  Get.find<AuthService>().globalUser!.id;
                              final sellerId = listing.userId;

                              if (sellerId == null) {
                                AppDialog.showError("Listing owner not found.");
                                return;
                              }

                              purchaseListingController.createTransaction(
                                transactionType: listing.type!,
                                totalPrice: basePrice,
                                amountPaid: amountPaid,
                                paymentMethod: selectedMethod,
                                paymentStatus: paymentStatus,
                                listingId: listing.id!,
                                buyerId: buyerId,
                                sellerId: sellerId,
                                discountId: discount?.discountId,
                                rentalOptionId: selectedRentalOption,
                                checkInDate:
                                    listing.type == 'rent'
                                        ? startDateController.text
                                        : DateTime.now().toString().split(
                                          ' ',
                                        )[0],
                                checkOutDate:
                                    listing.type == 'rent'
                                        ? endDateController.text
                                        : null,
                              );
                            }
                          },

                          child: Text("Purchase Listing"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
