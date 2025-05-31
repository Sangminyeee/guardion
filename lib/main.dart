import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'housing_detail_page.dart';
import 'alert_detail_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/housingDetail': (context) => const HousingDetailPage(),
        '/alertDetail': (context) => const AlertDetailPage(),
      },
    ),
  );
}
