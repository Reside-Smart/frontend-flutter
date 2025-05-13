import 'package:reside_smart_flutter/Controllers/ListingsController.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Widgets/MyListingCard.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({super.key});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> with GlobalFunctions {
  final formKey = GlobalKey<FormState>();
  String selectedStatus = 'published';

  void initState() {
    super.initState();
    final ListingsController listingsController =
        Get.find<ListingsController>();
    listingsController.fetchListings(selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final ListingsController listingsController =
        Get.find<ListingsController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'My Listings'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              await listingsController.fetchListings(selectedStatus);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: selectedStatus,
                        items:
                            ['Published', 'Draft'].map((String dropDownValue) {
                              return DropdownMenuItem<String>(
                                value: dropDownValue.toLowerCase(),
                                child: Text(dropDownValue),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedStatus = newValue!;
                          });
                          listingsController.fetchListings(newValue!);
                        },
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed('add-listing');
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
                  Obx(
                    () =>
                        listingsController.isLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : listingsController.listings.isEmpty
                            ? Center(child: Text('No Listings Found!'))
                            : Wrap(
                              runSpacing: 18.0,
                              children:
                                  listingsController.listings.map((listing) {
                                    return PropertyCard(
                                      id: listing.id!,
                                      image:
                                          (listing.images != null &&
                                                  listing.images!.isNotEmpty)
                                              ? listing.images!.first
                                              : '',
                                      name: listing.name ?? 'No name',
                                      price: listing.price?.toString() ?? '',
                                      rating:
                                          listing.averageReviews?.toString() ??
                                          '',
                                      location: listing.address ?? 'No address',
                                      type: listing.type ?? '',
                                      rentalOptions:
                                          listing.rentalOptions ?? [],
                                    );
                                  }).toList(),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
