import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:reside_smart_flutter/Controllers/SignUpController.dart';
import 'package:reside_smart_flutter/Widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Widgets/MyTitle.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with GlobalFunctions {
  final SignUpController signUpController = Get.find<SignUpController>();
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController phoneNumberController =
      TextEditingController();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  late final TextEditingController passwordConfirmationController =
      TextEditingController();

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
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        errorText: signUpController.fieldErrors['name'],
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
                    IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: const Icon(Icons.phone),
                        errorText: signUpController.fieldErrors['phone_number'],
                        counterText: '',
                      ),
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      initialCountryCode: 'LB',
                      onChanged: (phone) {
                        phoneNumberController.text = phone.completeNumber;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Email TextFormField
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        errorText: signUpController.fieldErrors['email'],
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
                        errorText: signUpController.fieldErrors['password'],
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
                        if (passwordController.text.trim().isNotEmpty &&
                            value != passwordController.text.trim()) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    ElevatedButton(
                      onPressed: () {
                        if (!signUpController.isLoading.value &&
                            formKey.currentState!.validate()) {
                          signUpController.registerUser(
                            nameController.text.trim(),
                            emailController.text.trim(),
                            phoneNumberController.text.trim(),
                            passwordController.text.trim(),
                            passwordConfirmationController.text.trim(),
                          );
                        }
                      },
                      child:
                          signUpController.isLoading.value
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
