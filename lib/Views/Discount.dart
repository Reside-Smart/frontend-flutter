import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/DiscountController.dart';
import 'package:reside_smart_flutter/Widgets/DiscountCard.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({super.key});

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  final formKey = GlobalKey<FormState>();
  String selectedStatus = 'active';

  @override
  void initState() {
    super.initState();
    final DiscountController discountController =
        Get.find<DiscountController>();
    discountController.fetchDiscount(selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final DiscountController discountController =
        Get.find<DiscountController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'My Discounts'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedStatus,
                    items:
                        ['Active', 'Inactive', 'Expired', 'Deactivated'].map((
                          String dropDownValue,
                        ) {
                          return DropdownMenuItem<String>(
                            value: dropDownValue.toLowerCase(),
                            child: Text(dropDownValue),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                      });
                      discountController.fetchDiscount(newValue!);
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed('/add-discount');
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await discountController.fetchDiscount(selectedStatus);
                  },
                  child: Obx(() {
                    if (discountController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (discountController.listingDiscount.isEmpty) {
                      return const Center(child: Text('No Discounts Found.'));
                    }
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: discountController.listingDiscount.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder:
                          (ctx, i) => DiscountCard(
                            discount: discountController.listingDiscount[i],
                            colorScheme: cs,
                            textTheme: tt,
                          ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
