import 'dart:core';
import 'package:eazy_app/Pages/customer_check.dart/first.dart';
import 'package:eazy_app/Pages/customer_check.dart/first.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:eazy_app/Pages/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter_session/flutter_session.dart';
import 'package:eazy_app/Services/auth_service.dart';

class User {
  late String name;
  late String phone;
  late String assign_to;

  User(this.name, this.phone, this.assign_to);
}

class User2 {
  late String Name;
  late String Phone;
  late String Assign_to;

  User2(this.Name, this.Phone, this.Assign_to);
}

class CompletedCustomer {
  late String Name;
  late String Phone;
  late String Attended_by;

  CompletedCustomer(this.Name, this.Phone, this.Attended_by);
}

class EazyVisits extends StatefulWidget {
  @override
  State<EazyVisits> createState() => _EazyVisitsState();
}

class _EazyVisitsState extends State<EazyVisits> {
  Map onGoingResponse = {};
  Map completedResponse = {};
  var entireJson;
  var entireJson2;
  var ongoingdata;
  var completeddata;
  List<User> users = [];
  List<User2> users2 = [];
  late String token;
  late String settoken;
  

  Future<List<User>> ongoingclass() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in visit page : $isLoggedIn');
    final project_url = ModalRoute.of(context)!.settings.arguments.toString();

    if (isLoggedIn == true) {
      Uri url = Uri.parse(
          'https://geteazyapp.com/projects/$project_url/on-going-visits/api');

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

      print('RESPONSE BODY ONGOING: ${response.body}');

      var entireJson = jsonDecode(response.body);
      ongoingdata = entireJson['on_going_visits'];
 
      for (var i in ongoingdata) {
        User user = User(i['name'], i['phone'], i['assign_to']);

        users.add(user);
      }
    } else {
      print('Logged out ');
    }
    return users;
  }

  Future<List<User2>> completedclass() async {
    final pref = await SharedPreferences.getInstance();
    final isLoggedIn = pref.getBool('log');
    print('Logged in visit page : $isLoggedIn');
    final project_url = ModalRoute.of(context)!.settings.arguments.toString();
    if (isLoggedIn == true) {
      Uri url = Uri.parse(
          'https://geteazyapp.com/projects/$project_url/completed-visits/api');

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

      print('RESPONSE BODY COMPLETED: ${response.body}');
      entireJson2 = jsonDecode(response.body);
      completeddata = entireJson2['completed_visits'];
      print('yqyqyqyqyq :: $entireJson2');

      for (var u in completeddata) {
        User2 user2 = User2(u['Name'], u['Phone'], u['Assign_to']);

        users2.add(user2);
      }
    } else {
      print('Logged out ');
    }
    return users2;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.lightBlue.shade50,
        bottomNavigationBar: Container(
          height: height * 0.08,
          margin: EdgeInsets.only(top: 2),
          child: SafeArea(
            child:
              Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Container(
                width: width * 0.50,
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FirstPage(),
                        ));
                  },
                  child: Text(
                    'Customer Check In',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                width: width * 0.50,
                child: FlatButton(
                  color: Colors.grey,
                  onPressed: () {},
                  child: Text(
                    'CP Check In',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  'OnGoing Site Visits',
                  style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                ),
              ),
              Tab(
                child: Text(
                  'Completed Site Visits',
                  style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
          ),
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
        body: TabBarView(
          children: [
            FutureBuilder(
              future: ongoingclass(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                final height = MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight;
                final width = MediaQuery.of(context).size.width;
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(
                            top: height * 0.005,
                          ),
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Image.asset('images/user_image.png',
                                      height: 100, width: 100),
                                  VerticalDivider(
                                    color: Colors.grey,
                                    thickness: 1.5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 9),
                                        child: Text(
                                          'Name : ${snapshot.data[index].name}',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 9),
                                        child: Text(
                                          'Phone : ${snapshot.data[index].phone}',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 9),
                                        child: snapshot
                                                    .data[index].assign_to ==
                                                null
                                            ? Text(
                                                'Allocated To : -',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                'Allocated To : ${snapshot.data[index].assign_to}',
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
                                ],
                              ),
                            ),
                          ),
                        ); //Text(snapshot.data[index].Name),
                      });
                }
              },
            ),
            FutureBuilder(
              future: completedclass(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: height * 0.005, bottom: height * 0.30),
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Image.asset('images/user_image.png',
                                      height: 100, width: 100),
                                  VerticalDivider(
                                    color: Colors.grey,
                                    thickness: 1.5,
                                  ),
                                  Column(
                                    //crossAxisAlignment:
                                    // CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 9),
                                        child: Text(
                                          'Name : ${snapshot.data[index].Name}',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 9),
                                        child: Text(
                                          'Phone : ${snapshot.data[index].Phone}',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 9),
                                        child: snapshot.data[index].Assign_to ==
                                                null
                                            ? Text(
                                                'Assigned To : -',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                'Assigned To : ${snapshot.data[index].Assign_to}',
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
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Text('NI');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
