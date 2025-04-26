import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reside_smart_flutter/Controllers/CategoryController.dart';
import 'package:reside_smart_flutter/Controllers/RentPriceController.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Controllers/ListingFeatureController.dart';
import 'package:reside_smart_flutter/Controllers/AddListingController.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({super.key});

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> with GlobalFunctions {
  final AddListingController addListingController =
      Get.find<AddListingController>();
  final formKey = GlobalKey<FormState>();
  final categotyController = Get.put(CategoryController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<XFile> _images = [];

  final List<String> types = ['Rent', 'Sell'];
  String? selectedType;

  final List<String> categories = ['Apartment', 'House', 'Chalet', 'Villa'];
  int? selectedCategory;

  final featureController = Get.put(FeatureController());
  // final rentPriceController = Get.put(RentPriceController());
  final RentingOptionController rentPriceController = Get.put(
    RentingOptionController(),
  );

  final List<String> units = ['day', 'week', 'month', 'year'];

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'Add Listing'),
      body: SafeArea(
        child: SingleChildScrollView(
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

                // Name
                Text(
                  "Name:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

                // Category Chips
                Text(
                  "Listing Category:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Obx(
                  () => Wrap(
                    spacing: 10,
                    children:
                        categotyController.categories.map((category) {
                          return ChoiceChip(
                            label: Text(category.name),
                            selected: selectedCategory == category.id,
                            onSelected: (selected) {
                              setState(() => selectedCategory = category.id);
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children:
                      types.map((type) {
                        return ChoiceChip(
                          label: Text(type),
                          selected: selectedType == type,
                          onSelected: (selected) {
                            setState(
                              () => selectedType = selected ? type : null,
                            );
                          },
                          selectedColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            color:
                                selectedType == type
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        );
                      }).toList(),
                ),
                SizedBox(height: 20),
                if (selectedType == 'Rent') ...[
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                // Duration
                                Expanded(
                                  child: TextFormField(
                                    controller: rentField.duration,
                                    decoration: InputDecoration(
                                      labelText: 'Duration',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(width: 8),

                                // Unit (Dropdown)
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
                                SizedBox(width: 8),

                                // Price
                                Expanded(
                                  child: TextFormField(
                                    controller: rentField.price,
                                    decoration: InputDecoration(
                                      labelText: 'Price',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),

                                // Delete Button
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    rentPriceController.removeOption(index);
                                  },
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  ),
                ],

                SizedBox(height: 30),
                Text(
                  "Address:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

                // Images
                Text(
                  "Add Images:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8.0),
                Wrap(
                  spacing: 20.0,
                  runSpacing: 18.0,
                  children: [
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
                          child: Icon(Icons.add, size: 24, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),

                // Price
                SizedBox(height: 10),

                // Listing Features
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
                    children: List.generate(featureController.features.length, (
                      index,
                    ) {
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
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 30),

                // Description
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

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (selectedCategory == null) {
                          AppDialog.showError('Please select a category');
                          return;
                        }
                        addListingController.saveAsDraft(
                          name: nameController.text.trim(),
                          address: addressController.text.trim(),
                          price: priceController.text.trim(),
                          description: descriptionController.text.trim(),
                          images: _images,
                          type: selectedType?.toLowerCase(),
                          category: selectedCategory,
                          features: featureController.features,
                          rental_options: rentPriceController.rentOptions,
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
                            AppDialog.showError('Please add rental options');
                            return;
                          }
                          if (_images.isEmpty) {
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
                            AppDialog.showError('Please enter a description');
                            return;
                          }

                          addListingController.publishListing(
                            name: nameController.text.trim(),
                            address: addressController.text.trim(),
                            price: priceController.text.trim(),
                            description: descriptionController.text.trim(),
                            images: _images,
                            type: selectedType?.toLowerCase(),
                            category: selectedCategory,
                            features: featureController.features,
                            rental_options: rentPriceController.rentOptions,
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
      ),
    );
  }
}
