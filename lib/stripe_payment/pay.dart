// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment/stripe_payment/stripe_keys.dart';

abstract class PayManager {
  static Future<void> makeStripePayment(int amount, String currency) async {
    try {
      final dio = Dio();

      const secretKey = StripeKeys.secretkey;

      final response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'amount': (amount * 100),
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );

      final clientSecret = response.data['client_secret'];

      // 2. Initialize PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'MedicineApp',
        ),
      );

      // 3. Present PaymentSheet
      await Stripe.instance.presentPaymentSheet();

      print('✅ Payment Successful!');
    } catch (e) {
      print('❌ Payment failed: $e');
    }
  }
}
