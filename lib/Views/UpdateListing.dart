import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reside_smart_flutter/Controllers/CategoryController.dart';
import 'package:reside_smart_flutter/Controllers/RentPriceController.dart';
import 'package:reside_smart_flutter/Controllers/UpdateListingController.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Controllers/ListingFeatureController.dart';
import 'package:reside_smart_flutter/Widgets/MyNetworkImage.dart';

class UpdateListingPage extends StatefulWidget {
  const UpdateListingPage({super.key});

  @override
  State<UpdateListingPage> createState() => _UpdateListingPageState();
}

class _UpdateListingPageState extends State<UpdateListingPage>
    with GlobalFunctions {
  final UpdateListingController updateListingController =
      Get.find<UpdateListingController>();
  final formKey = GlobalKey<FormState>();
  final categoryController = Get.put(CategoryController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<XFile> _images = [];
  final List<String> _oldImages = [];

  LatLng selectedLocation = LatLng(33.8547, 35.8623);

  Set<Marker> markers = {};
  final List<String> types = ['Rent', 'Sell'];
  String? selectedType;

  int? selectedCategory;
  late String listingStatus;
  final featureController = Get.put(FeatureController());
  final RentingOptionController rentPriceController = Get.put(
    RentingOptionController(),
  );

  GoogleMapController? mapController;
  Future<void> _addImage() async {
    final picker = ImagePicker();
    final List<XFile> pickedImages = await picker.pickMultiImage();
    setState(() {
      _images.addAll(pickedImages);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void initializeData() async {
    final listingId = Get.arguments['id'];
    updateListingController.setListingId(listingId);
    await updateListingController.getSingleListing(listingId);
    selectedLocation = LatLng(
      updateListingController.listing!.latitude!,
      updateListingController.listing!.longitude!,
    );
    listingStatus = updateListingController.listing!.status!;
    nameController.text = updateListingController.listing!.name ?? "";
    selectedCategory = updateListingController.listing!.categoryId!;
    selectedType = updateListingController.listing!.type;
    priceController.text = updateListingController.listing!.price.toString();
    addressController.text = updateListingController.listing!.address!;
    descriptionController.text =
        updateListingController.listing!.description ?? "";
    featureController.features.value =
        updateListingController.listing!.features == null
            ? <FeatureField>[]
            : updateListingController.listing!.features!.map((e) {
              var fields = FeatureField();
              fields.feature.text = e['key'];
              fields.number.text = e['value'];
              return fields;
            }).toList();
    rentPriceController.rentOptions.value =
        updateListingController.listing!.rentalOptions == null
            ? []
            : updateListingController.listing!.rentalOptions!.map((e) {
              var fields = RentingOption();
              fields.id = e.id;
              fields.duration.text = e.duration.toString();
              fields.unit.value = e.unit;
              fields.price.text = e.price.toString();
              fields.isCancelled.value = e.is_cancelled;
              return fields;
            }).toList();
    _oldImages.clear();
    if (updateListingController.listing!.images != null) {
      _oldImages.addAll(updateListingController.listing!.images!);
    }
    print('Latitude: ${updateListingController.listing!.latitude}');
    print('Longitude: ${updateListingController.listing!.longitude}');

    selectedLocation = LatLng(
      updateListingController.listing!.latitude ?? 33.8547,
      updateListingController.listing!.longitude ?? 35.8623,
    );
    markers = {
      Marker(
        markerId: MarkerId('property_location'),
        position: selectedLocation,
        infoWindow: InfoWindow(title: 'Property Location'),
      ),
    };

    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: selectedLocation, zoom: 14.0),
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'Update Listing'),
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
                      "Hello, fill the details of your Listing",
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
                        labelText: "Listing Name",
                        prefixIcon: Icon(Icons.house),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Field is required";
                        return null;
                      },
                    ),
                    SizedBox(height: 30),

                    Text(
                      "Listing Category:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => Wrap(
                        spacing: 10,
                        children:
                            categoryController.categories.map((category) {
                              return ChoiceChip(
                                label: Text(category.name),
                                selected: selectedCategory == category.id,
                                onSelected: (selected) {
                                  setState(
                                    () => selectedCategory = category.id,
                                  );
                                },
                                selectedColor: Theme.of(context).primaryColor,
                                labelStyle: TextStyle(
                                  color:
                                      selectedCategory == category.id
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Listing Type:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children:
                          types.map((type) {
                            return ChoiceChip(
                              label: Text(type),
                              selected:
                                  selectedType?.toLowerCase() ==
                                  type.toLowerCase(),
                              onSelected: (selected) {
                                setState(
                                  () => selectedType = selected ? type : null,
                                );
                              },
                              selectedColor: Theme.of(context).primaryColor,
                              labelStyle: TextStyle(
                                color:
                                    selectedType != null &&
                                            selectedType!.toLowerCase() ==
                                                type.toLowerCase()
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            );
                          }).toList(),
                    ),
                    SizedBox(height: 20),
                    if (selectedType != null &&
                        selectedType!.toLowerCase() == 'rent') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Renting Options:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              rentPriceController.addOption();
                            },
                          ),
                        ],
                      ),
                      Obx(
                        () => Column(
                          children: List.generate(
                            rentPriceController.rentOptions.length,
                            (index) {
                              final rentField =
                                  rentPriceController.rentOptions[index];
                              if (rentField.isCancelled == false ||
                                  rentField.isCancelled == 0) {
                                return SizedBox();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: rentField.duration,
                                        decoration: InputDecoration(
                                          labelText: 'Duration',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    SizedBox(width: 2),

                                    Expanded(
                                      child: Obx(
                                        () => DropdownButtonFormField<String>(
                                          value:
                                              rentField.unit.value.isEmpty
                                                  ? null
                                                  : rentField.unit.value,
                                          hint: Text("Unit"),
                                          onChanged: (value) {
                                            if (value != null) {
                                              rentField.unit.value = value;
                                            }
                                          },
                                          items:
                                              ['Day', 'Week', 'Month', 'Year']
                                                  .map(
                                                    (unit) => DropdownMenuItem(
                                                      value: unit,
                                                      child: Text(unit),
                                                    ),
                                                  )
                                                  .toList(),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 2),
                                    Expanded(
                                      child: TextFormField(
                                        controller: rentField.price,
                                        decoration: InputDecoration(
                                          labelText: 'Price',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        iconSize: 20,
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () {
                                          if (rentField.id != null) {
                                            AppDialog.showConfirm(
                                              message:
                                                  "Are you sure you want to cancel this renting option?",
                                              onConfirm: () async {
                                                bool result =
                                                    await updateListingController
                                                        .cancleOption(
                                                          rentField.id!,
                                                        );

                                                if (result) {
                                                  rentPriceController
                                                      .removeOption(index);
                                                }
                                              },
                                            );
                                          } else {
                                            rentPriceController.removeOption(
                                              index,
                                            );
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                Colors.transparent,
                                              ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 30,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        iconSize: 20,
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () {
                                          if (rentField.id != null) {
                                            AppDialog.showConfirm(
                                              message:
                                                  "Are you sure you want to edit this renting option?",
                                              onConfirm: () async {
                                                print(rentField.duration.text);
                                                print(rentField.price.text);
                                                print(rentField.unit);

                                                updateListingController
                                                    .editOption(
                                                      rentField.id!,
                                                      double.parse(
                                                        rentField.price.text,
                                                      ),
                                                      rentField.unit.value,
                                                      int.parse(
                                                        rentField.duration.text,
                                                      ),
                                                    );
                                                print(rentField.id!);
                                              },
                                            );
                                          } else {
                                            AppDialog.showConfirm(
                                              message:
                                                  "Are you sure you want to add this renting option?",
                                              onConfirm: () async {
                                                print(rentField.duration.text);
                                                print(rentField.price.text);
                                                print(rentField.unit);

                                                updateListingController
                                                    .addOption(
                                                      double.parse(
                                                        rentField.price.text,
                                                      ),
                                                      rentField.unit.value,
                                                      int.parse(
                                                        rentField.duration.text,
                                                      ),
                                                    );
                                              },
                                            );
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                Colors.transparent,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        "Price:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(
                          labelText: "Price",
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "Field is required";
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],

                    SizedBox(height: 30),
                    Text(
                      "Address:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Field is required";
                        return null;
                      },
                    ),
                    SizedBox(height: 30),

                    SizedBox(height: 30),
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
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: selectedLocation,
                            zoom: 14.0,
                          ),
                          markers: markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                          mapToolbarEnabled: true,
                          onTap: (LatLng position) {
                            setState(() {
                              selectedLocation = position;
                              markers = {
                                Marker(
                                  markerId: MarkerId('property_location'),
                                  position: position,
                                  infoWindow: InfoWindow(
                                    title:
                                        nameController.text.isEmpty
                                            ? 'Property Location'
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
                                  target: selectedLocation,
                                  zoom: 14.0,
                                ),
                              ),
                            );

                            setState(() {
                              markers = {
                                Marker(
                                  markerId: MarkerId('property_location'),
                                  position: selectedLocation,
                                  infoWindow: InfoWindow(
                                    title:
                                        nameController.text.isEmpty
                                            ? 'Property Location'
                                            : nameController.text,
                                  ),
                                ),
                              };
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap on the map to set the property location',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),

                    Text(
                      "Images:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Wrap(
                      spacing: 20.0,
                      runSpacing: 18.0,
                      children: [
                        ..._oldImages.map(
                          (url) => Stack(
                            children: [
                              Container(
                                width: 170,
                                height: 170,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: MyNetworkImage(url: 'storage/$url'),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    AppDialog.showConfirm(
                                      message:
                                          "Are you sure you want to delete this image?",
                                      onConfirm: () async {
                                        print(url);
                                        print(_oldImages);

                                        if (listingStatus == 'published' &&
                                            _oldImages.length == 1) {
                                          AppDialog.showError(
                                            'At least one image is required for published listings.',
                                          );
                                          return;
                                        }

                                        await updateListingController
                                            .deleteImage(url);

                                        setState(() => _oldImages.remove(url));

                                        print(url);
                                        print(_oldImages);
                                      },
                                    );
                                  },

                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ..._images.map(
                          (image) => Stack(
                            children: [
                              Container(
                                width: 170,
                                height: 170,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.file(
                                    File(image.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => _images.remove(image));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _addImage,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 24,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Listing Features:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            featureController.addFeature();
                          },
                        ),
                      ],
                    ),
                    Obx(
                      () => Column(
                        children: List.generate(
                          featureController.features.length,
                          (index) {
                            final item = featureController.features[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: item.feature,
                                      decoration: InputDecoration(
                                        labelText: 'Feature',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: item.number,
                                      decoration: InputDecoration(
                                        labelText: 'Number',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      featureController.removeFeature(index);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF6F6F8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: 5,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Parking lot, gym, neighbors...",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (nameController.text.trim().isEmpty) {
                              AppDialog.showError(
                                'Please enter the listing name at least.',
                              );
                              return;
                            }
                            if (selectedCategory == null) {
                              AppDialog.showError('Please select a category');
                              return;
                            }

                            print('Latitude: ${selectedLocation.latitude}');
                            print('Longitude: ${selectedLocation.longitude}');
                            updateListingController.saveAsDraft(
                              name: nameController.text.trim(),
                              address: addressController.text.trim(),
                              price: priceController.text.trim(),
                              description: descriptionController.text.trim(),
                              images: _images,
                              type: selectedType?.toLowerCase(),
                              category: selectedCategory,
                              features: featureController.features,
                              rental_options: rentPriceController.rentOptions,
                              latitude: selectedLocation.latitude,
                              longitude: selectedLocation.longitude,
                            );
                          },

                          child: Text("Save as draft"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (selectedCategory == null) {
                                AppDialog.showError('Please select a category');
                                return;
                              }
                              if (selectedType == null) {
                                AppDialog.showError('Please select a type');
                                return;
                              }
                              if (selectedType?.toLowerCase() == 'rent' &&
                                  rentPriceController.rentOptions.isEmpty) {
                                AppDialog.showError(
                                  'Please add rental options',
                                );
                                return;
                              }
                              if (_oldImages.isEmpty && _images.isEmpty) {
                                AppDialog.showError(
                                  'Please add at least one image',
                                );
                                return;
                              }

                              if (featureController.features.isEmpty) {
                                AppDialog.showError(
                                  'Please add at least one feature',
                                );
                                return;
                              }

                              if (descriptionController.text.trim().isEmpty) {
                                AppDialog.showError(
                                  'Please enter a description',
                                );
                                return;
                              }

                              updateListingController.publishListing(
                                name: nameController.text.trim(),
                                address: addressController.text.trim(),
                                price: priceController.text.trim(),
                                description: descriptionController.text.trim(),
                                images: _images,
                                type: selectedType?.toLowerCase(),
                                category: selectedCategory,
                                features: featureController.features,
                                rental_options: rentPriceController.rentOptions,
                                latitude: selectedLocation.latitude,
                                longitude: selectedLocation.longitude,
                              );
                            }
                          },
                          child: Text("Publish listing"),
                        ),
                      ],
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
