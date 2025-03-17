import 'package:reside_smart_flutter/Widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/AuthController.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Widgets/MyTitle.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with GlobalFunctions {
  var isLoading = false.obs;
  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  late final TextEditingController fullNameController = TextEditingController();
  late final TextEditingController phoneNumberController =
      TextEditingController();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  late final TextEditingController passwordConfirmationController =
      TextEditingController();

  Future<void> _submitForm() async {
    // if (isLoading.value) return;

    // final isValid = formKey.currentState!.validate();
    // if (!isValid) {
    //   return;
    // }
    // isLoading = true.obs;
    // final isSuccess = await authController.signUp(
    //   fullNameController.text.trim(),
    //   phoneNumberController.text.trim(),
    //   emailController.text.trim(),
    //   passwordController.text.trim(),
    //   passwordConfirmationController.text.trim(),
    // );
    // isLoading = false.obs;
    // if (isSuccess) {
    //   Get.toNamed('home');
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(),
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
                    const SizedBox(height: 12),
                    MyTitle(title: "Create an Account"),
                    SizedBox(
                      height: screenHeight * 0.05, // Responsive spacing
                    ),
                    // Name TextFormField
                    TextFormField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        // Show full name error
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Username TextFormField
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Email TextFormField
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
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
                    // Password TextFormField
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        if (passwordConfirmationController.text
                                .trim()
                                .isNotEmpty &&
                            value !=
                                passwordConfirmationController.text.trim()) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Password Confirmation TextFormField
                    TextFormField(
                      controller: passwordConfirmationController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock),
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

                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('verifyEmail');
                      },
                      child:
                          isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : const Text("Sign Up"),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Already have an account? Text Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontSize: 16, // Responsive font size
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            Get.offAndToNamed('/signIn');
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16, // Responsive font size
                            ),
                          ),
                        ),
                      ],
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
