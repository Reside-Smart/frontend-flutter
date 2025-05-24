import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:reside_smart_flutter/Controllers/EditProfileController.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with GlobalFunctions {
  final EditProfileController editProfileController =
      Get.find<EditProfileController>();
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController phoneNumberController =
      TextEditingController();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController addressController = TextEditingController();

  Set<Marker> markers = {};
  GoogleMapController? mapController;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await editProfileController.picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        print(pickedFile!.path);
        editProfileController.image = XFile(pickedFile.path);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = editProfileController.authService.globalUser!.name;
    phoneNumberController.text =
        editProfileController.authService.globalUser!.phoneNumber;
    emailController.text = editProfileController.authService.globalUser!.email;
    addressController.text =
        editProfileController.authService.globalUser!.address ?? '';

    // Initialize location from user data
    editProfileController.initLocation();

    // Initialize markers
    markers = {
      Marker(
        markerId: MarkerId('user_location'),
        position: editProfileController.selectedLocation.value,
        infoWindow: InfoWindow(title: 'Your Location'),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'Edit Profile'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // Adjust horizontal padding
            vertical: screenHeight * 0.02, // Adjust vertical padding
          ),
          child: Obx(
            () => SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    SizedBox(
                      height: screenHeight * 0.05, // Responsive spacing
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 90, // Slightly larger avatar
                            height: 90,
                            child:
                                editProfileController
                                            .authService
                                            .globalUser
                                            ?.image !=
                                        null
                                    ? editProfileController.isLoading.value
                                        ? CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        )
                                        : ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          child: MyNetworkImage(
                                            url:
                                                "storage/${editProfileController.authService.globalUser?.image}",
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
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        errorText: editProfileController.fieldErrors['name'],
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: const Icon(Icons.phone),
                        errorText:
                            editProfileController.fieldErrors['phone_number'],
                        counterText: '',
                      ),
                      initialValue:
                          editProfileController
                              .authService
                              .globalUser!
                              .phoneNumber,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      initialCountryCode: 'LB',
                      onChanged: (phone) {
                        phoneNumberController.text = phone.completeNumber;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        errorText: editProfileController.fieldErrors['email'],
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        if (!GetUtils.isEmail(value)) {
                          return "Invalid email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: const Icon(Icons.location_on),
                        errorText: editProfileController.fieldErrors['address'],
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
                                  editProfileController.selectedLocation.value,
                              zoom: 14.0,
                            ),
                            markers: markers,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: true,
                            mapToolbarEnabled: true,
                            onTap: (LatLng position) {
                              setState(() {
                                editProfileController.selectedLocation.value =
                                    position;
                                markers = {
                                  Marker(
                                    markerId: MarkerId('user_location'),
                                    position: position,
                                    infoWindow: InfoWindow(
                                      title:
                                          nameController.text.isEmpty
                                              ? 'Your Location'
                                              : nameController.text,
                                    ),
                                  ),
                                };
                              });
                            },
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                              controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target:
                                        editProfileController
                                            .selectedLocation
                                            .value,
                                    zoom: 14.0,
                                  ),
                                ),
                              );
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

                    SizedBox(height: screenHeight * 0.03),
                    ElevatedButton(
                      onPressed: () async {
                        if (!editProfileController.isLoading.value &&
                            formKey.currentState!.validate()) {
                          print(
                            'Phone Number: ${phoneNumberController.text.trim()}',
                          );
                          await editProfileController.editProfile(
                            name: nameController.text.trim(),
                            phoneNumber: phoneNumberController.text.trim(),
                            email: emailController.text.trim(),
                            address: addressController.text.trim(),
                            latitude:
                                editProfileController
                                    .selectedLocation
                                    .value
                                    .latitude,
                            longitude:
                                editProfileController
                                    .selectedLocation
                                    .value
                                    .longitude,
                          );
                          setState(() {});
                        }
                      },
                      child:
                          editProfileController.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : const Text("Save"),
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
