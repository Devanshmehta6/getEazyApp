import 'package:eazy_app/Services/auth_service.dart';
import 'package:eazy_app/sales%20part/sales_dashboard.dart';
import 'package:eazy_app/sales%20part/view_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_pagination_helper/pagination_helper/event_model.dart';
// import 'package:flutter_pagination_helper/pagination_helper/item_list_callback.dart';
// import 'package:flutter_pagination_helper/pagination_helper/list_helper.dart';
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
  List<dynamic> demo = [];
  ScrollController _scrollController = ScrollController();
  int currentMax = 0;
  String project_name = '';
  String new_project = '';
  int data_length = 0;
  late Future getCust;

  Future<List<getDetails>> getCustomers() async {
    print('-------------------- EXECUTED ------------------------');
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
      //cust_details.clear();
      demo.clear();
      for (var i in cust_data) {
        getDetails gd = getDetails(i['name'], i['mobile'], i['last_check_in'],
            i['status'], i['customer_url']);
        demo.add(gd);

        //print('------------demo------------${demo.length}');
        //cust_details.add(gd);
      }
      data_length = demo.length;
      if (demo.length > 10) {
        getMore();
      } else if (demo.length < 10) {
        print('------- else if------- ');
        getMore();
      } else {}
    } else {
      print('Logged out');
    }
    return cust_details;
  }

  color(String status) {
    if (status == 'hot') {
      return Colors.red;
    } else if (status == 'warm') {
      return Colors.orange;
    } else if (status == 'cold') {
      return Colors.blue;
    } else {
      return Colors.yellow;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMore();
      }
    });
    getCust = getCustomers();
  }

  getMore() {
    print("==================== data_length = $data_length");
    print("==================== currentMax = $currentMax");
    if (currentMax <= demo.length) {
      for (int i = currentMax; (i <= currentMax + 10 && i < demo.length); i++) {
        cust_details.add(demo[i]);
      }
      currentMax = currentMax + 10;
      setState(() {});
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    String pname = ModalRoute.of(context)!.settings.arguments.toString();

    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

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
                    future: getCust,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return CupertinoActivityIndicator();
                      } else {
                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              String date = DateFormat("MMM dd, yyyy hh:mm a")
                                  .format(DateTime.parse(
                                      snapshot.data[index].last_check_in));
                              if (index == snapshot.data.length) {
                                return CupertinoActivityIndicator();
                              }
                              if (snapshot.data.length == 0) {
                                return Center(
                                  child: Text(
                                    'No customers.',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                );
                              }
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 9),
                                                      child: Text(
                                                        'Name: ${snapshot.data[index].name}',
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
                                                      child: Text(
                                                        'Phone: ${snapshot.data[index].mobile}',
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
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 9),
                                                          child: Text(
                                                            'Status: ',
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
                                                          height: 30,
                                                          width: 90,
                                                          child: FlatButton(
                                                            color: color(
                                                                snapshot
                                                                    .data[index]
                                                                    .status),
                                                            onPressed: () {},
                                                            child: Text(
                                                              '${snapshot.data[index].status.toUpperCase()}',
                                                              style: GoogleFonts
                                                                  .poppins(
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
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 9),
                                                      child: Text(
                                                        'Last CheckIn : $date ',
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
                                            final pref = await SharedPreferences
                                                .getInstance();
                                            pref.setString('cust_name',
                                                snapshot.data[index].name);
                                              print('----------- SET ----------- ${snapshot.data[index].customer_url}');
                                            pref.setString(
                                                'cust_url',
                                                snapshot
                                                    .data[index].customer_url);

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
            ],
          ),
        ),
      ),
    );
  }
}
