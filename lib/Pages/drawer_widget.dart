import 'dart:io';
import 'dart:convert';
import 'package:eazy_app/Pages/customer_check.dart/first.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:eazy_app/Pages/dashboard.dart';
import 'package:eazy_app/Pages/eazy_teams.dart';
import 'package:eazy_app/Pages/eazy_visits.dart';
import 'package:eazy_app/Pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:dio/dio.dart' as http;
import 'package:eazy_app/Services/teams_json.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 10);
  Color myColor = Color(0xff4044fc);
  List<User> users = [];
  bool is1Selected = false;
  bool is2Selected = false;
  bool is3Selected = false;
  var jsonData;
  var ima;

  List<bool> bool_list = [
    false,
    false,
    false,
  ];

  List<String> title_list = ['EazyDashboard', 'EazyVisits', 'EazyTeams'];

  List<Widget> page_list = [
    Dashboard(),
    EazyVisits(),
    EazyTeams(),
  ];

  int selectedIndex = 0;
  int count = 0;

  Future<List<User>> getVisits() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      Uri url = Uri.parse('https://geteazyapp.com/dashboard_api/');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();
      String? authorization = sp.getString('token');
      final token = await AuthService.getToken();
      String? tokenn = authorization;
      final cookie = sp.getString('cookie');
      final settoken = 'Token ${token['token']}';
      print('Set token :: $settoken');

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      });
      final jsonData = jsonDecode(response.body);

      final projectData = jsonData['projects'];
      print(projectData);

      for (var u in projectData) {
        User user = User(u["project_name"], u["project_url"]);
        users.add(user);
      }
      //return users;
    } else {
      print('Logged Out...');
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;

    return Drawer(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              height: height * 0.2,
              padding: EdgeInsets.only(top: height * 0.01),
              child: DrawerHeader(
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15),
                child: Image.network(
                  '',
                ),
              ),
            ),
            //EAZY DASHBOARD
            ListTile(
              title: Row(
                children: [
                  SizedBox(width: width * 0.01),
                  Icon(FontAwesomeIcons.chartPie, color: myColor),
                  SizedBox(width: width * 0.06),
                  Text(
                    'EazyDashboard',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 18, color: myColor),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
            ),

            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Column(
                //height: height*0.15,

                children: [
                  ExpansionTile(
                      iconColor: Colors.black,
                      childrenPadding: EdgeInsets.all(0),
                      title: Row(
                        children: [
                          SizedBox(width: width * 0.01),
                          Icon(
                            FontAwesomeIcons.users,
                          ),
                          SizedBox(width: width * 0.06),
                          Text(
                            title_list[1],
                            style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        FutureBuilder(
                          future: getVisits(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return ListView.builder(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EazyVisits(),
                                            settings: RouteSettings(
                                                arguments: snapshot
                                                    .data[index].project_url),
                                          ),
                                        );
                                      },
                                      title: Row(
                                        children: [
                                          SizedBox(width: width * 0.06),
                                          Icon(FontAwesomeIcons.userClock,
                                              color: Colors.grey, size: 18),
                                          SizedBox(width: width * 0.04),
                                          Text(
                                            snapshot.data[index].project_name,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      )),
                            );
                          },
                        ),
                      ]),
                ],
              ),
            ),

            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Column(
                //height: height*0.15,

                children: [
                  ExpansionTile(
                      iconColor: Colors.black,
                      childrenPadding: EdgeInsets.all(0),
                      title: Row(
                        children: [
                          SizedBox(width: width * 0.01),
                          Icon(
                            FontAwesomeIcons.userTie,
                          ),
                          SizedBox(width: width * 0.06),
                          Text(
                            title_list[2],
                            style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        FutureBuilder(
                          future: getVisits(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return CircularProgressIndicator();
                            }
                            return ListView.builder(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EazyTeams(),
                                            settings: RouteSettings(
                                                arguments: snapshot
                                                    .data[index].project_url),
                                          ),
                                        );
                                      },
                                      title: Row(
                                        children: [
                                          SizedBox(width: width * 0.06),
                                          Icon(FontAwesomeIcons.userFriends,
                                              color: Colors.grey, size: 18),
                                          SizedBox(width: width * 0.04),
                                          Text(
                                            snapshot.data[index].project_name,
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ],
                                      )),
                            );
                          },
                        ),
                      ]),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            Divider(thickness: 0.5),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              title: Row(children: [
                SizedBox(width: width * 0.01),
                Icon(FontAwesomeIcons.signOutAlt),
                SizedBox(width: width * 0.06),
                Text(
                  'Log Out',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class User {
  late String project_name;
  late String project_url;

  User(this.project_name, this.project_url);
}
