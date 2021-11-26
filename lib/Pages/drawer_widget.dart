import 'dart:io';
import 'dart:convert';
import 'package:eazy_app/Pages/customer_check.dart/first.dart';
import 'package:eazy_app/Pages/customer_check.dart/third.dart';
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
import 'package:path/path.dart';
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
  String ima = '';
  late Future myFuture;

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

  getImage() async {
    final pref = await SharedPreferences.getInstance();
    final cust_url = pref.getString('customer_url');
    final project_url = pref.getString('project_url');
    Uri url = Uri.parse('https://geteazyapp.com/api/developer-logo');
    print('------------------url----------------$url');
    String sessionId = await FlutterSession().get('session');

    String csrf = await FlutterSession().get('csrf');
    print('==================== C S R F  VISITS =       $csrf');
    final sp = await SharedPreferences.getInstance();
    String? authorization = sp.getString('token');
    String? tokenn = authorization;
    final cookie = sp.getString('cookie');
    final token = await AuthService.getToken();
    final settoken = 'Token ${token['token']}';
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
    final imgResponse = jsonDecode(response.body);
    ima = imgResponse['developer_logo'];
    return ima;
  }

  Future<List<User>> getProjName() async {
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

      //ima = jsonData['developer_logo'][0];
      //print('============IMA =========== $ima');
      final projectData = jsonData['projects'];
      print(projectData);

      for (var u in projectData) {
        User user = User(u["project_name"].toString(), u["project_url"]);
        users.add(user);
      }
      //return users;s
    } else {
      print('Logged Out...');
    }
    return users;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myFuture = getProjName();
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
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: FutureBuilder(
                  future: getImage(),
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
                        return Image.network(ima.toString());
                    }
                  }),
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
                          future: myFuture,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return ListView.builder(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    onTap: () async {
                                      final pref =
                                          await SharedPreferences.getInstance();
                                      pref.setString('project_url',
                                          snapshot.data[index].project_url);
                                      print(
                                          '>>>>>>>>>> prrrrrrrr >>>>>>   ${snapshot.data[index].project_url}');
                                      pref.setString('project_name',
                                          snapshot.data[index].project_name);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EazyVisits(),
                                          settings: RouteSettings(name : 'EazyVisits'),
                                        ),
                                      );
                                    },
                                    title: Row(
                                      children: [
                                        SizedBox(width: width * 0.06),
                                        Icon(FontAwesomeIcons.building,
                                            color: Colors.grey.shade700,
                                            size: 16),
                                        SizedBox(width: width * 0.04),
                                        Text(
                                          snapshot.data[index].project_name,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
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
                          future: myFuture,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot2) {
                            if (snapshot2.data == null) {
                              return CircularProgressIndicator();
                            }
                            return ListView.builder(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              itemCount: snapshot2.data.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  ListTile(
                                      onTap: () async {
                                        final pref = await SharedPreferences
                                            .getInstance();
                                        pref.setString('project_url',
                                            snapshot2.data[index].project_url);
                                        pref.setString('project_name',
                                            snapshot2.data[index].project_name);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EazyTeams(),
                                          ),
                                        );
                                      },
                                      title: Row(
                                        children: [
                                          SizedBox(width: width * 0.06),
                                          Icon(FontAwesomeIcons.userFriends,
                                              color: Colors.grey.shade700,
                                              size: 16),
                                          SizedBox(width: width * 0.04),
                                          Text(
                                            snapshot2.data[index].project_name,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.grey.shade700,
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
