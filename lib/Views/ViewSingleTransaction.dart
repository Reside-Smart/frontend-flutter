import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/ViewSingleTransactionController.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Services/TransactionService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:reside_smart_flutter/Widgets/MyTransactionCard.dart';

class ViewSingleTransaction extends StatefulWidget {
  const ViewSingleTransaction({super.key});

  @override
  State<ViewSingleTransaction> createState() => _ViewSingleTransactionState();
}

class _ViewSingleTransactionState extends State<ViewSingleTransaction> {
  final ViewSingleTransactionController viewSingleTransaction =
      Get.find<ViewSingleTransactionController>();
  final AuthService authService = Get.find<AuthService>();
  final TransactionService transactionService = Get.find<TransactionService>();

  @override
  void initState() {
    super.initState();
    final int id = Get.arguments['id'];
    viewSingleTransaction.getSingleTransaction(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyMainAppBar(title: 'Transaction Details'),
      body: Obx(() {
        final transaction = viewSingleTransaction.transaction.value;
        if (transaction == null) {
          return Center(child: CircularProgressIndicator());
        }
        print(transaction.listing!.user!.name);
        print(transaction.discountId);
        print(transaction.listing!.rentalOptions);
        print(transaction.listing);
        print(transaction.rentalOptionId);

        return RefreshIndicator(
          onRefresh: () async {
            final int id = Get.arguments['id'];
            await viewSingleTransaction.getSingleTransaction(id);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TransactionCard(
                  id: transaction.id!,
                  image:
                      (transaction.listing!.images != null &&
                              transaction.listing!.images!.isNotEmpty)
                          ? transaction.listing!.images!.first
                          : '',
                  name: transaction.listing!.name ?? 'No name',
                  price: transaction.listing!.price?.toString() ?? '',
                  rating: transaction.listing!.averageReviews?.toString() ?? '',
                  location: transaction.listing!.address ?? 'No address',
                  type: transaction.listing!.type ?? '',
                  rentalOptions: transaction.listing!.rentalOptions ?? [],
                  selectedRentalOptionId: transaction.rentalOptionId,
                  discounts: transaction.listing!.discounts ?? [],
                ),
                const SizedBox(height: 24),

                const Text(
                  'Transaction Detail',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Check in',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          transaction.checkInDate!.toIso8601String().split(
                            'T',
                          )[0],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    transaction.type == 'rent'
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Check out',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              transaction.checkOutDate!.toIso8601String().split(
                                'T',
                              )[0],

                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                        : const SizedBox(),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Owner name',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          transaction.listing?.user?.name ?? 'no name ',

                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction type',

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          transaction.type!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  'Payment Detail',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          transaction.paymentMethod!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Status',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              transaction.paymentStatus!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (transaction.paymentStatus == 'unpaid' &&
                                authService.globalUser!.id ==
                                    transaction.sellerId)
                              GestureDetector(
                                onTap: () {
                                  AppDialog.showConfirm(
                                    message:
                                        "Are you sure you want to change payment status to paid",
                                    onConfirm: () async {
                                      await transactionService.markAsPaid(
                                        transactionId: transaction.id!,
                                      );
                                      viewSingleTransaction.transaction.update((
                                        tx,
                                      ) {
                                        if (tx != null) {
                                          tx.paymentStatus = 'paid';
                                        }
                                      });
                                    },
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Listing Price',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          transaction.totalPrice.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (transaction.discount != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${transaction.discount!.percentage}%',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey[300]!, width: 1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            transaction.amountPaid.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text(
                  'Love the estate?',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        '/add-review',
                        arguments: {'listingId': transaction.listingId},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Click here to add review',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
