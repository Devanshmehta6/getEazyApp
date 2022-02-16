import 'dart:convert';
import 'dart:io';
import 'package:eazy_app/Pages/customer_check.dart/second.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:eazy_app/Pages/customer_check.dart/first.dart';
import 'package:eazy_app/Pages/eazy_visits.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CP extends StatefulWidget {
  const CP({Key? key}) : super(key: key);

  @override
  _CPState createState() => _CPState();
}

class _CPState extends State<CP> {
  String? project_name;
  TextEditingController reg_num = TextEditingController();
  TextEditingController cp_name = TextEditingController();
  TextEditingController cp_mobile = TextEditingController();
  TextEditingController cust_mobile = TextEditingController();

  getName() async {
    final pref = await SharedPreferences.getInstance();
    project_name = pref.getString('project_name');
    print('heeeeeeeeeeeeeeeee $project_name');
  }

  postData() async {
    var curr_date = DateFormat("yyyy-MM-dd").format(
      DateTime.now(),
    );
    final pref = await SharedPreferences.getInstance();
    final project_url = pref.getString('project_url');
    Uri url = Uri.parse(
        'https://geteazyapp.com/projects/$project_url/cp-check-in_api');
    String sessionId = await FlutterSession().get('session');

    String csrf = await FlutterSession().get('csrf');
    final sp = await SharedPreferences.getInstance();
    String? authorization = sp.getString('token');
    String? tokenn = authorization;
    final cookie = sp.getString('cookie');
    final token = await AuthService.getToken();
    final settoken = 'Token ${token['token']}';
    final setcookie = "csrftoken=$csrf; sessionid=$sessionId";

    print('--------set cookie--------$setcookie');
    final project_id = pref.getString('pro_id');
    print('================== pro =============== $project_id');
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
          'rera_no': reg_num.text,
          'cp_mobile': cp_mobile.text,
          'mobile': cust_mobile.text,
          'last_visited': curr_date,
          'through': 'Channel Partner',
        },
      ),
    );
    final cp_data = jsonDecode(response.body);
    final cust_url = cp_data['customer_data']['customer_url'];

    pref.setString('customer_url', cust_url);
    final cust_id = cp_data['customer_data']['id'];
    pref.setInt('cust_id', cust_id);
    pref.setString('mobile', cust_mobile.text);
    print('RESPONSE BODY ------------------------  ${response.body}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EazyVisits(),
                              ));
                        },
                        child: Text(
                          'Back',
                          style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(fontSize: 17, color: Colors.black),
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
                                builder: (context) => SecondPage(),
                                maintainState: true),
                          );
                        },
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(fontSize: 17, color: Colors.white),
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
                  child: Column(children: <Widget>[
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
                      margin: EdgeInsets.only(
                          left: width * 0.075, right: width * 0.075),
                      child: project_name == null
                          ? Text(
                              'Channel Partner CheckIn - Loading..',
                              style: GoogleFonts.poppins(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              'Channel Partner CheckIn -${project_name.toString()}',
                              style: GoogleFonts.poppins(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: width * 0.075, right: width * 0.075),
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        autofocus: true,
                        controller: reg_num,
                        style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),

                        

                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: myColor),
                          ),
                          suffixIcon: Icon(FontAwesomeIcons.receipt,
                              color: myColor, size: 20),
                          border: InputBorder.none,
                          hintText: 'Enter RERA Registration Number',
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: width * 0.075, right: width * 0.075),
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: cp_name,
                        style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),

                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: myColor),
                          ),
                          suffixIcon: Icon(FontAwesomeIcons.userAlt,
                              color: myColor, size: 20),
                          border: InputBorder.none,
                          hintText: 'Enter CP Name',
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: width * 0.075, right: width * 0.075),
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: cp_mobile,
                        style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),

                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: myColor),
                          ),
                          suffixIcon:
                              Icon(Icons.phone, color: myColor, size: 20),
                          border: InputBorder.none,
                          hintText: 'Enter CP Mobile Number',
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: width * 0.075, right: width * 0.075),
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: cust_mobile,
                        style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),

                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: myColor),
                          ),
                          suffixIcon:
                              Icon(Icons.phone, color: myColor, size: 20),
                          border: InputBorder.none,
                          hintText: 'Enter Customer Mobile Number',
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            )),
      ),
    );
  }
}
