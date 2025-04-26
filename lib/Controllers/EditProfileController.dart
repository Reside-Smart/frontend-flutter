import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Models/UserModel.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class EditProfileController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  XFile? image;

  final ImagePicker picker = ImagePicker();

  Future<void> editProfile({
    required String name,
    required String phoneNumber,
    required String email,
    required String address,
  }) async {
    try {
      isLoading.value = true;
      fieldErrors.clear();

      final form = dio.FormData.fromMap({
        'name': name,
        'phoneNumber': phoneNumber,
        'email': email,
        'address': address,
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
