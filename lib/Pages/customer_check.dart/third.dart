import 'dart:convert';
import 'dart:io';

import 'package:eazy_app/Pages/customer_check.dart/fourth.dart';
import 'package:eazy_app/Pages/customer_check.dart/second.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  String? valueChoose;
  int _value = 1;
  int _value2 = 1;
  final budgetList = [
    '50L - 75L',
    '75L - 1CR',
    '1CR - 1.25CR',
    '1.25CR - 1.50CR',
    '1.50CR - 1.75CR',
    '1.75CR - 2CR',
    '2CR AND ABOVE',
  ];

  @override
  Widget build(BuildContext context) {
    
    postData() async {
      List sendConfig = ModalRoute.of(context)!.settings.arguments as List;
      var curr_date = DateFormat("yyyy-MM-dd").format(
        DateTime.now(),
      );
      Uri url = Uri.parse(
          'https://geteazyapp.com/projects/urbanplace-project-by-urbanplace-210720084736-210720090839/api');
      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');
      final sp = await SharedPreferences.getInstance();
      String? authorization = sp.getString('token');
      String? tokenn = authorization;
      final cookie = sp.getString('cookie');
      final token = await AuthService.getToken();
      final settoken = 'Token ${token['token']}';
      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': settoken,
            HttpHeaders.cookieHeader: setcookie,
          },
          body: jsonEncode(
            {'project': 2, 'mobile': sendConfig[0], 'first_name' : sendConfig[1] , 'last_name' : sendConfig[2]  , 'email' : sendConfig[3],'last_visited': curr_date},
          ));
      print('RESPONSE BODY ${response.body}');
    }

    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: Container(
          height: height * 0.1,
          margin: EdgeInsets.only(top: 2),
          child: SafeArea(
            child: Row(children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.031),
                width: width * 0.50,
                child: SizedBox(
                  height: height * 0.06,
                  child: FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondPage(),
                          ));
                    },
                    child: Text(
                      'Back',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                //height: height * 0.01,
                margin: EdgeInsets.only(top: height * 0.031),
                height: height * 0.12,
                width: width * 0.50,
                child: SizedBox(
                  child: FlatButton(
                    height: 300,
                    color: myColor,
                    onPressed: () {
                      postData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FourthPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: height * 0.1,
                    margin: EdgeInsets.only(top: height * 0.2),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/eazyapp-logo-blue.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  Container(
                    margin: EdgeInsets.only(left: width * 0.12),
                    child: Text(
                      'Requirements',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.025),
                    child: Text(
                      'What configuration are you looking at?',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.12, right: width * 0.12),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: myColor),
                      ),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      iconSize: 46,
                      iconDisabledColor: myColor,
                      iconEnabledColor: myColor,
                      icon: Icon(Icons.arrow_drop_down),
                      underline: SizedBox(),
                      hint: Text(
                        "What is your budget?",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      value: valueChoose,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: myColor, fontSize: 14),
                      ),
                      items: budgetList.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem, child: Text(valueItem));
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          valueChoose = newValue;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.02,
                        left: width * 0.050,
                        right: width * 0.050),
                    child: Column(
                      children: [
                        Text('What is the purpose of your purchase?',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 16))),
                        Row(
                          children: [
                            SizedBox(width: width * 0.04),
                            Radio(
                                value: 1,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value as int;
                                  });
                                }),
                            Text(
                              'Self Use',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.16,
                            ),
                            Radio(
                                value: 2,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value as int;
                                  });
                                }),
                            Text(
                              'Second home',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: width * 0.04),
                            Radio(
                                value: 3,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value as int;
                                  });
                                }),
                            Text(
                              'Investment',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(width: width * 0.10),
                            Radio(
                                value: 4,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value as int;
                                  });
                                }),
                            Text(
                              'Organizational',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.02, right: width * 0.16),
                    child: Text(
                      'Provide your mode of funding',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.050, right: width * 0.050),
                    child: Row(
                      children: [
                        SizedBox(width: width * 0.04),
                        Radio(
                            value: 1,
                            groupValue: _value2,
                            onChanged: (value) {
                              setState(() {
                                _value2 = value as int;
                              });
                            }),
                        Text(
                          'Maximum self',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        SizedBox(width: width * 0.055),
                        Radio(
                            value: 2,
                            groupValue: _value2,
                            onChanged: (value) {
                              setState(() {
                                _value2 = value as int;
                              });
                            }),
                        Text(
                          'Maximum loan',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //color: Colors.grey.shade200,
            ),
          ),
        ),
      ),
    );
  }
}
