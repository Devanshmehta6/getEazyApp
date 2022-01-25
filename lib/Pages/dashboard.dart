import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eazy_app/Pages/drawer_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eazy_app/Services/auth_service.dart';

import 'appbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Color myColor = Color(0xff4044fc);
  Map mapResponse = {};
  late String token;
  late String settoken;
  late String id;

  Future getData() async {
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
      http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': settoken,
          HttpHeaders.cookieHeader: setcookie,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          mapResponse = json.decode(response.body);
        });
      }

      final entireJson = jsonDecode(response.body);
    } else {
      print('Logged out ');
    }
  }

  late Future getallData;

  getUser() async {
    await getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getallData = getUser();
  }

  //FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics().setCurrentScreen(
      screenName: 'Visit Manager Dashboard',
      screenClassOverride: 'Visit Manager Dashboard',
    );
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxHeight > height) {
        print('Larger than 600');
      } else {
        print('Smaller than 600');
      }
      return WillPopScope(
        onWillPop: () async => false,
        child: MaterialApp(
          //navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            endDrawer: NavigationDrawerWidget(),
            appBar: AppBar(
              iconTheme: IconThemeData(color: myColor),
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: Container(
                margin: EdgeInsets.only(left: 10),
                child: Image.asset(
                  'images/eazyapp-logo-blue.png',
                  height: 48,
                  width: 40,
                ),
              ),
              title: Text(
                'EazyDashboard',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: myColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            body: Container(
              child: FutureBuilder(
                  future: getallData,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('none');
                      case ConnectionState.active:
                        return Text('active');
                      case ConnectionState.waiting:
                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      case ConnectionState.done:
                        return Stack(
                          children: <Widget>[
                            Positioned(
                              top: height * 0.02,
                              right: 5,
                              left: 5,
                              child: Total(context),
                            ),
                            Positioned(
                              top: height * 0.35,
                              right: 5,
                              left: 5,
                              child: Direct(context),
                            ),
                            Positioned(
                              top: height * 0.675,
                              right: 5,
                              left: 5,
                              child: CP(context),
                            ),
                          ],
                        );
                    }
                  }),
            ),
          ),
        ),
      );
    });
  }

  Widget Total(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    print('------------ width =========== $width');
    //sabKuch();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xff007bff)),
      height: height * 0.3,
      width: width,
      //color: Colors.blue.shade300,
      //margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.only(left: 20, top: 15),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            child: Text(
              'Total Visits',
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Positioned(
            top: 60,
            child: Text(
              DateFormat("EEEE").format(
                    DateTime.now(),
                  ) +
                  ' , ' +
                  DateFormat("dd-MM-yyyy").format(
                    DateTime.now(),
                  ),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          //SizedBox(width : 50),
          //SizedBox(height: height * 0.02),
          mapResponse != null
              ? Positioned(
                  top: 100,
                  child: Text(
                    mapResponse['dashboard_statistics']['total_customers']
                        .toString(), //"$total_customers",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 60,
                      ),
                    ),
                  ),
                )
              : CupertinoActivityIndicator(),

          Positioned(
            top: 27,
            right: 45,
            child: Container(
              // padding : EdgeInsets.only(bottom: 20),
              margin: EdgeInsets.only(bottom: 25),
              child: Icon(FontAwesomeIcons.users,
                  size: 120, color: Color(0xffffff).withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget Direct(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    //sabKuch();
    return Container(
      height: height * 0.3,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xff28a745)),
      padding: EdgeInsets.only(left: 20, top: 15),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            child: Text(
              'Direct Visits',
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Positioned(
            top: 60,
            child: Text(
              DateFormat("EEEE").format(
                    DateTime.now(),
                  ) +
                  ' , ' +
                  DateFormat("dd-MM-yyyy").format(
                    DateTime.now(),
                  ),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          //SizedBox(width : 50),
          SizedBox(height: height * 0.02),
          mapResponse != null
              ? Positioned(
                  top: 100,
                  child: Text(
                    mapResponse['dashboard_statistics']['direct_customers']
                        .toString(), //"$total_customers",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 60,
                      ),
                    ),
                  ),
                )
              : CupertinoActivityIndicator(),

          Positioned(
            top: 27,
            right: 20,
            child: Container(
              // padding : EdgeInsets.only(bottom: 20),
              margin: EdgeInsets.only(bottom: 25),
              child: Icon(
                FontAwesomeIcons.solidUser,
                size: 120,
                color: Color(0xffffff).withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CP(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    //sabKuch();
    return Container(
      height: height * 0.3,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xffdc3545)),
      padding: EdgeInsets.only(left: 20, top: 15),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            child: Text(
              'CP Visits',
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Positioned(
            top: 60,
            child: Text(
              DateFormat("EEEE").format(
                    DateTime.now(),
                  ) +
                  ' , ' +
                  DateFormat("dd-MM-yyyy").format(
                    DateTime.now(),
                  ),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          //SizedBox(width : 50),
          SizedBox(height: height * 0.02),
          mapResponse != null
              ? Positioned(
                  top: 100,
                  child: Text(
                    mapResponse['dashboard_statistics']['cp_customers']
                        .toString(), //"$total_customers",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                )
              : CircularProgressIndicator(),

          Positioned(
            top: 27,
            right: 20,
            child: Container(
              // padding : EdgeInsets.only(bottom: 20),
              margin: EdgeInsets.only(bottom: 25),
              child: Icon(
                FontAwesomeIcons.userTie,
                size: 120,
                color: Color(0xffffff).withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
