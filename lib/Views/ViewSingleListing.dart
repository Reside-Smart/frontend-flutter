import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/CategoryController.dart';
import 'package:reside_smart_flutter/Controllers/ViewSingleListingController.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:reside_smart_flutter/Views/ListingAllImages.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewSinglelisting extends StatefulWidget {
  const ViewSinglelisting({super.key});

  @override
  State<ViewSinglelisting> createState() => _ViewSinglelistingState();
}

class _ViewSinglelistingState extends State<ViewSinglelisting> {
  final ViewSingleListingController viewSingleListingController =
      Get.find<ViewSingleListingController>();
  final categotyController = Get.put(CategoryController());
  final AuthService authService = Get.find<AuthService>();

  int? selectedRentalOption;

  @override
  void initState() {
    super.initState();
    final int id = Get.arguments['id'];
    viewSingleListingController.getSingleListing(id);
  }

  // Future<void> openWhatsApp(String phone) async {
  //   try {
  //     final whatsappUrl = Uri.parse(
  //       'https://api.whatsapp.com/send?phone=$phone&text=Hello from Reside Smart',
  //     );
  //     print(whatsappUrl);
  //     if (await canLaunchUrl(whatsappUrl)) {
  //       // await launchUrl(whatsappUrl);
  //       // await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  //       await launchUrl(whatsappUrl, mode: LaunchMode.platformDefault);
  //     } else {
  //       Get.snackbar(
  //         'Error',
  //         'WhatsApp is not available on this device',
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //     }
  //   } catch (e) {
  //     AppDialog.showError(e.toString());
  //     print(e);
  //   }
  // }

  Future<void> openWhatsApp(String phone) async {
    try {
      final whatsappUrl = Uri.parse(
        'https://api.whatsapp.com/send?phone=$phone&text=Hello from Reside Smart',
      );
      print(whatsappUrl);
      await launchUrl(whatsappUrl);
    } catch (e) {
      AppDialog.showError(e.toString());
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final listing = viewSingleListingController.listing.value;

        if (listing == null) {
          return Center(child: CircularProgressIndicator());
        }
        print('Listing Type: ${listing.categoryId}');

        print('Listing Type: ${listing.type}');
        print('Rental Options: ${listing.rentalOptions}');
        print('Rental Options:');
        listing.rentalOptions?.forEach((option) {
          print(
            'Duration: ${option.duration} ${option.unit}, Price: \$${option.price}',
          );
        });

        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 450,
                        width: double.infinity,
                        child:
                            (listing.images != null &&
                                    listing.images!.isNotEmpty)
                                ? MyNetworkImage(
                                  url: "storage/${listing.images!.first}",
                                  fit: BoxFit.fill,
                                )
                                : Container(color: Colors.grey[200]),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 40,
                    left: 24,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ),
                  Obx(
                    () => Positioned(
                      bottom: 10,
                      left: 100,
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Column(
                            children:
                                categotyController.categories.map((category) {
                                  if (category.id == listing.categoryId) {
                                    return Text(category.name);
                                  }
                                  return SizedBox(width: 1);
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 10,
                    left: 24,
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 95, 95),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow),
                            SizedBox(width: 4),
                            Text(
                              (listing.averageReviews.toString()),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (listing.images != null && listing.images!.length > 1)
                    Positioned(
                      bottom: 10,
                      right: 24,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ListingAllImages(images: listing.images!),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 80,
                                width: 80,

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: MyNetworkImage(
                                    url: "storage/${listing.images!.last}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '+ ${listing.images!.length - 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listing.name ?? 'No name',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    listing.address ?? 'No location ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        listing.type == 'sell'
                            ? Column(
                              children: [
                                Text(
                                  listing.price?.toString() ?? 'no price',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "For ${listing.type ?? "no type available"}",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "For ${listing.type ?? "no type available"}",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Text(
                      listing.description ?? 'No discription ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 15),
                    listing.type == 'rent'
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Renting Options",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 12),

                            if (listing.rentalOptions != null &&
                                listing.rentalOptions!.isNotEmpty)
                              Wrap(
                                spacing: 9,
                                runSpacing: 9,
                                children:
                                    listing.rentalOptions!
                                        .where((option) => option.is_cancelled)
                                        .map((option) {
                                          return ChoiceChip(
                                            label: Text(
                                              '${option.duration} ${option.unit} ${option.price}',
                                            ),
                                            selected:
                                                selectedRentalOption ==
                                                option.id,
                                            onSelected: (selected) {
                                              setState(
                                                () =>
                                                    selectedRentalOption =
                                                        option.id,
                                              );
                                            },
                                            selectedColor:
                                                Theme.of(context).primaryColor,
                                            labelStyle: TextStyle(
                                              color:
                                                  selectedRentalOption ==
                                                          option.id
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                          );
                                        })
                                        .toList()
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          int index = entry.key;
                                          Widget text = entry.value;
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              text,
                                              if (index !=
                                                  listing
                                                          .rentalOptions!
                                                          .length -
                                                      1)
                                                Text(
                                                  " -",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                            ],
                                          );
                                        })
                                        .toList(),
                              )
                            else
                              Text(
                                "No rental options available.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        )
                        : Container(),

                    SizedBox(height: 24),

                    Text(
                      'Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 12),

                    if (listing.features != null &&
                        listing.features!.isNotEmpty)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            listing.features!.map((e) {
                              return Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    236,
                                    235,
                                    235,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${e['value']} ${e['key']}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                      )
                    else
                      SizedBox(),
                    SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  child:
                                      listing.user!.image != null
                                          ? viewSingleListingController
                                                  .isLoading
                                                  .value
                                              ? CircularProgressIndicator(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).primaryColor,
                                              )
                                              : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: MyNetworkImage(
                                                  url:
                                                      "storage/${listing.user!.image}",
                                                ),
                                              )
                                          : Icon(Icons.person, size: 90),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      listing.user!.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[900],
                                      ),
                                    ),

                                    Text(
                                      'Real Estate owner',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.message),
                                  onPressed: () {
                                    openWhatsApp(listing.user!.phoneNumber);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        // image: DecorationImage(
                        //   image: AssetImage('assets/map_placeholder.png'),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 6),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '2.5 km from your location',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'St. Clokilo Timur, Koc. Pancoian, Jakarta\nSclatan, Indonesia 18770',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),

                    SizedBox(height: 32),
                    Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 95, 95),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: List.generate(5, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          child: Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber[400],
                                            size: 24,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  SizedBox(width: 12),

                                  Text(
                                    listing.averageReviews.toString(),
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 0.9,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                '/view-review',
                                arguments: {'listingId': listing.id},
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),

                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),

                    authService.globalUser!.id != listing.userId
                        ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              if (listing.type == 'rent') {
                                if (selectedRentalOption == null) {
                                  AppDialog.showError(
                                    'Please choose a rental option before booking.',
                                  );
                                  return;
                                }

                                Get.offAndToNamed(
                                  '/purchase-listing',
                                  arguments: {
                                    'listing': listing,
                                    'selectedRentalOption':
                                        selectedRentalOption,
                                  },
                                );
                              } else {
                                Get.offAndToNamed(
                                  '/purchase-listing',
                                  arguments: {'listing': listing},
                                );
                              }
                            },
                            child: Text(
                              listing.type == 'rent' ? 'Book Now' : 'Buy Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
