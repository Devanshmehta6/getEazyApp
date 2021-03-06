import 'dart:convert';
import 'dart:io';

import 'package:eazy_app/Pages/customer_check.dart/fourth.dart';
import 'package:eazy_app/Pages/customer_check.dart/second.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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

class Config {
  late String name;
  late String rera;

  Config(this.name, this.rera);
}

class _ThirdPageState extends State<ThirdPage> {
  String? valueChoose;
  String _value = "";
  String _value2 = "";
  bool isLoading = false;
  late Future con;
  final budgetList = [
    '50L - 75L',
    '75L - 1CR',
    '1CR - 1.25CR',
    '1.25CR - 1.50CR',
    '1.50CR - 1.75CR',
    '1.75CR - 2CR',
    '2CR AND ABOVE',
  ];
  List<Config> configurations = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<bool?> checkedValue = [];
  List selectedValue = [];
  postData() async {
    List sendConfig = ModalRoute.of(context)!.settings.arguments as List;
    var curr_date = DateFormat("yyyy-MM-dd").format(
      DateTime.now(),
    );
    final pref = await SharedPreferences.getInstance();
    final project_url = pref.getString('project_url');

    Uri url = Uri.parse(
        'https://geteazyapp.com/projects/$project_url/requirements_api');
    print('---------------$url');
    String sessionId = await FlutterSession().get('session');

    String csrf = await FlutterSession().get('csrf');
    final sp = await SharedPreferences.getInstance();
    String? authorization = sp.getString('token');
    String? tokenn = authorization;
    final cookie = sp.getString('cookie');
    final token = await AuthService.getToken();
    final settoken = 'Token ${token['token']}';
    final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
    final cust_id = sp.getInt('cust_id');
    print('--------third--------$cust_id');
    final project_id = pref.getString('pro_id');
    String config = selectedValue.join(',');
    print('>>>>>>>>    ccnenfiefhoij >>>>>>>>>. $config');
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
          'project': project_id,
          'customer': cust_id,
          'budget': valueChoose,
          'purpose_of_purchase': _value,
          'funding_mode': _value2,
          'residence_configuration': config,
        },
      ),
    );
    print('RESPONSE BODY ${response.body}');
    print('valueeee choose :::: $valueChoose');
    print('valueeee 2 :::: $_value2');
  }

  getConfig() async {
    final pref = await SharedPreferences.getInstance();
    final project_url = pref.getString('project_url');
    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/projects/$project_url/on-going-visits/api');
      print('>>>>>>>>>>>>>>. url get >>>>>>>>>>>>>>... $url');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

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
      print('>>>>>>>> called get config>>>>>>>>>>>..');
      final jsonData = jsonDecode(response.body);
      final config_rcvd = jsonData['project_configuration'][0];
      configurations.clear();
      for (var i in config_rcvd) {
        Config c = Config(i['name'], i['rera']);
        configurations.add(c);
        print('>>>>>>>>  $configurations');
      }
      //print(
      //  '>>>>>>>>>>>>>>>>>>>>>>>>>>>. RESP >>>>>>>>>>>>>. ${response.body}');
    } else {
      print('Logged out ');
    }
    //checkedValue = List<bool?>.filled(configurations.length, false);
    return configurations;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConfig().whenComplete(() {
      checkedValue = List<bool?>.filled(configurations.length, false);
      print('>>>>>>>>>>>     vallllllllue init >>>>.. $checkedValue');
    });
    con = getConfig();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  moveTopreviousScreen() {
    print('----------- is called-----------');
    Navigator.pop(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics().setCurrentScreen(
      screenName: 'Customer Check In Page 3',
      screenClassOverride: 'Customer Check In Page 3',
    );
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () {
          return moveTopreviousScreen();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
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
                          Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SecondPage(),
                                  maintainState: true));
                        },
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 24),
                                  Text(
                                    'Please Wait',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Text(
                                'Back',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Colors.black),
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
                          postData().whenComplete(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FourthPage(),
                                  maintainState: true),
                            );
                          });
                        },
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 24),
                                  Text(
                                    'Please Wait',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Text(
                                'Next',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Colors.white),
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
              child: Form(
                key: formKey,
                child: Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                          margin: EdgeInsets.only(left: width * 0.075),
                          child: Text(
                            'Requirements',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.075, top: height * 0.03),
                          child: Text(
                            'What configuration are you looking at?',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FutureBuilder(
                            future: Future.delayed(
                                Duration(milliseconds: 5), () => con),
                            builder: (context, AsyncSnapshot snapshot) {
                              print(' called called');

                              print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                              print('$checkedValue');

                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return Text('none');
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CircularProgressIndicator());
                                case ConnectionState.active:
                                  return Text('active');
                                case ConnectionState.done:
                                  return Container(
                                    padding: EdgeInsets.only(
                                        left: width * 0.075,
                                        top: height * 0.03),
                                    child: GridView.builder(
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                //childAspectRatio: 0.1,
                                                mainAxisExtent: 35,
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 30),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            children: [
                                              Container(
                                                //margin: EdgeInsets.only(left: 24),
                                                child: Transform.scale(
                                                  scale: 1.25,
                                                  child: Checkbox(
                                                    activeColor: myColor,
                                                    checkColor: Colors.white,
                                                    value: checkedValue[index],
                                                    onChanged: (val) {
                                                      setState(() {
                                                        checkedValue[index] =
                                                            val;
                                                      });
                                                      selectedValue.add(snapshot
                                                          .data[index].name);
                                                      print(
                                                          '>>>>>>>>>>. selectED > $selectedValue');
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${snapshot.data[index].name}",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          );
                                        }),
                                  );
                              }
                            }),
                        SizedBox(height: height * 0.01),
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.075, right: width * 0.075),
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
                              textStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                              left: width * 0.075, top: height * 0.03),
                          child: Text(
                            'What is the purpose of your purchase?',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: width * 0.05),
                                Transform.scale(
                                  scale: 1.1,
                                  child: Radio(
                                      value: "Self Use",
                                      groupValue: _value,
                                      activeColor: myColor,
                                      onChanged: (value) {
                                        setState(() {
                                          _value = value.toString();
                                        });
                                      }),
                                ),
                                Text(
                                  'Self Use',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.16,
                                ),
                                Transform.scale(
                                  scale: 1.1,
                                  child: Radio(
                                      value: "Second Home",
                                      groupValue: _value,
                                      activeColor: myColor,
                                      onChanged: (val) {
                                        setState(() {
                                          _value = val.toString();
                                        });
                                      }),
                                ),
                                Text(
                                  'Second home',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: width * 0.05),
                                Transform.scale(
                                  scale: 1.1,
                                  child: Radio(
                                      value: 'Investment',
                                      groupValue: _value,
                                      activeColor: myColor,
                                      onChanged: (val) {
                                        setState(() {
                                          _value = val.toString();
                                        });
                                      }),
                                ),
                                Text(
                                  'Investment',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                                SizedBox(width: width * 0.09),
                                Transform.scale(
                                  scale: 1.1,
                                  child: Radio(
                                      value: 'Organizational',
                                      groupValue: _value,
                                      activeColor: myColor,
                                      onChanged: (val) {
                                        setState(() {
                                          _value = val.toString();
                                          print(">>>>>>>>>> $_value");
                                        });
                                      }),
                                ),
                                Text(
                                  'Organizational',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.075, top: height * 0.02),
                          child: Text(
                            'Provide your mode of funding',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: width * 0.1),
                          child: Row(
                            children: [
                              SizedBox(width: width * 0.05),
                              Transform.scale(
                                scale: 1.1,
                                child: Radio(
                                    value: 'Maximum Self',
                                    groupValue: _value2,
                                    activeColor: myColor,
                                    onChanged: (value) {
                                      setState(() {
                                        _value2 = value.toString();
                                      });
                                    }),
                              ),
                              Text(
                                'Maximum self',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(fontSize: 15),
                                ),
                              ),
                              SizedBox(width: width * 0.03),
                              Transform.scale(
                                scale: 1.1,
                                child: Radio(
                                    value: 'Maximum Loan',
                                    groupValue: _value2,
                                    activeColor: myColor,
                                    onChanged: (value) {
                                      setState(() {
                                        _value2 = value.toString();
                                      });
                                    }),
                              ),
                              Text(
                                'Maximum Loan',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(fontSize: 15),
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
          ),
        ),
      ),
    );
  }
}
