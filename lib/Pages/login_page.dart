// import 'dart:js';

import 'package:eazy_app/Services/auth_service.dart';
import 'package:eazy_app/sales%20part/assigned_customer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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

import 'customer_check.dart/third.dart';

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
  bool? isbusy;

  bool showError = false;
  var _text = '';
  bool isLoggedIn = false;

  bool _validate = false;

  var authInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool? _value = false;

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
    if (userRole == 'Sales Manager') {
      isbusy = userData['is_busy'];
    }

    print('>>>>>>>> is bsy >>>>>>>>>. $isbusy');
  }

  dynamic login(BuildContext context) async {
    dynamic authInfo = AuthService();

    final res = await authInfo.login(emailController.text, passController.text);
    final data = jsonDecode(res.body) as Map<String, dynamic>;

    print('========= SERVER DATE ======== ${DateTime.parse(data['expiry'])}');
    print(
        '========== DATE =========== ${DateTime.now().add(Duration(minutes: 330))}');

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

      AuthService.setExpiry(
          DateTime.now().add(Duration(seconds: 1800)).toString());

      getRole().whenComplete(() {
        if (userRole == 'Visits Manager') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ),
          );
        } else if (userRole == 'Sales Manager') {
          isbusy == true
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignedCustomer(),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Sales_Dashboard(),
                  ),
                );
        }
      });

      isLoggedIn = true;

      final pref = await SharedPreferences.getInstance();
      final log = pref.setBool('log', isLoggedIn);
      print('Logged in login page : $log');
      print(res.body);
      final token = await AuthService.getToken();

      final exp = await AuthService.getExpiry();

      print('Expiry--------------- $exp');

      return data;
    } else if (data.containsKey('non_field_errors')) {
      setState(() {
        showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics().setCurrentScreen(
      screenName: 'Login Page',
      screenClassOverride: 'Login Page',
    );
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    validateSave() {
      if (formKey.currentState!.validate()) {
      } else {}
    }

    Map mapResponse = {};

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Form(
            key: formKey,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 150,
                  left: 40,
                  child: Container(
                    child: Image.asset('images/eazyapp-logo-blue.png',
                        height: height * 0.1),
                  ),
                ),
                Positioned(
                  top: 270,
                  left: 40,
                  child: Container(
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
                ),
                Positioned(
                  top: 290,
                  left: 30,
                  child: Container(
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
                ),
                Positioned(
                  top: 420,
                  left: 30,
                  child: Container(
                    //padding : EdgeInsets.symmetric(horizontal: width*0.04),

                    child: showError
                        ? Text(
                            'Invalid username or password',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
                          )
                        : Container(),
                  ),
                ),
                Positioned(
                  top: 470,
                  right: 30,
                  child: Container(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 0, color: Colors.white),
                      ),
                      child: InkWell(
                        child: Text('Forgot Password?',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500),
                            )),
                        onTap: () =>
                            launch('https://geteazyapp.com/reset_password/'),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                Positioned(
                  top: 500,
                  left: 20,
                  right: 26,
                  child: CheckboxListTile(
                    activeColor: myColor,
                    checkColor: Colors.white,
                    title: Text('Keep me signed in',
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    value: _value,
                    onChanged: (val) async {
                      setState(() {
                        _value = val;
                      });
                      if (val == true) {
                        final pref = await SharedPreferences.getInstance();
                        pref.setString('keep_sign', 'True');
                      } else {
                        final pref = await SharedPreferences.getInstance();
                        pref.setString('keep_sign', 'False');
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 350,
                  left: 30,
                  right: 30,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      onChanged: (text) {
                        setState(() => _text);
                      },
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        fontSize: 16,
                      )),
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: MultiValidator(
                        [
                          EmailValidator(errorText: 'Enter a valid email'),
                          RequiredValidator(errorText: 'Cannot be empty'),
                        ],
                      ),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        errorStyle: GoogleFonts.poppins(
                          textStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red.shade500, width: 0.8),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: myColor),
                        ),
                        suffixIcon: Icon(Icons.email, color: myColor, size: 20),
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
                ),
                Positioned(
                  top: 410,
                  left: 30,
                  right: 30,
                  child: Container(
                    //width: width - 0.3,
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        fontSize: 16,
                      )),
                      controller: passController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: MultiValidator(
                        [
                          RequiredValidator(errorText: 'Cannot be empty'),
                        ],
                      ),
                      obscureText: isHiddenPassword,
                      decoration: InputDecoration(
                        errorStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red.shade500, width: 0.8),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
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
                        hintText: 'Password',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 560,
                  left: 30,
                  right: 30,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .3),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: myColor),
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(
                            () => isLoading = !isLoading,
                          );
                          validateSave();
                          login(context).whenComplete(() async {
                            setState(
                              () => isLoading = !isLoading,
                            );
                            final newToken = await AuthService.getToken();

                            final pref = await SharedPreferences.getInstance();
                            pref.setString('trial token', newToken.toString());
                          });
                        }

                        final pref = await SharedPreferences.getInstance();
                      },
                    ),
                  ),
                ),
              ],
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
