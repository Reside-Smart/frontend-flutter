import 'package:reside_smart_flutter/Widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/AuthController.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Widgets/MyTitle.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>
    with GlobalFunctions {
  var isLoading = false.obs;
  final AuthController authController = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();

  late final TextEditingController emailController = TextEditingController();

  Future<void> _submitForm() async {}

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
                    MyTitle(title: 'Forget Password'),
                    const SizedBox(height: 14),
                    Center(
                      child: Text(
                        'An email will be sent for you to reset password.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      height: 40, // Responsive spacing
                    ),
                    // Name TextFormField
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Enter Email",
                        prefixIcon: const Icon(Icons.email),
                        errorText: authController.fieldErrors['full_name'],
                        // Show full name error
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    // ForgetPasswordPage Button
                    ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed('enable-gps');
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
                              : const Text("Submit"),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Already have an account? Text Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn't recieve an email? "),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {},
                          child: Text("Resend."),
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
