import 'package:reside_smart_flutter/Controllers/VerifyEmailController.dart';
import 'package:reside_smart_flutter/Widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';
import 'package:reside_smart_flutter/Widgets/MyTitle.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage>
    with GlobalFunctions {
  final VerifyEmailController _verifyEmailController = VerifyEmailController();
  final formKey = GlobalKey<FormState>();

  late final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
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
                    SizedBox(height: screenHeight * 0.05),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 60,
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
                    SizedBox(height: screenHeight * 0.06),
                    // Name TextFormField
                    TextFormField(
                      controller: otpController,
                      decoration: InputDecoration(
                        labelText: "Enter Verification Code",
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        if (value.length > 6) {
                          return "Maximum 6.";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    // VerifyEmail Button
                    ElevatedButton(
                      onPressed: () {
                        if (!_verifyEmailController.isLoading.value &&
                            formKey.currentState!.validate()) {
                          _verifyEmailController.veriyfEmailUser(
                            otpController.text.trim(),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        textStyle: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                      child:
                          _verifyEmailController.isLoading.value
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't recieve an Email? ",
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed:
                              _verifyEmailController.resendCooldown.value > 0
                                  ? null
                                  : () =>
                                      _verifyEmailController
                                          .resendVerificationCode(),
                          child: Obx(
                            () => Text(
                              _verifyEmailController.resendCooldown.value > 0
                                  ? "Resend in ${_verifyEmailController.resendCooldown.value}s"
                                  : "Resend",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color:
                                    _verifyEmailController
                                                .resendCooldown
                                                .value >
                                            0
                                        ? Colors.grey
                                        : Theme.of(context).primaryColor,
                              ),
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
