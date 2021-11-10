import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:eazy_app/Pages/eazy_visits.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:eazy_app/Pages/customer_check.dart/second.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with AutomaticKeepAliveClientMixin<FirstPage> {
  List sendMobile = [];
  String? project_name;
  final TextEditingController mobileController = TextEditingController();
  String mobile = '';

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
    Uri url = Uri.parse('https://geteazyapp.com/projects/$project_url/api');
    String sessionId = await FlutterSession().get('session');

    String csrf = await FlutterSession().get('csrf');
    final sp = await SharedPreferences.getInstance();
    String? authorization = sp.getString('token');
    String? tokenn = authorization;
    final cookie = sp.getString('cookie');
    final token = await AuthService.getToken();
    final settoken = 'Token ${token['token']}';
    final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
    final project_id = pref.getString('project_id');
    http.Response response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': settoken,
          HttpHeaders.cookieHeader: setcookie,
        },
        body: jsonEncode(
          {
            'project': project_id,
            'mobile': mobileController.text,
            'last_visited': curr_date
          },
        ));
    print('RESPONSE BODY FIRST ${response.body}');
    final body = jsonDecode(response.body);
    final cust_url = body['customer_url'];
    pref.setString('customer_url', cust_url);
    final cust_id = body['id'];
    pref.setInt('cust_id', cust_id);
    final c_id = pref.getInt('cust_id');
    print('--------------$cust_url');
    pref.setString('mobile', mobileController.text);

    sendMobile.add(mobileController.text);
    sendMobile.add(cust_url);

    pref.setString('mobile', mobileController.text);
    final mob = pref.getString('mobile');
    print('-------$mob');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  // TODO: implement wantKeepAlive

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
    bool isLoading = false;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
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
                      onPressed: () async {
                        postData().then((dynamic) {
                          setState(() {
                            isLoading = !isLoading;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SecondPage(),
                                maintainState: true,
                                fullscreenDialog: true),
                          );
                          setState(() {
                            isLoading = !isLoading;
                          });
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
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Center(
              child: Container(
                height: height,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: height * 0.1,
                      margin: EdgeInsets.only(top: height * 0.3),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/eazyapp-logo-blue.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    project_name == null
                        ? Text(
                            'Check In - Loading..',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        : Text(
                            'Check In - $project_name',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                    SizedBox(height: height * 0.02),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: width * 0.075, right: width * 0.075),
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        onChanged: (text) {
                          setState(() {
                            //mobileController.text = text;
                            mobile = text;
                          });
                        },
                        autofocus: true,
                        controller: mobileController,
                        style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        autovalidate: true,
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
                          hintText: 'Enter your 10 digit mobile number',
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.grey.shade700),
                          ),
                        ),
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
    );
  }

  bool get wantKeepAlive => true;
}
