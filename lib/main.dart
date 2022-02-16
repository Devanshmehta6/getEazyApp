// @dart=2.9
import 'dart:io';
import 'package:eazy_app/Pages/eazy_visits.dart';
import 'package:eazy_app/sales%20part/sales_dashboard.dart';
import 'package:intl/intl.dart';
import 'package:eazy_app/Pages/customer_check.dart/fourth.dart';
import 'package:eazy_app/Pages/customer_check.dart/second.dart';
import 'package:eazy_app/Pages/customer_check.dart/third.dart';
import 'package:eazy_app/Services/analytics_service.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eazy_app/Pages/login_page.dart';
import 'package:eazy_app/Pages/splash_screen.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:path/path.dart';
import 'Pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  Widget currentPage = LoginPage();
  int statusCode = 0;

  clearData() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    final token = pref.getString('token');
    print(token);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          return MaterialApp(
            navigatorObservers: <NavigatorObserver>[
              FirebaseAnalyticsObserver(analytics: analytics)
            ],
            debugShowCheckedModeBanner: false,
            home: FutureBuilder(
                future: AuthService.checkValidation(),
                builder: (_, snapshot) {
                  print('------ RETURNED ------ ${snapshot.data}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CupertinoActivityIndicator();
                  } else if (snapshot.hasData) {
                    return Dashboard(); //Previous screen;
                  } else {
                    return LoginPage(); //Login Page;
                  }
                }),
          );
        });
      },
    );
  }
}
