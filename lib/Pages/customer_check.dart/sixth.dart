import 'dart:io';
import 'package:camera_camera/camera_camera.dart';

import 'package:eazy_app/Pages/dashboard.dart';
import 'package:eazy_app/Pages/eazy_visits.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SixthPage extends StatefulWidget {
  const SixthPage({Key? key}) : super(key: key);

  @override
  _SixthPageState createState() => _SixthPageState();
}

class _SixthPageState extends State<SixthPage> {
  bool isLoading = false;
  File? camFile;

  Future<http.StreamedResponse> patchImage(String filepath) async {
    final pref = await SharedPreferences.getInstance();
    final project_url = pref.getString('project_url');
    final cust_url = pref.getString('customer_url');

    final url = "https://geteazyapp.com/projects/$project_url/$cust_url/api";
    print('URL IN FIFTH PAGE -------------- $url');

    String sessionId = await FlutterSession().get('session');
    String csrf = await FlutterSession().get('csrf');
    String? authorization = pref.getString('token');
    String? tokenn = authorization;
    final cookie = pref.getString('cookie');
    final token = await AuthService.getToken();
    final settoken = 'Token ${token['token']}';
    final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
    final cust_id = pref.getInt('cust_id');
    final mobile = pref.getString('mobile');
    final project_id = pref.getString('pro_id');

    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("pic", filepath));
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': settoken,
      HttpHeaders.cookieHeader: setcookie,
    });
    request.fields['project'] = project_id;
    request.fields['customer'] = '$cust_id';
    request.fields['mobile'] = mobile;

    var response = request.send();

    return response;
  }

  moveTopreviousScreen() {
    print('----------- is called-----------');
    Navigator.pop(
      context,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics().setCurrentScreen(
      screenName: 'Customer Check In Page 5',
      screenClassOverride: 'Customer Check In Page 5',
    );
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    final File? displayImage =
        ModalRoute.of(context)!.settings.arguments as File?;

    print('>>>>>>>>>>>>>>>>>... ${displayImage!.path}');

    return WillPopScope(
      onWillPop: () {
        return moveTopreviousScreen();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner:false,
        home: Scaffold(
          bottomNavigationBar: Container(
            height: height * 0.1,
            margin: EdgeInsets.only(top: 2),
            child: SafeArea(
              child: Row(children: [
                Container(
                  margin: EdgeInsets.only(top: height * 0.031),
                  width: width * 0.50,
                  child: SizedBox(
                    height: height * 0.06,
                    child: FlatButton(
                      color: Colors.white,
                      onPressed: () async {
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CameraCamera(
                                  onFile: (file) {
                                    camFile = file;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SixthPage(),
                                        settings:
                                            RouteSettings(arguments: camFile),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                      },
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
                              'Back',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              ),
                            ),
                    ),
                  ),
                ),
                Container(
                  //height: height * 0.01,
                  margin: EdgeInsets.only(top: height * 0.031),
                  height: height * 0.12,
                  width: width * 0.50,
                  child: SizedBox(
                    child: FlatButton(
                      height: 300,
                      color: myColor,
                      onPressed: () async {
                        patchImage(displayImage.path).whenComplete(
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EazyVisits(),
                                maintainState: true),
                          ),
                        );
                      },
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
                              'Next',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                            ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          body: Container(
            //margin: EdgeInsets.only(top: height * 0.01),
            padding: EdgeInsets.only(top: height * 0.07),
            height: height * 2.2,
            width: width*2,
            //width: double.infinity,
            child: Image.file(
              File(displayImage.path),
            ),
          ),
        ),
      ),
    );
  }
}
