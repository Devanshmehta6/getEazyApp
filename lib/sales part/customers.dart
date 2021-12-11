import 'package:eazy_app/Services/auth_service.dart';
import 'package:eazy_app/sales%20part/sales_dashboard.dart';
import 'package:eazy_app/sales%20part/view_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class getDetails {
  late String name;
  late String mobile;
  late String last_check_in;
  late String status;
  late String customer_url;

  getDetails(this.name, this.mobile, this.last_check_in, this.status,
      this.customer_url);
}

class EazyCustomers extends StatefulWidget {
  const EazyCustomers({Key? key}) : super(key: key);

  @override
  _EazyCustomersState createState() => _EazyCustomersState();
}

class _EazyCustomersState extends State<EazyCustomers> {
  List<getDetails> cust_details = [];

  String project_name = '';
  String new_project = '';

  Future<List<getDetails>> getCustomers() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in visit page : $isLoggedIn');
    final project_url = pref.getString('project_url');

    if (isLoggedIn == true) {
      Uri url =
          Uri.parse('https://geteazyapp.com/customers/$project_url/apidata');
      print('urlllllllll $url');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();
      String? authorization = sp.getString('token');
      project_name = sp.getString('project_name');
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

      print('>>>>>>>>>>>> RESPONSE >>>>>>>>> ${response.body}');
      final jsonData = jsonDecode(response.body);
      final cust_data = jsonData[0]['customers'];
      cust_details.clear();
      for (var i in cust_data) {
        getDetails gd = getDetails(i['name'], i['mobile'], i['last_check_in'],
            i['status'], i['customer_url']);
        cust_details.add(gd);
      }
    } else {
      print('Logged out');
    }
    return cust_details;
  }

  @override
  Widget build(BuildContext context) {
    String pname = ModalRoute.of(context)!.settings.arguments.toString();

    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
    Future getCustomersFuture = getCustomers();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Sales_Dashboard()),
              );
            },
          ),
          iconTheme: IconThemeData(color: Colors.blue.shade800),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          //centerTitle : true,

          title: Row(
            children: <Widget>[
              SizedBox(width: width * 0.18),
              Text(
                'EazyCustomers',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: myColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: width * 0.19),
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
            children: [
              Container(
                height: height * 0.075,
                width: double.infinity,
                child: Card(
                  elevation: 0,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: width * 0.325, top: height * 0.013),
                    child: pname == ''
                        ? Text(
                            '$project_name',
                            style: GoogleFonts.poppins(fontSize: 16),
                          )
                        : Text(
                            '$pname',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                  ),
                ),
              ),

              Expanded(
                child: FutureBuilder(
                    future: getCustomersFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text('none');
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.active:
                          return Text('active');
                        case ConnectionState.done:
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                String date = DateFormat("MMM dd, yyyy hh:mm a")
                                    .format(DateTime.parse(
                                        snapshot.data[index].last_check_in));
                                return Container(
                                  child: Column(
                                    children: [
                                      Card(
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 9),
                                                        child: Text(
                                                          'Name : ${snapshot.data[index].name}',
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 9),
                                                        child: Text(
                                                          'Phone : ${snapshot.data[index].mobile}',
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 9),
                                                        child: Text(
                                                          'Status : ${snapshot.data[index].status}',
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 9),
                                                        child: Text(
                                                          'Last CheckIn : $date ',
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
                                      Container(
                                        margin: EdgeInsets.only(bottom: 0),
                                        width: double.infinity,
                                        height: height * 0.05,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Container(
                                          color: Colors.white,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: myColor, width: 1.5),
                                            ),
                                            onPressed: () async {
                                              final pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              pref.setString('cust_name',
                                                  snapshot.data[index].name);
                                              pref.setString(
                                                  'cust_url',
                                                  snapshot.data[index]
                                                      .customer_url);

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Detailspage(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'View',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16, color: myColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                    ],
                                  ),
                                );
                              });
                      }
                    }),
              ),
              // ListView(
              //   shrinkWrap: true,
              //   children: [
              //     FutureBuilder(
              //         future: getCustomersFuture,
              //         builder: (BuildContext context, AsyncSnapshot snapshot) {
              //           switch (snapshot.connectionState) {
              //             case ConnectionState.none:
              //               return Text('none');
              //             case ConnectionState.waiting:
              //               return Center(child: CircularProgressIndicator());
              //             case ConnectionState.active:
              //               return Text('active');
              //             case ConnectionState.done:
              //               return SingleChildScrollView(
              //                 child: ListView.builder(
              //                     shrinkWrap: true,
              //                     itemCount: snapshot.data.length,
              //                     itemBuilder: (BuildContext context, int index) {
              //                       String date = DateFormat(
              //                               "MMM dd, yyyy hh:mm a")
              //                           .format(DateTime.parse(
              //                               snapshot.data[index].last_check_in));
              //                       return Container(
              //                         child: Column(
              //                           children: [
              //                             Card(
              //                               child: Expanded(
              //                                 child: Column(
              //                                   children: [
              //                                     Row(
              //                                       children: <Widget>[
              //                                         Padding(
              //                                           padding: EdgeInsets.only(
              //                                               top: 8,
              //                                               left: 8,
              //                                               right: 8),
              //                                           child: Image.asset(
              //                                               'images/user_image.png',
              //                                               height: 100,
              //                                               width: 100),
              //                                         ),
              //                                         VerticalDivider(
              //                                           color: Colors.grey,
              //                                           thickness: 1.5,
              //                                         ),
              //                                         Column(
              //                                           crossAxisAlignment:
              //                                               CrossAxisAlignment
              //                                                   .start,
              //                                           children: [
              //                                             Container(
              //                                               padding:
              //                                                   EdgeInsets.only(
              //                                                       top: 9),
              //                                               child: Text(
              //                                                 'Name : ${snapshot.data[index].name}',
              //                                                 style: GoogleFonts
              //                                                     .poppins(
              //                                                   textStyle:
              //                                                       TextStyle(
              //                                                     fontSize: 14,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .w500,
              //                                                   ),
              //                                                 ),
              //                                               ),
              //                                             ),
              //                                             Container(
              //                                               padding:
              //                                                   EdgeInsets.only(
              //                                                       top: 9),
              //                                               child: Text(
              //                                                 'Phone : ${snapshot.data[index].mobile}',
              //                                                 style: GoogleFonts
              //                                                     .poppins(
              //                                                   textStyle:
              //                                                       TextStyle(
              //                                                     fontSize: 14,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .w500,
              //                                                   ),
              //                                                 ),
              //                                               ),
              //                                             ),
              //                                             Container(
              //                                               padding:
              //                                                   EdgeInsets.only(
              //                                                       top: 9),
              //                                               child: Text(
              //                                                 'Status : ${snapshot.data[index].status}',
              //                                                 style: GoogleFonts
              //                                                     .poppins(
              //                                                   textStyle:
              //                                                       TextStyle(
              //                                                     fontSize: 14,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .w500,
              //                                                   ),
              //                                                 ),
              //                                               ),
              //                                             ),
              //                                             Container(
              //                                               padding:
              //                                                   EdgeInsets.only(
              //                                                       top: 9),
              //                                               child: Text(
              //                                                 'Last CheckIn : $date ',
              //                                                 style: GoogleFonts
              //                                                     .poppins(
              //                                                   textStyle:
              //                                                       TextStyle(
              //                                                     fontSize: 14,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .w500,
              //                                                   ),
              //                                                 ),
              //                                               ),
              //                                             ),
              //                                           ],
              //                                         ),
              //                                       ],
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                             ),
              //                             Container(
              //                               margin: EdgeInsets.only(bottom : 0),
              //                               width: double.infinity,
              //                               height: height * 0.05,
              //                               padding: EdgeInsets.symmetric(
              //                                   horizontal: 5),
              //                               child: Container(
              //                                 color: Colors.white,
              //                                 child: OutlinedButton(
              //                                   style: OutlinedButton.styleFrom(
              //                                     side: BorderSide(
              //                                         color: myColor, width: 1.5),
              //                                   ),
              //                                   onPressed: () async {
              //                                     final pref =
              //                                         await SharedPreferences
              //                                             .getInstance();
              //                                     pref.setString('cust_name',
              //                                         snapshot.data[index].name);

              //                                     Navigator.push(
              //                                       context,
              //                                       MaterialPageRoute(
              //                                         builder: (context) =>
              //                                             Detailspage(),
              //                                       ),
              //                                     );
              //                                   },
              //                                   child: Text(
              //                                     'View',
              //                                     style: GoogleFonts.poppins(
              //                                         fontSize: 16,
              //                                         color: myColor),
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //                             SizedBox(height: height * 0.01),
              //                           ],
              //                         ),
              //                       );
              //                     }),
              //               );
              //           }
              //         }),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
