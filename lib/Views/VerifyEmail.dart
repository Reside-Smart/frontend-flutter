import 'package:reside_smart_flutter/Widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/AuthController.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Widgets/MyTitle.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage>
    with GlobalFunctions {
  var isLoading = false.obs;
  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  late final TextEditingController verificationCodeController =
      TextEditingController();

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
                    MyTitle(title: "Verification"),
                    const SizedBox(height: 14),
                    Center(
                      child: Text(
                        'An email will be sent for you to verify your email.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05, // Responsive spacing
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 60, // Adjust radius as needed
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.lock,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.06, // Responsive spacing
                    ),
                    // Name TextFormField
                    TextFormField(
                      controller: verificationCodeController,

                      decoration: InputDecoration(
                        labelText: "Enter Verification Code",
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
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
                    SizedBox(height: screenHeight * 0.04),
                    // VerifyEmail Button
                    ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed('user-selection');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        textStyle: TextStyle(fontSize: screenWidth * 0.045),
                      ),
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
                        Text(
                          "Didn't recieve an Email? ",
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
