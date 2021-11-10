import 'dart:io';

import 'package:eazy_app/Pages/login_page.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:eazy_app/sales%20part/customers.dart';
import 'package:eazy_app/sales%20part/sales_dashboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProjectName {
  late String project_name;
  late String project_url;

  ProjectName(this.project_name, this.project_url);
}

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  List<ProjectName> project_names = [];
  late Future project_name;

  Future<List<ProjectName>> getProjName() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      Uri url = Uri.parse('http://geteazyapp.com/sm-dashboard_api/');

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
      print('>>>>>>>>> $jsonData');
      final projectData = jsonData[0]['project'];
      print('ppppppppppppppppppp $projectData');
      for (var u in projectData) {
        ProjectName pname = ProjectName(u["project_name"], u["project_url"]);
        project_names.add(pname);
      }
    } else {
      print('Logged Out...');
    }
    return project_names;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    project_name = getProjName();
  }

  String? image;
  @override
  Widget build(BuildContext context) {
    // String img = '';
    // getImage() async {
    //   final pref = await SharedPreferences.getInstance();
    //   img = pref.getString('image_url');
    // }

    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    fetchImage() async {
      final SESSION = FlutterSession();

      image = await SESSION.get('image');

      print('>>>>>>>>>>>>>>>>>>>>>>>>$image');
      return image;
    }

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // decoration: BoxDecoration(
              // image: DecorationImage(image: NetworkImage('$image'))),
              height: height * 0.17,
              padding: EdgeInsets.only(top: height * 0.01),
              child: FutureBuilder(
                  future: fetchImage(),
                  builder: (context, snapshot) {
                    print('>>>>>>>>>......${snapshot.data}');
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
                        return Image.network(image.toString());
                    }
                  }),
            ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Sales_Dashboard(),
                  ),
                );
              },
            ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                iconColor: Colors.black,
                title: Row(
                  children: [
                    SizedBox(width: width * 0.01),
                    Icon(
                      FontAwesomeIcons.users,
                    ),
                    SizedBox(width: width * 0.06),
                    Text(
                      'EazyCustomers',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                children: [
                  FutureBuilder(
                    future: project_name,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
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

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EazyCustomers(),
                                      settings: RouteSettings(
                                          arguments: snapshot
                                              .data[index].project_name)),
                                );
                              },
                              title: Row(
                                children: [
                                  SizedBox(width: width * 0.06),
                                  Icon(FontAwesomeIcons.userClock,
                                      color: Colors.grey.shade700, size: 16),
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
                ],
              ),
            ),
            SizedBox(height: height * 0.01),
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
