import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

import 'package:reside_smart_flutter/Controllers/PurchaseListingController.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Services/TransactionService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:reside_smart_flutter/Widgets/MyTransactionCard.dart';

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
  final RxInt quantity = 1.obs;
  final TransactionService transactionService = Get.find<TransactionService>();

  String selectedMethod = 'cash';
  late final ListingModel listing;
  dynamic selectedRentalOption;
  List<DateTime> bookedDates = [];
  final RxBool isLoading = false.obs;

  Future<void> loadBookedDates() async {
    isLoading.value = true;
    try {
      bookedDates = await transactionService.getBookedDays(
        listingId: listing.id!,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    listing = args['listing'];
    selectedRentalOption = args['selectedRentalOption'];
    loadBookedDates();
  }

  DateTime calculateEndDate(DateTime startDate, int quantityValue) {
    final rentalOption = listing.rentalOptions?.firstWhere(
      (option) => option.id == selectedRentalOption,
    );

    if (rentalOption == null) return startDate;

    if (quantityValue == 1 &&
        rentalOption.duration == 1 &&
        (rentalOption.unit.toLowerCase().trim() == 'day' ||
            rentalOption.unit.toLowerCase().trim() == 'days')) {
      return startDate;
    }

    int duration = rentalOption.duration * quantityValue;
    String unit = rentalOption.unit.toLowerCase().trim();

    switch (unit) {
      case 'day':
      case 'days':
        return startDate.add(Duration(days: duration - 1));
      case 'week':
      case 'weeks':
        return startDate.add(Duration(days: duration * 7 - 1));
      case 'month':
      case 'months':
        final endDate = DateTime(
          startDate.year,
          startDate.month + duration,
          startDate.day,
        );
        return endDate.subtract(Duration(days: 1));
      case 'year':
      case 'years':
        final endDate = DateTime(
          startDate.year + duration,
          startDate.month,
          startDate.day,
        );
        return endDate.subtract(Duration(days: 1));
      default:
        return startDate.add(Duration(days: duration - 1));
    }
  }

  bool isDateBooked(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return bookedDates.any((d) => isSameDay(d, normalizedDate));
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _showDatePicker() async {
    final rentalOption = listing.rentalOptions?.firstWhere(
      (option) => option.id == selectedRentalOption,
    );

    if (rentalOption == null) {
      AppDialog.showError("Rental option not found.");
      return;
    }

    String optionDisplay = '${rentalOption.duration} ${rentalOption.unit}';

    final dateFormat = DateFormat('MMM d, yyyy');
    DateTime? pickedDate;
    DateTime initialDate = DateTime.now();

    while (isDateBooked(initialDate)) {
      initialDate = initialDate.add(const Duration(days: 1));
    }

    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setDialogState) {
              final endDate =
                  pickedDate != null
                      ? calculateEndDate(pickedDate!, quantity.value)
                      : null;

              return AlertDialog(
                title: const Text('Select Rental Dates'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rental option: $optionDisplay',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),

                      Text('Quantity:'),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed:
                                quantity.value > 1
                                    ? () =>
                                        setDialogState(() => quantity.value--)
                                    : null,
                          ),
                          Text(
                            '${quantity.value}',
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed:
                                () => setDialogState(() => quantity.value++),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      Text('Start date:'),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                            selectableDayPredicate: (day) => !isDateBooked(day),
                          );

                          if (picked != null) {
                            setDialogState(() => pickedDate = picked);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 18),
                              SizedBox(width: 8),
                              Text(
                                pickedDate != null
                                    ? dateFormat.format(pickedDate!)
                                    : 'Select date',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      pickedDate != null
                                          ? Colors.black
                                          : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (pickedDate != null && endDate != null) ...[
                        SizedBox(height: 20),
                        Text('End date:'),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade100,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.event_available, size: 18),
                              SizedBox(width: 8),
                              Text(
                                dateFormat.format(endDate),
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),

                        if (pickedDate!.isAtSameMomentAs(endDate!)) ...[
                          SizedBox(height: 8),
                          Text(
                            'Same day rental (pick-up and return on the same day)',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],

                        SizedBox(height: 16),
                        Text(
                          quantity.value == 1 &&
                                  (rentalOption.unit.toLowerCase().trim() ==
                                          'day' ||
                                      rentalOption.unit.toLowerCase().trim() ==
                                          'days')
                              ? 'Same day rental'
                              : 'Total duration: ${quantity.value} × $optionDisplay',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('CANCEL'),
                  ),
                  ElevatedButton(
                    onPressed:
                        pickedDate == null
                            ? null
                            : () {
                              startDateController.text =
                                  pickedDate.toString().split(' ')[0];
                              endDateController.text =
                                  endDate.toString().split(' ')[0];
                              Navigator.pop(context);
                              setState(() {});
                            },
                    child: Text('CONFIRM'),
                  ),
                ],
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dateFormat = DateFormat('MMM d, yyyy');

    return Scaffold(
      appBar: MyMainAppBar(title: 'Complete Your Purchase'),
      body: Obx(() {
        if (isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(height: 24),
                        TransactionCard(
                          id: listing.id!,
                          image:
                              (listing.images != null &&
                                      listing.images!.isNotEmpty)
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
                          quantity: quantity.value,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                if (listing.type == 'rent') ...[
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rental Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(height: 24),

                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Rental Period'),
                            subtitle:
                                startDateController.text.isNotEmpty
                                    ? Text(
                                      '${dateFormat.format(DateTime.parse(startDateController.text))} - ${dateFormat.format(DateTime.parse(endDateController.text))}',
                                    )
                                    : Text('Select rental dates'),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: _showDatePicker,
                          ),

                          if (startDateController.text.isNotEmpty) ...[
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Quantity'),
                              subtitle: Text('${quantity.value} units'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                ],

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(height: 24),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 500) {
                              return Row(
                                children: [
                                  Expanded(child: _buildCashOption()),
                                  Expanded(child: _buildStripeOption()),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  _buildCashOption(),
                                  _buildStripeOption(),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 32),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cost Breakdown',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(height: 24),

                        PriceBreakdownWidget(
                          listing: listing,
                          selectedRentalOption: selectedRentalOption,
                          quantity: quantity.value,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (listing.type == 'rent' &&
                            (startDateController.text.isEmpty ||
                                endDateController.text.isEmpty)) {
                          AppDialog.showError("Please select rental dates.");
                          return;
                        }

                        final rentalOption = listing.rentalOptions
                            ?.firstWhereOrNull(
                              (option) => option.id == selectedRentalOption,
                            );

                        final discount = listing.discounts?.firstWhereOrNull(
                          (d) =>
                              d.status.toLowerCase() == 'active' &&
                              (d.rentalOptionId == selectedRentalOption ||
                                  d.rentalOptionId == null),
                        );

                        double baseUnitPrice = 0;
                        if (listing.type == 'rent' && rentalOption != null) {
                          baseUnitPrice = rentalOption.price;
                        } else {
                          baseUnitPrice = listing.price ?? 0;
                        }

                        final basePrice = baseUnitPrice * quantity.value;
                        final discountPercent = discount?.percentage ?? 0;
                        final discountAmount =
                            basePrice * discountPercent / 100;
                        final finalPrice = basePrice - discountAmount;

                        if (selectedMethod == 'stripe') {
                          purchaseListingController.processDirectPayment(
                            productName: listing.name ?? 'Property listing',
                            amount: finalPrice,
                            listingId: listing.id!,
                            sellerId: listing.userId!,
                            transactionType: listing.type!,
                            discountId: discount?.discountId,
                            rentalOptionId: selectedRentalOption,
                            quantity: quantity.value,
                            checkInDate:
                                listing.type == 'rent'
                                    ? startDateController.text
                                    : null,
                            checkOutDate:
                                listing.type == 'rent'
                                    ? endDateController.text
                                    : null,
                          );
                        } else {
                          purchaseListingController.createCashTransaction(
                            transactionType: listing.type!,
                            totalPrice: basePrice,
                            amountPaid: finalPrice,
                            listingId: listing.id!,
                            buyerId: Get.find<AuthService>().globalUser!.id,
                            sellerId: listing.userId!,
                            discountId: discount?.discountId,
                            rentalOptionId: selectedRentalOption,
                            quantity: quantity.value,
                            checkInDate:
                                listing.type == 'rent'
                                    ? startDateController.text
                                    : null,
                            checkOutDate:
                                listing.type == 'rent'
                                    ? endDateController.text
                                    : null,
                          );
                        }
                      }
                    },
                    child: Text(
                      "Complete Purchase",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCashOption() {
    return RadioListTile<String>(
      title: Row(
        children: [
          Icon(Icons.money, color: Color(0xFF2BC0E4)),
          SizedBox(width: 8),
          Text('Cash'),
        ],
      ),
      value: 'cash',
      groupValue: selectedMethod,
      onChanged: (value) {
        setState(() {
          selectedMethod = value!;
        });
      },
    );
  }

  Widget _buildStripeOption() {
    return RadioListTile<String>(
      title: Row(
        children: [
          Image.asset('images/stripe_logo.png', height: 24, width: 24),
          SizedBox(width: 8),
          Text('Credit/Debit Card'),
        ],
      ),
      subtitle: Text('Secure payment via Stripe'),
      value: 'stripe',
      groupValue: selectedMethod,
      onChanged: (value) {
        setState(() {
          selectedMethod = value!;
        });
      },
    );
  }
}

class PriceBreakdownWidget extends StatelessWidget {
  final ListingModel listing;
  final dynamic selectedRentalOption;
  final int quantity;

  const PriceBreakdownWidget({
    required this.listing,
    required this.selectedRentalOption,
    required this.quantity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rentalOption = listing.rentalOptions?.firstWhereOrNull(
      (option) => option.id == selectedRentalOption,
    );

    final double baseUnitPrice = rentalOption?.price ?? listing.price ?? 0.0;
    final double basePrice = baseUnitPrice * quantity;

    final discount = listing.discounts?.firstWhereOrNull((d) {
      final isActive = d.status == 'active';
      final matchRental = d.rentalOptionId == selectedRentalOption;
      final matchListing =
          d.listingId == listing.id && d.rentalOptionId == null;
      return isActive && (matchRental || matchListing);
    });

    final double discountPercent =
        discount != null
            ? double.tryParse(discount.percentage.toString()) ?? 0.0
            : 0.0;

    final double discountAmount =
        discountPercent > 0 ? (basePrice * discountPercent / 100) : 0.0;

    final double finalPrice = basePrice - discountAmount;

    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Base price'),
            Text(currencyFormat.format(baseUnitPrice)),
          ],
        ),
        SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Quantity'), Text('x $quantity')],
        ),
        SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Subtotal'), Text(currencyFormat.format(basePrice))],
        ),

        if (discountPercent > 0) ...[
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Discount (${discountPercent.toStringAsFixed(0)}%)'),
              Text('- ${currencyFormat.format(discountAmount)}'),
            ],
          ),
        ],

        Divider(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              currencyFormat.format(finalPrice),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
