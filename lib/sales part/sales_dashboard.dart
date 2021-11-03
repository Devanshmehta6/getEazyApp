import 'dart:io';

import 'package:eazy_app/Services/auth_service.dart';
import 'package:eazy_app/sales%20part/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';

class Sales_Dashboard extends StatefulWidget {
  const Sales_Dashboard({Key? key}) : super(key: key);

  @override
  _Sales_DashboardState createState() => _Sales_DashboardState();
}

class _Sales_DashboardState extends State<Sales_Dashboard> {
  List dashboard_response = [];
  

  Future getData() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse('http://geteazyapp.com/sm-dashboard_api/');

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
      //print(response.body);
      dashboard_response = jsonDecode(response.body);
      print('>>>>>>>>>>....$dashboard_response');
      final image = dashboard_response[0]['developer_logo'];
      
      
    } else {
      print('Logged out ');
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final bool snack = ModalRoute.of(context)!.settings.arguments as bool;
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    return Scaffold(
      
      endDrawer: DrawerWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //centerTitle : true,
        iconTheme: IconThemeData(color: myColor),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Image.asset(
              'images/eazyapp-logo-blue.png',
              height: 48,
              width: 40,
            ),
            SizedBox(width: width * 0.24),
            Text(
              'EazyDashboard',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: myColor, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        //margin: EdgeInsets.symmetric(vertical: height * 0.013),
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('none');
                case ConnectionState.active:
                  return Text('active');
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.25,
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xff007bff)),
                            margin: EdgeInsets.symmetric(
                                vertical: height * 0.01,
                                horizontal: width * 0.015),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: width * 0.05,
                                          top: height * 0.04),
                                      child: Text(
                                        'Total Customers',
                                        style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(right: width * 0.09),
                                      child: Text(
                                        'Visits Completed',
                                        style:
                                            GoogleFonts.poppins(fontSize: 15),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: width * 0.33,
                                          top: height * 0.008),
                                      child: Text(
                                        dashboard_response[0]['total_customers']
                                            .toString(),
                                        style:
                                            GoogleFonts.poppins(fontSize: 50),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.065,
                                      vertical: height * 0.035),
                                  child: Icon(
                                    FontAwesomeIcons.users,
                                    size: 110,
                                    color: Color(0xffffff).withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.25,
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffdc3545)),
                            margin: EdgeInsets.symmetric(
                                vertical: height * 0.01,
                                horizontal: width * 0.015),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: width * 0.05,
                                          top: height * 0.04),
                                      child: Text(
                                        'Hot Customers',
                                        style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(right: width * 0.18),
                                      child: Text(
                                        'In Pipeline',
                                        style:
                                            GoogleFonts.poppins(fontSize: 15),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: width * 0.3,
                                          top: height * 0.008),
                                      child: Text(
                                        dashboard_response[0]['hot_customers']
                                            .toString(),
                                        style:
                                            GoogleFonts.poppins(fontSize: 50),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: width * 0.16, top: height * 0.035),
                                  child: Icon(
                                    FontAwesomeIcons.grinHearts,
                                    size: 110,
                                    color: Color(0xffffff).withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.25,
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffffc107)),
                            margin: EdgeInsets.symmetric(
                                vertical: height * 0.01,
                                horizontal: width * 0.015),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: width * 0.05,
                                          top: height * 0.04),
                                      child: Text(
                                        'Warm Customers',
                                        style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(right: width * 0.23),
                                      child: Text(
                                        'In Pipeline',
                                        style:
                                            GoogleFonts.poppins(fontSize: 15),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: width * 0.35,
                                          top: height * 0.008),
                                      child: Text(
                                        dashboard_response[0]['warm_customers']
                                            .toString(),
                                        style:
                                            GoogleFonts.poppins(fontSize: 50),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: width * 0.085, top: height * 0.035),
                                  child: Icon(
                                    FontAwesomeIcons.smile,
                                    size: 110,
                                    color: Color(0xffffff).withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.25,
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xff17a2b8)),
                            margin: EdgeInsets.symmetric(
                                vertical: height * 0.01,
                                horizontal: width * 0.015),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: width * 0.05,
                                          top: height * 0.04),
                                      child: Text(
                                        'Total Follow Ups',
                                        style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      //padding: EdgeInsets.only(right: width * 0.23),
                                      child: Text(
                                        DateFormat("EEEE").format(
                                              DateTime.now(),
                                            ) +
                                            ' , ' +
                                            DateFormat("dd-MM-yyyy").format(
                                              DateTime.now(),
                                            ),
                                        style:
                                            GoogleFonts.poppins(fontSize: 15),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: width * 0.3,
                                          top: height * 0.008),
                                      child: Text(
                                        dashboard_response[0]
                                                ['follow_ups_customers']
                                            .toString(),
                                        style:
                                            GoogleFonts.poppins(fontSize: 50),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: width * 0.12, top: height * 0.035),
                                  child: Icon(
                                    FontAwesomeIcons.headset,
                                    size: 110,
                                    color: Color(0xffffff).withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
              }
            }),
      ),
    );
  }
}
