import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reside_smart_flutter/Controllers/CompleteProfileController.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Completeprofile extends StatefulWidget {
  const Completeprofile({super.key});

  @override
  State<Completeprofile> createState() => _CompleteprofileState();
}

class _CompleteprofileState extends State<Completeprofile>
    with GlobalFunctions {
  final CompleteProfileController completeProfileController =
      Get.find<CompleteProfileController>();
  final formKey = GlobalKey<FormState>();
  late final TextEditingController addressController = TextEditingController();

  Set<Marker> markers = {};
  GoogleMapController? mapController;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await completeProfileController.picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        print(pickedFile!.path);
        completeProfileController.image = XFile(pickedFile.path);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize markers
    markers = {
      Marker(
        markerId: MarkerId('user_location'),
        position: completeProfileController.selectedLocation.value,
        infoWindow: InfoWindow(title: 'Your Location'),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'Complete Profile'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Obx(
            () => SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 90, // Slightly larger avatar
                            height: 90,
                            child:
                                completeProfileController
                                            .authService
                                            .globalUser
                                            ?.image !=
                                        null
                                    ? completeProfileController.isLoading.value
                                        ? CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        )
                                        : ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          child: MyNetworkImage(
                                            url:
                                                "storage/${completeProfileController.authService.globalUser?.image}",
                                          ),
                                        )
                                    : Icon(Icons.person, size: 90),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -12,
                            child: ElevatedButton(
                              onPressed: _pickImage,
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding:
                                    EdgeInsets.zero, // remove default padding
                              ),
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // 🏠 Address Field
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: const Icon(Icons.location_on),
                        errorText:
                            completeProfileController.fieldErrors['address'],
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "Location:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Obx(
                          () => GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target:
                                  completeProfileController
                                      .selectedLocation
                                      .value,
                              zoom: 14.0,
                            ),
                            markers: markers,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: true,
                            mapToolbarEnabled: true,
                            onTap: (LatLng position) {
                              setState(() {
                                completeProfileController
                                    .selectedLocation
                                    .value = position;
                                markers = {
                                  Marker(
                                    markerId: MarkerId('user_location'),
                                    position: position,
                                    infoWindow: InfoWindow(
                                      title: 'Your Location',
                                    ),
                                  ),
                                };
                              });
                            },
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap on the map to set your location',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),

                    SizedBox(height: screenHeight * 0.06),

                    // ✅ Submit Button
                    ElevatedButton(
                      onPressed: () {
                        if (!completeProfileController.isLoading.value &&
                            formKey.currentState!.validate()) {
                          completeProfileController.completeprofile(
                            address: addressController.text.trim(),
                            latitude:
                                completeProfileController
                                    .selectedLocation
                                    .value
                                    .latitude,
                            longitude:
                                completeProfileController
                                    .selectedLocation
                                    .value
                                    .longitude,
                          );
                        }
                      },
                      child:
                          completeProfileController.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : const Text("Complete Profile"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
