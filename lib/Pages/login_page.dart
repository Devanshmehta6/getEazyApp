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

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    bool isLoggedIn = false;

    var authInfo;

    dynamic login(BuildContext context) async {
      authInfo = AuthService();

      final res =
          await authInfo.login(emailController.text, passController.text);
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final headers = res.headers.toString();
      final str = headers;
      final start = 'sessionid=';
      final end = '; expires=';
      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);
      final id = str.substring(startIndex + start.length, endIndex);
      await FlutterSession().set('session', id);

      if (res.statusCode != 200) {
        print('error! inside login page');
        
      } else {
        AuthService.setToken(
          data['token'],
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );

        isLoggedIn = true;

        final pref = await SharedPreferences.getInstance();
        final log = pref.setBool('log', isLoggedIn);
        print('Logged in login page : $log');
        print(res.body);
        final token = await AuthService.getToken();
        print('Token ${token['token']}');

        return data;
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
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey.shade100),
                                  ),
                                ),
                                child: TextFormField(
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    fontSize: 16,
                                  )),
                                  controller: emailController,
                                  autovalidate: true,
                                  validator: EmailValidator(
                                      errorText: 'Invalid Email'),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
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
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade100))),
                                child: TextFormField(
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    fontSize: 16,
                                  )),
                                  controller: passController,
                                  autovalidate: true,
                                  obscureText: isHiddenPassword,
                                  decoration: InputDecoration(
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
                                  child: Text('Forgot Password?',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500),
                                      )),
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
                                      () => isLoading = false,
                                    );
                                    login(context);

                                    setState(
                                      () => isLoading = false,
                                    );
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
