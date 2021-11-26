// @dart=2.9
import 'package:eazy_app/Pages/customer_check.dart/fourth.dart';
import 'package:eazy_app/Pages/customer_check.dart/second.dart';
import 'package:eazy_app/Pages/customer_check.dart/third.dart';
import 'package:eazy_app/Services/analytics_service.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:eazy_app/Pages/login_page.dart';
import 'package:eazy_app/Pages/splash_screen.dart';
import 'Pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(EazyApp());
}

class EazyApp extends StatefulWidget {
  @override
  State<EazyApp> createState() => _EazyAppState();
}

class _EazyAppState extends State<EazyApp> {
  //final FirebaseAnalytics analytics = FirebaseAnalytics();
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  clearData() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    final token = pref.getString('token');
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[
        FirebaseAnalyticsObserver(analytics: analytics)
      ],
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: AuthService.getToken(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              clearData();

              return LoginPage(); //SplashScreen();
            } else {
              return LoginPage(); //SplashScreen();
            }
          }),
    );
  }
}
