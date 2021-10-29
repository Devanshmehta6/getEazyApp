import 'dart:core';
import 'package:eazy_app/Pages/customer_check.dart/cp_first.dart';
import 'package:eazy_app/Pages/customer_check.dart/fifth.dart';
import 'package:eazy_app/Pages/customer_check.dart/first.dart';
import 'package:eazy_app/Pages/customer_check.dart/first.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:eazy_app/Pages/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter_session/flutter_session.dart';
import 'package:eazy_app/Services/auth_service.dart';

class User {
  late String name;
  late String phone;
  late String assign_to;
  late String customer_url;

  User(this.name, this.phone, this.assign_to, this.customer_url);
}

class User2 {
  late String Name;
  late String Phone;
  late String Assign_to;

  User2(this.Name, this.Phone, this.Assign_to);
}

class Sales {
  late String name;
  late String id;
  //late String assign_to;

  Sales(
    this.name,
    this.id,
  ); //this.assign_to);
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

  var sales;
  List<Sales> managers = [];
  String? dropDownValue;
  late Future myFuture;
  late Future myFuture2;
  late Future futureForSales;
  String project_name = '';
  String new_project = '';

  Future<List<User>> ongoingclass() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in visit page : $isLoggedIn');
    final project_url = pref.getString('project_url');

    if (isLoggedIn == true) {
      Uri url = Uri.parse(
          'https://geteazyapp.com/projects/$project_url/on-going-visits/api');
      print('urlllllllll $url');

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
      //final cust_url = ongoingdata['customer_url'];
      sales = entireJson['sales_manager'];
      print('==========sales===========$sales');
      final p_id = entireJson['current project'][0]['project_no'];
      print('======== ....... $p_id');
      pref.setString('project_id', p_id);

      // print('---------------PROJ ------------ $proj_id');

      for (var i in ongoingdata) {
        User user =
            User(i['name'], i['phone'], i['assign_to'], i['customer_url']);

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

    //final project_url = ModalRoute.of(context)!.settings.arguments.toString();
    final project_url = pref.getString('project_url');
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

  Future<List<Sales>> managerClass() async {
    for (var i in sales) {
      Sales sales = Sales(i['name'], i['id']); //, i['assign_to']);
      managers.add(sales);
    }
    print('-----------MANAGERS------------ $managers');
    return managers;
  }

  postManager(BuildContext context, String id) async {
    final pref = await SharedPreferences.getInstance();
    final cust_url = pref.getString('cust_url');
    print(
        '---------CUSTOMER URL THAT HAS BEEN PRINTED---------------$cust_url');
    final project_url = pref.getString('project_url');
    Uri url =
        Uri.parse('https://geteazyapp.com/projects/$project_url/$cust_url/api');
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
    final cust_id = sp.getInt('cust_id');
    final mobile = sp.getString('mobile');
    final project_id = pref.getString('project_id');

    http.Response response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': settoken,
          HttpHeaders.cookieHeader: setcookie,
        },
        body: jsonEncode(
          {
            'project': project_id,
            'customer': cust_id,
            'mobile': mobile,
            'assign_to': '$id',
          },
        ));
  }

  showAlertDialog(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    AlertDialog alert = AlertDialog(
      //clipBehavior: Clip.antiAliasWithSaveLayer,
      title: Padding(
        padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: managerClass(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print(
                    '>>>>>>>>>>>> SNAPSHOT >>>>>>>>>>> ${snapshot.data.length}');
                final height = MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight;
                final width = MediaQuery.of(context).size.width;
                Color myColor = Color(0xff4044fc);

                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    return Text('active');
                  case ConnectionState.done:
                    return DropdownButton<String>(
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 27,
                      iconDisabledColor: Colors.grey,
                      iconEnabledColor: myColor,
                      hint: Text('Assign a sales manager    ',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                          )),
                      // selectedItemBuilder: (BuildContext context) {
                      //   return snapshot.data.map<Widget>((Sales item) {
                      //     return Text(item.name);
                      //   }).toList();
                      // },
                      items:
                          snapshot.data.map<DropdownMenuItem<String>>((item) {
                        return DropdownMenuItem<String>(
                          value: item.id.toString(),
                          //value = string
                          child: Text(
                            item.name,
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          dropDownValue = value;
                        });

                        postManager(context, dropDownValue.toString());
                        Navigator.pop(context);
                      },
                    );
                }
              },
            ),
            Row(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: height * 0.05,
                        width: width * 0.35,
                        child: FlatButton(
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//futureForSales = managerClass();
    myFuture = ongoingclass();
    myFuture2 = completedclass();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    bool isLoading = false;

    getName() async {
      final pref = await SharedPreferences.getInstance();
      project_name = pref.getString('project_name');
      setState(() {
        new_project = project_name.substring(0, 18) + "...";
      });
    }

    //final project_name = ModalRoute.of(context)!.settings.arguments.toString();

    // final dot = '...';
    // final latest_project = new_project + dot;
    getName();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade400,
        bottomNavigationBar: Container(
          height: height * 0.08,
          margin: EdgeInsets.only(top: 2),
          child: SafeArea(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Container(
                width: width * 0.50,
                child: FlatButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CP(),
                      ),
                    );
                  },
                  child: Text(
                    'CP Check In',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                width: width * 0.50,
                child: FlatButton(
                  color: myColor,
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Customer Check In',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 16, color: Colors.white),
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
              SizedBox(width: width * 0.13),
              Text(
                new_project,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              SizedBox(width: width * 0.12),
              Image.asset('images/eazyapp-logo-blue.png',
                  height: 45, width: 40),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
                future: myFuture,
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
                      if (snapshot.data.isEmpty) {
                        return Center(
                          child: Text(
                            'No On Going visits currently.',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
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
                                                    top: 8, left: 8, right: 8),
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
                                                    padding:
                                                        EdgeInsets.only(top: 9),
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
                                                    padding:
                                                        EdgeInsets.only(top: 9),
                                                    child: Text(
                                                      'Phone : ${snapshot.data[index].phone}',
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
                                                    padding:
                                                        EdgeInsets.only(top: 9),
                                                    child: snapshot.data[index]
                                                                .assign_to ==
                                                            'None'
                                                        ? Text(
                                                            'Allocated To : -',
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
                                                            'Allocated To : ${snapshot.data[index].assign_to}',
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
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Container(
                                        color: Colors.white,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: myColor, width: 1.5),
                                          ),
                                          child: snapshot
                                                      .data[index].assign_to ==
                                                  'None'
                                              ? Text(
                                                  'ASSIGN SALES MANAGER',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: myColor),
                                                )
                                              : Text(
                                                  'RE-ASSIGN SALES MANAGER',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: myColor),
                                                ),
                                          onPressed: () async {
                                            showAlertDialog(context);
                                            final cust_url = snapshot
                                                .data[index].customer_url;
                                            final pref = await SharedPreferences
                                                .getInstance();
                                            pref.setString(
                                                'cust_url', cust_url);
                                            print(
                                                '----CUSTOMER URL HAS BEEN SET------ $cust_url');

                                            //customer_url.add(snapshot.data[index].customer_url[0]);
                                            //print('------------$customer_url');
                                            //print('===============${snapshot.data[index].customer_url}');
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ); //Text(snapshot.data[index].Name),
                          });
                  }
                }),
            FutureBuilder(
              future: myFuture2,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    return Text('active');
                  case ConnectionState.done:
                    if (snapshot.data.isEmpty) {
                      return Center(
                        child: Text(
                          'No Completed visits yet.',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Column(
                              children: [
                                Card(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8, left: 8, right: 8),
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
                                                  padding:
                                                      EdgeInsets.only(top: 9),
                                                  child: Text(
                                                    'Name : ${snapshot.data[index].name}',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 9),
                                                  child: Text(
                                                    'Phone : ${snapshot.data[index].phone}',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 9),
                                                  child: snapshot.data[index]
                                                              .assign_to ==
                                                          null
                                                      ? Text(
                                                          'Allocated To : -',
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
                                                          'Allocated To : ${snapshot.data[index].assign_to}',
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
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
