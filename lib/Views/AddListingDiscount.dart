import 'dart:io';
import 'package:flutter/services.dart';
import 'package:reside_smart_flutter/Controllers/AddDiscountController.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/ListingService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddDiscountPage extends StatefulWidget {
  const AddDiscountPage({super.key});

  @override
  State<AddDiscountPage> createState() => _AddDiscountPageState();
}

class _AddDiscountPageState extends State<AddDiscountPage>
    with GlobalFunctions {
  final AddDiscountController addDiscountController =
      Get.find<AddDiscountController>();
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final List<String> status = ['Active', 'Inactive'];
  String? selectedStatus;
  List<ListingModel> listings = [];
  List<dynamic> rentalOptions = [];
  int? selectedRentalOption;
  bool showRentalOptions = false;

  Future<void> loadListings() async {
    try {
      final ListingService listingservice = Get.find<ListingService>();
      final fetchedListings = await listingservice.getUserListings("published");

      setState(() {
        listings = fetchedListings;
      });
    } catch (e) {
      print(e);
    }
  }

  int? selectedListing;

  @override
  void dispose() {
    nameController.dispose();
    percentageController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadListings();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'Add Discount'),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: -125,
              child: Container(
                width: 325,
                height: 325,
                decoration: BoxDecoration(
                  color: const Color(0x3325B4F8),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              top: 150,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0x6625B4F8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
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
                    Text(
                      "Hello, fill the details of the Discount",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                    SizedBox(height: 40),

                    Text(
                      "Name:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Discount Name",
                        prefixIcon: Icon(Icons.discount),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Field is required";
                        return null;
                      },
                    ),
                    SizedBox(height: 30),

                    Text(
                      "Listing:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),

                    DropdownSearch<ListingModel>(
                      items: listings,
                      itemAsString: (ListingModel u) => u.name ?? "Unnamed",

                      onChanged: (ListingModel? value) async {
                        setState(() {
                          selectedListing = value?.id;
                          selectedRentalOption = null;
                          showRentalOptions = false;
                          rentalOptions = [];
                        });

                        if (value != null &&
                            value.type?.toLowerCase() == 'rent') {
                          try {
                            final ListingService listingservice =
                                Get.find<ListingService>();
                            final options = await listingservice
                                .getRentalOptions(value.id!);

                            setState(() {
                              rentalOptions = options;
                              showRentalOptions = true;
                            });
                          } catch (e) {
                            print(e);
                            AppDialog.showError(
                              'Failed to load rental options',
                            );
                          }
                        }
                      },

                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Select Listing",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      validator:
                          (value) => value == null ? "Select a listing" : null,
                      popupProps: PopupProps.menu(showSearchBox: true),
                    ),
                    SizedBox(height: 30),
                    if (showRentalOptions)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rental Option:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<int>(
                            value: selectedRentalOption,
                            items:
                                rentalOptions.map<DropdownMenuItem<int>>((
                                  option,
                                ) {
                                  return DropdownMenuItem<int>(
                                    value: option['id'],
                                    child: Text(
                                      "${option['price']} / ${option['duration']} ${option['unit']}",
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedRentalOption = value;
                                print(selectedRentalOption);
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Select Rental Option",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (showRentalOptions && value == null) {
                                return "Select a rental option";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      ),

                    Text(
                      "Percentage:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: percentageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Percentage (%)",
                        prefixIcon: Icon(Icons.percent),

                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Required";
                        if (double.tryParse(value) == null) {
                          return "Invalid number";
                        }
                        if (double.parse(value) <= 0 ||
                            double.parse(value) > 100) {
                          return "Must be 1-100%";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Date:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
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
                                setState(() {
                                  startDateController.text =
                                      picked.toString().split(' ')[0];
                                });
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) return "Field is required";
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: endDateController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: "End Date",
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
                                setState(() {
                                  endDateController.text =
                                      picked.toString().split(' ')[0];
                                });
                              }
                            },
                            validator:
                                (value) => value!.isEmpty ? "Required" : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 70),

                    Center(
                      child: SizedBox(
                        width: 340,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              DateTime startDate = DateTime.parse(
                                startDateController.text.trim(),
                              );
                              DateTime endDate = DateTime.parse(
                                endDateController.text.trim(),
                              );
                              if (startDate.isAfter(endDate)) {
                                AppDialog.showError(
                                  'Start date must be before end date',
                                );
                                return;
                              }
                              addDiscountController.addDiscount(
                                name: nameController.text.trim(),
                                percentage: double.parse(
                                  percentageController.text.trim(),
                                ),
                                startDate: startDateController.text.trim(),
                                endDate: endDateController.text.trim(),
                                listingId: selectedListing,
                                rentalOptionId: selectedRentalOption,
                              );
                            }
                          },
                          child: Text("Add Discount "),
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
