import 'package:flutter/services.dart';
import 'package:reside_smart_flutter/Controllers/ChangePasswordController.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> with GlobalFunctions {
  final ChangePasswordController changePasswordController =
      Get.find<ChangePasswordController>();
  final formKey = GlobalKey<FormState>();

  late final TextEditingController oldPasswordController =
      TextEditingController();
  late final TextEditingController newPasswordController =
      TextEditingController();
  late final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyMainAppBar(title: 'Change Password'),
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
                    // Title Text
                    Center(
                      child: Text(
                        "You can change your password",
                        style: TextStyle(
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: screenHeight * 0.05, // Responsive spacing
                    ),

                    TextFormField(
                      controller: oldPasswordController,
                      decoration: InputDecoration(
                        labelText: "Old Password",
                        prefixIcon: const Icon(Icons.lock),
                        errorText:
                            changePasswordController
                                .fieldErrors['old_password'],
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }

                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    TextFormField(
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        prefixIcon: const Icon(Icons.lock),
                        errorText:
                            changePasswordController
                                .fieldErrors['new_password'],
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }

                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock),
                        errorText:
                            changePasswordController.fieldErrors['confirm'],
                      ),
                      validator: (value) {
                        print(
                          "Validator - New Password: ${newPasswordController.text}",
                        );
                        print("Validator - Confirm Password: $value");
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        if (value != newPasswordController.text) {
                          return "Passwords do not match";
                        }

                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    ElevatedButton(
                      onPressed: () {
                        if (!changePasswordController.isLoading.value &&
                            formKey.currentState!.validate()) {
                          print("Old Password: ${oldPasswordController.text}");
                          print("New Password: ${newPasswordController.text}");
                          print(
                            "Confirm Password: ${confirmPasswordController.text}",
                          );

                          changePasswordController.changePassword(
                            oldPasswordController.text.trim(),
                            newPasswordController.text.trim(),
                            confirmPasswordController.text.trim(),
                          );
                        }
                      },
                      child:
                          changePasswordController.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : const Text("Change Password"),
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
