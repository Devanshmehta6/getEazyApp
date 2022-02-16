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


  getData() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse('https://geteazyapp.com/dashboard_api/');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      print('============ cookie =============== $setcookie');
      http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': settoken,
          HttpHeaders.cookieHeader: setcookie,
        },
      );
      print('------------- response -------- ${response.statusCode}');

      statusCode = response.statusCode;
      print('------------- response -------- $statusCode');
      final entireJson = jsonDecode(response.body);
      final t1 = pref.getString('trial token');
      //final map = json.decode(t1);
      print('--------- t1 ----------------- $t1');
    } else {
      print('Logged out ');
    }
  }


  clearData() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    final token = pref.getString('token');
    print(token);
  }

  checkLogin() async {
    final token = await AuthService.getToken();

    if (token != null) {
      setState(() {
        currentPage = Dashboard();
      });
    }
  }

  decideCallingCheckLogin() async {
    final pref = await SharedPreferences.getInstance();
    final check = pref.getString('keep_sign');
    if (check == 'True') {
      checkLogin();
    } else if (check == 'False') {
      //AuthService.removeToken();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    decideCallingCheckLogin();
    getData();
    print('------- DATE DEVICE---------- ${DateTime.now()}');
    
    
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
                }
            )
                // future: AuthService.getToken(),
                // builder: (_, snapshot) {
                //   if (snapshot.connectionState == ConnectionState.waiting) {
                //     return CupertinoActivityIndicator();
                //   } else if (snapshot.hasData) {
                //     if (statusCode != 200) {
                //       print('-------- NOT 200 ------------');
                //     } else {
                //       print('------------ 200 ------------');
                //     }
                //     print('---------- HAS DATA ----------');
                //     // clearData();
                //     return currentPage; //SplashScreen();
                //   } else {
                //     print('=-------------- ELSE ---------');
                //     return currentPage; //SplashScreen();

          );
        });
      },
    );
  }
}
