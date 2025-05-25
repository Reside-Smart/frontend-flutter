import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class StripeService {
  // Get publishable key from environment
  String get _publishableKey => dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

  // Create payment sheet directly in Flutter
  Future<PaymentResult> makePayment({
    required String productName,
    required double amount,
    required String currency,
    required String email,
  }) async {
    try {
      // 1. Create payment intent on Stripe directly
      final paymentIntentData = await _createPaymentIntent(
        amount: amount,
        currency: currency,
        email: email,
        description: 'Payment for $productName',
      );

      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Reside Smart',
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
          customerId: paymentIntentData['customer'],
          style: ThemeMode.system,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: const Color(0xFF25B4F8),
            ),
          ),
          billingDetails: BillingDetails(email: email),
        ),
      );

      // 3. Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();

      // 4. Payment successful
      return PaymentResult(
        status: PaymentStatus.success,
        message: 'Payment successful',
        paymentIntentId: paymentIntentData['id'],
      );
    } catch (e) {
      if (e is StripeException) {
        return PaymentResult(
          status: PaymentStatus.failed,
          message: e.error.localizedMessage ?? 'Payment failed',
        );
      } else {
        return PaymentResult(
          status: PaymentStatus.failed,
          message: 'An unexpected error occurred: ${e.toString()}',
        );
      }
    }
  }

  // Create a payment intent directly with Stripe API
  Future<Map<String, dynamic>> _createPaymentIntent({
    required double amount,
    required String currency,
    required String email,
    required String description,
  }) async {
    // This secret key should be stored securely on your server
    // For demo purposes only - NEVER include your secret key in app code
    final String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';

    final Map<String, dynamic> body = {
      'amount': (amount * 100).toInt().toString(),
      'currency': currency,
      'payment_method_types[]': 'card',
      'description': description,
      'receipt_email': email,
    };

    // Create a customer first
    final customerResponse = await http.post(
      Uri.parse('https://api.stripe.com/v1/customers'),
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'email': email},
    );

    final customerData = json.decode(customerResponse.body);
    final String customerId = customerData['id'];

    // Create ephemeral key
    final ephemeralKeyResponse = await http.post(
      Uri.parse('https://api.stripe.com/v1/ephemeral_keys'),
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Stripe-Version': '2020-08-27',
      },
      body: {'customer': customerId},
    );

    final ephemeralKeyData = json.decode(ephemeralKeyResponse.body);

    // Create payment intent
    final paymentIntentResponse = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {...body, 'customer': customerId},
    );

    final paymentIntentData = json.decode(paymentIntentResponse.body);

    return {
      'id': paymentIntentData['id'],
      'client_secret': paymentIntentData['client_secret'],
      'ephemeralKey': ephemeralKeyData['secret'],
      'customer': customerId,
    };
  }
}

enum PaymentStatus { success, failed, canceled }

class PaymentResult {
  final PaymentStatus status;
  final String message;
  final String? paymentIntentId;

  PaymentResult({
    required this.status,
    required this.message,
    this.paymentIntentId,
  });
}
