import 'package:eazy_app/Services/auth_service.dart';
import 'package:eazy_app/sales%20part/view_details.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class RevisitLog extends StatefulWidget {
  const RevisitLog({Key? key}) : super(key: key);

  @override
  _RevisitLogState createState() => _RevisitLogState();
}

class _RevisitLogState extends State<RevisitLog> {
  bool isLoading = false;
  final items = ['hot', 'warm', 'cold', 'lost'];
  String? valueChoose;
  dynamic date = DateTime(2021);
  String send = '';
  TimeOfDay time = TimeOfDay(hour: 10, minute: 0);
  String? descrp;
  TextEditingController feedback = TextEditingController();
  TextEditingController feedback_with_value = TextEditingController();
  String? status;
  String? feedback_str;
  String from_which = '';

  sendFollowup() async {
    final pref = await SharedPreferences.getInstance();
    final cust_url = pref.getString('cust_url');
    final project_url = pref.getString('project_url');
    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse('https://geteazyapp.com/checkout/feedback_api');
      print('>>>>>>> url <>>>>>>>> $url');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();
      final cust_id = sp.getInt('cust_id');
      print('-----------$cust_id');
      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";

      print('-----1111111111111111 $valueChoose');
      print('---------22222222222222222 ${feedback.text}');
      print('-------333333333333 $date $time');
      // final date_to_send = DateFormat("yy-MM-dd hh:mm:ss").parse('$date ${time.hour}:${time.minute}');
      print('############ $send');
      http.Response response = from_which == 'New'
          ? await http.post(url, headers: {
              //'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': settoken,
              HttpHeaders.cookieHeader: setcookie,
            }, body: {
              'customer': cust_id.toString(),
              'status': valueChoose.toString().toLowerCase(),
              'feedback': feedback.text,
              'date_time': send
            })
          : await http.put(url, headers: {
              //'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': settoken,
              HttpHeaders.cookieHeader: setcookie,
            }, body: {
              'customer': cust_id.toString(),
              'status': valueChoose.toString().toLowerCase(),
              'feedback': feedback.text,
              'date_time': send
            });
      final jsonData = jsonDecode(response.body);

      print('>>>>>>>> PUT FOLLOW UP >>>>>>>>. $jsonData');
    } else {
      print('Logged out ');
    }
  }

  getData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      status = pref.getString('status');
      feedback_str = pref.getString('feedback');
      feedback_with_value = TextEditingController(text: feedback_str);
      from_which = pref.getString('from');
    });

    print('------------------- $status');
    print('---------------- $feedback_str');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    getData();
    print('-------descp ---------------$descrp');
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics().setCurrentScreen(
      screenName: 'Log a Revisit',
      screenClassOverride: 'Log a Revisit',
    );
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
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Row(
              children: <Widget>[
                SizedBox(width: width * 0.20),
                Text(
                  'EazyCustomers',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: myColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(width: width * 0.20),
                Image.asset('images/eazyapp-logo-blue.png',
                    height: 45, width: 40),
              ],
            ),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
            ),
            iconTheme: IconThemeData(color: Colors.blue.shade800),
          ),
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
                        );
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
                        sendFollowup();
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  child: Card(
                    color: Colors.grey.shade300,
                    elevation: 0,
                    child: Center(
                        child: Text(
                      'Log a ReVisit',
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.black),
                    )),
                  ),
                ),
                Container(
                  height: 35,
                  width: double.infinity,
                  // margin: EdgeInsets.only(left: 0, right: 0),
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.only(top: 20, left: 35, right: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                      top: BorderSide(color: Colors.grey),
                      left: BorderSide(color: Colors.grey),
                      right: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: DropdownButton<String>(
                    hint: Text(
                      'Status',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                    ),
                    isExpanded: true,
                    iconSize: 30,
                    iconEnabledColor: Colors.grey,
                    icon: Icon(Icons.arrow_drop_down),
                    underline: SizedBox(),
                    //hint : Text(' $valueChoose'),
                    value: from_which == 'New'
                        ? valueChoose
                        : status!.toLowerCase(),

                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    items: items.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem));
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        //print('>>>>>>>>>>>>>>..  ${valueChoose!.toLowerCase()}');
                        valueChoose = newValue;
                        //print('>>>>>>>>>>>>>>..  ${valueChoose!.toLowerCase()}');
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  //height: 80,

                  width: double.infinity,
                  margin: EdgeInsets.only(top: 30, left: 35, right: 18),
                  child: TextFormField(
                    controller:
                        from_which == 'New' ? feedback : feedback_with_value,
                    style:
                        GoogleFonts.poppins(fontSize: 15, color: Colors.black),
                    minLines: 7,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.only(
                          left: 15, top: 11, right: 15, bottom: 10),
                      hintText: 'Describe the visit',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                from_which == 'New'
                    ? Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 35, top: 17),
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.calendarAlt),
                                  Container(
                                    height: height * 0.07,
                                    //width: width * 0.4,
                                    child: FlatButton(
                                      onPressed: () {
                                        pickDate(context).whenComplete(() {
                                          pickTime(context);
                                        });
                                      },
                                      child: date == DateTime(2021) &&
                                              time ==
                                                  TimeOfDay(hour: 10, minute: 0)
                                          ? Text(
                                              'Visited Time and Date',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              '$date ${time.hour}:${time.minute}',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: date == DateTime(2021) ? initialDate : date,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1));
    if (newDate == null) return;
    setState(() {
      send = newDate.toString();
      final format = DateFormat.yMMMMd('en_US').format(newDate);
      //format.format(newDate);
      date = format;
    });
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 10, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time == TimeOfDay(hour: 10, minute: 0) ? initialTime : time,
    );

    if (newTime == null) return;
    setState(() {
      time = newTime;
    });
  }
}
