import 'dart:io';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  String name;
  int id;

  User(this.name, this.id);
}

class EazyTeams extends StatefulWidget {
  @override
  State<EazyTeams> createState() => _EazyTeamsState();
}

class _EazyTeamsState extends State<EazyTeams> {
  String mockData = '';
  final parsedData = '';
  final String name = '';
  List<User> users = [];
  bool check = true;
  String? project_name;
  late Future getteams;

  String? checkintime;
  String? checkouttime;

  Future<List<User>> getTeams() async {
    final pref = await SharedPreferences.getInstance();
    final isLoggedIn = pref.getBool('log');

    print('Logged in visit page : $isLoggedIn');

    final project_url = pref.getString('project_url');
    if (isLoggedIn == true) {
      Uri url = Uri.parse('https://geteazyapp.com/eazyteams/$project_url/api');

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

      print('RESPONSE BODY TEAMS : ${response.body}');
      final responseData = jsonDecode(response.body);
      final mem = responseData[0]['team_member'];
      print(mem);
      project_name = sp.getString('project_name');

      for (var u in mem) {
        User user = User(u['name'], u['id']);

        users.add(user);
      }
    } else {
      print('Logged out ');
    }
    return users;
  }

  postCheckin() async {
    final pref = await SharedPreferences.getInstance();
    final project_url = pref.getString('project_url');
    final cust_url = pref.getString('customer_url');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm').format(now);

    final id = pref.getInt('sales_man_id');

    final url = 'https://geteazyapp.com/eazyteams/$project_url/api';

    String sessionId = await FlutterSession().get('session');
    String csrf = await FlutterSession().get('csrf');

    String? authorization = pref.getString('token');
    final token = await AuthService.getToken();
    final settoken = 'Token ${token['token']}';
    final setcookie = "csrftoken=$csrf; sessionid=$sessionId";

    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      },
      body: jsonEncode(
        {
          'id': id,
          'checkin_time': formattedDate,
        },
      ),
    );
    final res = jsonDecode(response.body);
    print('-------------- res ---------------- $res');
    setState(() {
      checkintime = res[0]['history_data']['checkin_time'];
    });
  }

  postCheckout() async {
    final pref = await SharedPreferences.getInstance();
    final project_url = pref.getString('project_url');
    final cust_url = pref.getString('customer_url');
    DateTime now1 = DateTime.now();
    String formattedDate2 = DateFormat('kk:mm').format(now1);

    final id = pref.getInt('sales_man_id');

    final url = 'https://geteazyapp.com/eazyteams/$project_url/api';

    String sessionId = await FlutterSession().get('session');
    String csrf = await FlutterSession().get('csrf');

    String? authorization = pref.getString('token');
    final token = await AuthService.getToken();
    final settoken = 'Token ${token['token']}';
    final setcookie = "csrftoken=$csrf; sessionid=$sessionId";

    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      },
      body: jsonEncode(
        {
          'id': id,
          'checkout_time': formattedDate2,
        },
      ),
    );
    final res = jsonDecode(response.body);
    setState(() {
      checkouttime = res[0]['history_data']['checkout_time'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("================== Printing Image ================= ");
    getteams = getTeams();
    print("================== Image Printed ================= ");
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    String? formattedDate; //DateFormat('kk:mm:ss').format(now);
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue.shade800),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            SizedBox(width: 280),
            Image.asset(
              'images/eazyapp-logo-blue.png',
              height: 48,
              width: 40,
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 70,
              width: double.infinity,
              child: Card(
                child: Container(
                  padding: EdgeInsets.only(top: 6),
                  child: Column(
                    children: <Widget>[
                      project_name == null
                          ? Text(
                              '  Team Members - Loading...',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            )
                          : Text(
                              '  Team Members - ${project_name}',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                      Container(
                        child: Text(
                          DateFormat("dd-MM-yyyy").format(
                            DateTime.now(),
                          ),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getteams,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    final height = MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight;
                    final width = MediaQuery.of(context).size.width;
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('none');
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                        return Text('active');
                      case ConnectionState.done:
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Column(
                                  children: [
                                    Card(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 8,
                                                      left: 8,
                                                      right: 8),
                                                  child: Image.asset(
                                                      'images/user_image.png',
                                                      height: 100,
                                                      width: 100),
                                                ),
                                                VerticalDivider(
                                                  color: Colors.grey,
                                                  thickness: 1.5,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 9),
                                                      child: Text(
                                                        'Name : ${snapshot.data[index].name}',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 9),
                                                      child: checkintime == null
                                                          ? Text(
                                                              'Check In Time : -', //'Phone : ${snapshot.data[index].phone}',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            )
                                                          : Text(
                                                              'Check In Time : $checkintime', //'Phone : ${snapshot.data[index].phone}',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 9),
                                                      child: Text(
                                                        'Check Out Time : $checkouttime', //'Allocated To : ${snapshot.data[index].assign_to}',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SafeArea(
                                      child: Container(
                                        width: double.infinity,
                                        height: height * 0.05,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Container(
                                          color: Colors.white,
                                          child: check
                                              ? OutlinedButton(
                                                  //color: myColor,
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color: myColor,
                                                        width: 1.5),
                                                  ),

                                                  child: Text(
                                                    'CHECK IN',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        color: myColor),
                                                  ),

                                                  onPressed: () async {
                                                    final pref =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    pref.setInt(
                                                        'sales_man_id',
                                                        snapshot
                                                            .data[index].id);
                                                    postCheckin();
                                                    setState(() {
                                                      check = !check;
                                                    });
                                                  },
                                                )
                                              : OutlinedButton(
                                                  //color: myColor,
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color: myColor,
                                                        width: 1.5),
                                                  ),

                                                  child: Text(
                                                    'CHECK OUT',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        color: myColor),
                                                  ),
                                                  onPressed: () async {
                                                    final pref =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    pref.setInt(
                                                        'sales_man_id',
                                                        snapshot
                                                            .data[index].id);
                                                    postCheckout();
                                                    setState(() {
                                                      check = !check;
                                                    });
                                                  },
                                                ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ); //Text(snapshot.data[index].Name),
                            });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
