import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:eazy_app/Pages/drawer_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eazy_app/Services/auth_service.dart';

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
  Future getData() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';
      print('Set token :: $settoken');
      Uri url = Uri.parse('https://geteazyapp.com/dashboard_api/');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();
      //String? authorization = sp.getString('token');
      //String? tokenn = authorization;
      // final token = await AuthService.getToken();
      // print('TOKENENNENEN :$token');
      // final settoken = token['token'];
      print('Token $settoken');

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
      print('RESPONSE BODY : ${response.body}');
      final entireJson = jsonDecode(response.body);

      //FetchData fetchData = FetchData.fromJson(entireJson);
      //print(entireJson[0]['Name']);
      //naam = entireJson[0]['Name'];

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          endDrawer: NavigationDrawerWidget(),
          appBar: AppBar(
            //centerTitle : true,
            iconTheme: IconThemeData(color: Colors.blue.shade800),
            backgroundColor: Colors.white,
            title: Row(
              children: <Widget>[
                //SizedBox(width: width * 0.7),
                Image.asset(
                  'images/eazyapp-logo-blue.png',
                  height: 48,
                  width: 40,
                ),
                SizedBox(width: width * 0.22),
                Text(
                  'EazyDashboard',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: myColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
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
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.done:
                      return Column(
                        children: <Widget>[
                          SizedBox(height: height * 0.03),
                          Total(context),
                          SizedBox(height: height * 0.03),
                          Direct(context),
                          SizedBox(height: height * 0.03),
                          CP(context),
                          SizedBox(height: height * 0.02),
                        ],
                      );
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget Total(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    //sabKuch();
    return Column(
      children: <Widget>[
        Container(
          height: height * 0.28,
          width: width,
          color: Colors.blue.shade300,
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.only(left: 20, top: 15),
          child: Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Total Visits',
                    style: GoogleFonts.poppins(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
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
                  //SizedBox(width : 50),
                  SizedBox(height: height * 0.02),
                  mapResponse != null
                      ? Text(
                          mapResponse['dashboard_statistics']['total_customers']
                              .toString(), //"$total_customers",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 50,
                            ),
                          ),
                        )
                      : CircularProgressIndicator()
                ],
              ),
              SizedBox(width: width * 0.16),
              Container(
                // padding : EdgeInsets.only(bottom: 20),
                margin: EdgeInsets.only(bottom: 25),
                child: Icon(FontAwesomeIcons.users,
                    size: 120, color: Colors.blue.shade100),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget Direct(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    //sabKuch();
    return Column(
      children: <Widget>[
        Container(
          height: height * 0.28,
          width: width,
          color: Colors.green.shade400,
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.only(left: 20, top: 15),
          child: Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Total Visits - Direct',
                    style: GoogleFonts.poppins(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
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
                  //SizedBox(width : 50),
                  SizedBox(height: height * 0.02),
                  mapResponse != null
                      ? Text(
                          mapResponse['dashboard_statistics']
                                  ['direct_customers']
                              .toString(), //"$total_customers",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 50,
                            ),
                          ),
                        )
                      : CircularProgressIndicator()
                ],
              ),
              SizedBox(width: width * 0.025),
              Container(
                // padding : EdgeInsets.only(bottom: 20),
                margin: EdgeInsets.only(bottom: 25),
                child: Icon(
                  FontAwesomeIcons.solidUser,
                  size: 120,
                  color: Colors.green.shade100,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget CP(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    //sabKuch();
    return Column(
      children: <Widget>[
        Container(
          height: height * 0.28,
          width: width,
          color: Colors.red.shade400,
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.only(left: 20, top: 15),
          child: Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Total Visits - CP',
                    style: GoogleFonts.poppins(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
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
                  //SizedBox(width : 50),
                  SizedBox(height: height * 0.02),
                  mapResponse != null
                      ? Text(
                          mapResponse['dashboard_statistics']['cp_customers']
                              .toString(), //"$total_customers",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 50,
                            ),
                          ),
                        )
                      : CircularProgressIndicator()
                ],
              ),
              SizedBox(width: width * 0.12),
              Container(
                // padding : EdgeInsets.only(bottom: 20),
                margin: EdgeInsets.only(bottom: 25),
                child: Icon(
                  FontAwesomeIcons.userTie,
                  size: 120,
                  color: Colors.red.shade100,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
