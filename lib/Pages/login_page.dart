// import 'dart:js';

import 'package:eazy_app/Services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:eazy_app/Services/api.dart';
import 'package:eazy_app/Pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_session/flutter_session.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:eazy_app/sales part/sales_dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Color myColor = Color(0xff4044fc);
  bool isLoading = false;
  bool isHiddenPassword = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String? userRole;

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    bool isLoggedIn = false;
    bool _validate = false;
    var authInfo;

    validateSave() {
      if (formKey.currentState!.validate()) {
      } else {}
    }

    getRole() async {
      Uri url = Uri.parse('https://geteazyapp.com/api/user-role/');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();
      String? authorization = sp.getString('token');
      String? tokenn = authorization;
      final cookie = sp.getString('cookie');
      final token = await AuthService.getToken();
      final settoken = 'Token ${token['token']}';

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      });

      print('RESPONSE BODY USER ROLE : ${response.body}');
      final userData = jsonDecode(response.body);
      userRole = userData['user_role'];
      print('========== $userRole');
      print('-------USER ----------- ${userData['user_role']}');
    }

    dynamic login(BuildContext context) async {
      authInfo = AuthService();

      final res =
          await authInfo.login(emailController.text, passController.text);
      final data = jsonDecode(res.body) as Map<String, dynamic>;

      if (data.containsKey('token')) {
        final headers = res.headers.toString();
        final str = headers;
        final start = 'sessionid=';
        final end = '; expires=';
        final startIndex = str.indexOf(start);
        final endIndex = str.indexOf(end, startIndex + start.length);
        final id = str.substring(startIndex + start.length, endIndex);
        await FlutterSession().set('session', id);
        final str1 = headers;
        final start1 = 'set-cookie: ';
        final end1 = '; expires=';
        final startIndex1 = str1.indexOf(start1);
        final endIndex1 = str1.indexOf(end1, startIndex1 + start1.length);
        final csrf = str1.substring(startIndex1 + start1.length, endIndex1);
        await FlutterSession().set('csrf', csrf);

        AuthService.setToken(data['token']);

        getRole().whenComplete(() {
          if (userRole == 'Visits Manager') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          } else if (userRole == 'Sales Manager') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Sales_Dashboard()),
            );
          }
        });

        isLoggedIn = true;

        final pref = await SharedPreferences.getInstance();
        final log = pref.setBool('log', isLoggedIn);
        print('Logged in login page : $log');
        print(res.body);
        final token = await AuthService.getToken();
        print('Token ${token['token']}');

        return data;
      } else if (data.containsKey('non_field_errors')) {
        print('-------------- ELSE IF ---------------');
      }
    }

    Map mapResponse = {};

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                      // margin : EdgeInsets.only(top :150 , right : 230) ,
                      padding: EdgeInsets.only(top: height * 0.15, right: 230),
                      child: Image.asset('images/eazyapp-logo-blue.png',
                          height: height * 0.1)),
                  Container(
                    margin: EdgeInsets.only(top: 50, right: 140),
                    // color: Colors.red,
                    child: Text(
                      'Welcome back!',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.001),
                  Container(
                    margin: EdgeInsets.only(top: 2, right: 138),
                    child: Text(
                      'Please Login to continue',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50, left: 18, right: 18),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: width - 0.3,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    fontSize: 16,
                                  )),
                                  controller: emailController,
                                  validator: (val) => val!.length == 0
                                      ? "Cannot be empty"
                                      : null,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    errorStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red.shade200),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: myColor),
                                    ),
                                    suffixIcon: Icon(Icons.email,
                                        color: myColor, size: 20),
                                    border: InputBorder.none,
                                    hintText: 'Email',
                                    hintStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          color: Colors.grey.shade700),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.025),
                              Container(
                                width: width - 0.3,
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    fontSize: 16,
                                  )),
                                  controller: passController,
                                  validator: (val) => val!.length == 0
                                      ? "Cannot be empty"
                                      : null,
                                  obscureText: isHiddenPassword,
                                  decoration: InputDecoration(
                                    errorStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red.shade200),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: myColor),
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: _togglePass,
                                      child: Icon(
                                          isHiddenPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: myColor,
                                          size: 20),
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    hintStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          color: Colors.grey.shade700),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.001),
                              Container(
                                margin: EdgeInsets.only(left: 190),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        width: 0, color: Colors.white),
                                  ),
                                  child: InkWell(
                                    child: Text('Forgot Password?',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    onTap: () => launch(
                                        'https://geteazyapp.com/reset_password/'),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(height: height * 0.04),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .3),
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                ),
                                height: height * 0.05,
                                width: width * 0.87,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: myColor),
                                  child: isLoading
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 24),
                                            Text(
                                              'Please Wait',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Text(
                                          'Login',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                  onPressed: () {
                                    setState(
                                      () => isLoading = !isLoading,
                                    );
                                    validateSave();
                                    login(context).whenComplete(() {
                                      setState(
                                        () => isLoading = !isLoading,
                                      );
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePass() {
    isHiddenPassword = !isHiddenPassword;
    setState(() {});
  }
}
