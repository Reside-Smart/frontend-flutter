import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Models/UserModel.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class CompleteProfileController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  XFile? image;
  final Rx<LatLng> selectedLocation =
      LatLng(33.8547, 35.8623).obs; // Default to Lebanon

  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Ensure that we have a verified user
    if (authService.globalUser == null) {
      AppDialog.showError("User session expired. Please sign in again.");
      Get.offAllNamed('/signIn');
    }
  }

  Future<void> completeprofile({
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      if (address.isEmpty) {
        fieldErrors['address'] = 'Address is required';
        return;
      }

      isLoading.value = true;
      fieldErrors.clear();

      final form = dio.FormData.fromMap({
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        if (image != null)
          'image': await dio.MultipartFile.fromFile(
            image!.path,
            filename: image!.path.split('/').last,
          ),
      });

      final UserModel user = await authService.completeprofile(form: form);
      authService.globalUser?.address = user.address;
      authService.globalUser?.latitude = user.latitude;
      authService.globalUser?.longitude = user.longitude;
      authService.globalUser?.image = user.image;

      AppDialog.showSuccess("Profile completed successfully");
      // Small delay to ensure the user sees the success message
      await Future.delayed(Duration(milliseconds: 800));
      Get.offAllNamed('navbar');
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(e) {
    try {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        errors.forEach((key, value) {
          fieldErrors[key] = value[0];
        });
        AppDialog.showError(fieldErrors.values.first);
      } else {
        fieldErrors['general'] =
            e.response?.data['message'] ??
            'Failed to complete profile. Please try again.';
        AppDialog.showError(
          fieldErrors['general'] ?? 'Profile completion failed',
        );
      }
    } catch (_) {
      fieldErrors['general'] =
          'Unexpected error occurred. Please check your connection.';
      AppDialog.showError(
        fieldErrors['general'] ?? 'Profile completion failed',
      );
    }
  }
}
