import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment/login.dart';
import 'package:payment/stripe_payment/stripe_keys.dart';

void main() {
  Stripe.publishableKey = StripeKeys.publishedkey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(appBarTheme: const AppBarTheme(centerTitle: true)),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
