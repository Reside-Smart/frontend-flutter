import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Models/UserModel.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class EditProfileController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  XFile? image;
  final Rx<LatLng> selectedLocation =
      LatLng(33.8547, 35.8623).obs; // Default to Lebanon

  final ImagePicker picker = ImagePicker();

  void initLocation() {
    if (authService.globalUser?.latitude != null &&
        authService.globalUser?.longitude != null) {
      selectedLocation.value = LatLng(
        authService.globalUser!.latitude!,
        authService.globalUser!.longitude!,
      );
    }
  }

  Future<void> editProfile({
    required String name,
    required String phoneNumber,
    required String email,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoading.value = true;
      fieldErrors.clear();

      print(' Phone Number in EditProfileController: $phoneNumber');
      final form = dio.FormData.fromMap({
        'name': name,
        'phone_number': phoneNumber,
        'email': email,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        if (image != null)
          'image': await dio.MultipartFile.fromFile(
            image!.path,
            filename: image!.path.split('/').last,
          ),
      });

      final UserModel user = await authService.editProfile(form: form);
      authService.globalUser?.name = user.name;
      authService.globalUser?.email = user.email;
      authService.globalUser?.phoneNumber = user.phoneNumber;
      authService.globalUser?.address = user.address;
      authService.globalUser?.latitude = user.latitude;
      authService.globalUser?.longitude = user.longitude;
      authService.globalUser?.image = user.image;

      AppDialog.showSuccess("Profile updated successfully");
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
      } else {
        fieldErrors['general'] =
            e.response?.data['message'] ?? 'Something went wrong.';
      }
    } catch (_) {
      fieldErrors['general'] = 'Unexpected error occurred.';
    }
  }
}
