// @dart=2.9
import 'package:eazy_app/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:eazy_app/Pages/login_page.dart';
import 'package:eazy_app/Pages/splash_screen.dart';

import 'Pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(EazyApp());
}

class EazyApp extends StatelessWidget {
  clearData() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    final token = pref.getString('token');
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: AuthService.getToken(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              clearData();
              return LoginPage();//SplashScreen();
            } else {
              return LoginPage();//SplashScreen();
            }
          }),
    );
  }
}
