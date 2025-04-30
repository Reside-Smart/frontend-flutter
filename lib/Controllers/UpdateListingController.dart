import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:reside_smart_flutter/Controllers/ListingFeatureController.dart';
import 'package:reside_smart_flutter/Controllers/RentPriceController.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Services/ListingService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';
import 'package:http_parser/http_parser.dart';

class UpdateListingController extends GetxController {
  final ListingService _listingservice = Get.find<ListingService>();
  int? listingId;
  ListingModel? listing;

  void setListingId(int id) {
    listingId = id;
  }

  Future<void> getSingleListing(int listingId) async {
    try {
      isLoading.value = true;

      listing = await _listingservice.getSingleListing(listingId);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> saveAsDraft({
    String? name,
    String? type,
    int? category,
    String? address,
    List<XFile>? images,
    String? price,
    List<FeatureField>? features,
    String? description,
    List<RentingOption>? rental_options,
  }) async {
    try {
      isLoading.value = true;
      fieldErrors.clear();

      dio.FormData formData = dio.FormData.fromMap({
        'name': name,
        'type': type,
        'category_id': category,
        'address': address,
        'images[]':
            // images != null && images.isNotEmpty
            //     ? await Future.wait(
            //       images.map((image) async {
            //         return await dio.MultipartFile.fromFile(
            //           image.path,
            //           filename: image.name,
            //         );
            //       }),
            //     )
            //     :
            [],
        'price': (type != null && type == "sell") ? price : null,
        'features': dio.MultipartFile.fromString(
          jsonEncode(
            features!
                .map(
                  (e) => {
                    "key": e.feature.text.trim(),
                    "value": e.number.text.trim(),
                  },
                )
                .toList(),
          ),
          contentType: MediaType('application', 'json'),
        ),

        'description': description,
        'rental_options':
            (type != null && type.toLowerCase() == "rent")
                ? dio.MultipartFile.fromString(
                  jsonEncode(
                    rental_options!
                        .map(
                          (e) => {
                            "duration": e.duration.text.trim(),
                            "unit": e.unit.value,
                            "price": e.price.text.trim(),
                          },
                        )
                        .toList(),
                  ),
                  contentType: MediaType('application', 'json'),
                )
                : null,
      });

      await _listingservice.updateAsDraft(
        listingId: listing!.id!,
        formData: formData,
      );

      AppDialog.showSuccess('Listing Updated As Draft successfully');
    } catch (e) {
      // throw e;
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> publishListing({
    required String? name,
    required String? type,
    required int? category,
    required String? address,
    required List<XFile>? images,
    required String? price,
    required List<FeatureField>? features,
    required String? description,
    required List<RentingOption>? rental_options,
  }) async {
    try {
      isLoading.value = true;
      fieldErrors.clear();
      dio.FormData formData = dio.FormData.fromMap({
        'name': name,
        'type': type,
        'category_id': category,
        'address': address,
        'images[]': // images != null && images.isNotEmpty
            //     ? await Future.wait(
            //       images.map((image) async {
            //         return await dio.MultipartFile.fromFile(
            //           image.path,
            //           filename: image.name,
            //         );
            //       }),
            //     )
            //     :
            [],
        'price': (type != null && type == "sell") ? price : null,
        'features': dio.MultipartFile.fromString(
          jsonEncode(
            features!
                .map(
                  (e) => {
                    "key": e.feature.text.trim(),
                    "value": e.number.text.trim(),
                  },
                )
                .toList(),
          ),
          contentType: MediaType('application', 'json'),
        ),

        'description': description,
        'rental_options':
            (type != null && type.toLowerCase() == "rent")
                ? dio.MultipartFile.fromString(
                  jsonEncode(
                    rental_options!
                        .map(
                          (e) => {
                            "duration": e.duration.text.trim(),
                            "unit": e.unit.value,
                            "price": e.price.text.trim(),
                          },
                        )
                        .toList(),
                  ),
                  contentType: MediaType('application', 'json'),
                )
                : null,
      });

      await _listingservice.updateAsPublished(
        listingId: listing!.id!,
        formData: formData,
      );

      AppDialog.showSuccess('Listing Updated As Published successfully');
    } catch (e) {
      // throw e;
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(e) {
    if (e.response?.statusCode == 422) {
      final errors = e.response?.data['errors'] as Map<String, dynamic>;
      errors.forEach((key, value) {
        fieldErrors[key] = value[0];
      });
    } else {
      fieldErrors['general'] =
          e.response?.data['message'] ?? 'Something went wrong.';
    }
  }
}
