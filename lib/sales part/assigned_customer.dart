import 'dart:async';
import 'package:eazy_app/sales%20part/customers.dart';
import 'package:eazy_app/sales%20part/view_details.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:core';

class BasicInfo {
  late String first_name;
  late String last_name;
  late String email;
  late String phone;
  late String whatsapp_no;
  late String residence_address;

  BasicInfo(this.first_name, this.last_name, this.email, this.phone,
      this.whatsapp_no, this.residence_address);
}

class Config {
  late String name;
  late int rera_carpet;

  Config(this.name, this.rera_carpet);
}

class AssignedCustomer extends StatefulWidget {
  const AssignedCustomer({Key? key}) : super(key: key);

  @override
  _AssignedState createState() => _AssignedState();
}

class _AssignedState extends State<AssignedCustomer> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? cust_name;
  String? cust_url;
  Color myColor = Color(0xff4044fc);
  int currentStep = 0;
  bool _isEnabled = false;
  TextEditingController res_add = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController whatsapp = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController curr_resi = TextEditingController();
  TextEditingController family_type = TextEditingController();
  TextEditingController config_req = TextEditingController();
  TextEditingController feedback = TextEditingController();
  List customers = [];
  late Future myFuture;
  late StreamController _streamController_basic_info;
  late Stream _stream_basic_info;
  late StreamController _streamController_work_info;
  late Stream _stream_work_info;
  late StreamController _streamController_req;
  late Stream _stream_req;
  String project_url = '';
  String project_name = '';
  late String mobile;
  late final project;
  late final current_residence;
  late final cust_id;
  List<Config> configurations = [];
  late final assign_to;
  late final was_assign;

  List<bool?> checkedValue = [];

  Future getUrl() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse('https://geteazyapp.com/checkout/customer_api');

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
      //print(response.body);
      print('>>>>>>>>>>>>>>>>>>> CUST ${response.body}');
      final resp = jsonDecode(response.body);
      cust_name = resp[0]['customers']['customer_name'];
      cust_url = resp[0]['customers']['customers_url'];
    } else {
      print('Logged out ');
    }
    return cust_name;
  }

  getData() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/EazyCustomersform/$cust_url/customer_api');

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
      //print(response.body);
      print('>>>>GET RESSSSS ????????????    >. ${response.body}');
      final jsonData = jsonDecode(response.body);
      print('>>>>>>>>>>>>>>>>......... ${jsonData[0]['requirement']}');
      project_url = jsonData[0]['project'][0]['project_url'];
      pref.setString('project_url', project_url);
      mobile = jsonData[0]['customers'][0]['mobile'];
      project = jsonData[0]['customers'][0]['project'].toString();
      project_name = jsonData[0]['project'][0]['project_name'];
      pref.setString('project_name', project_name);
      current_residence = jsonData[0]['customers'][0]['current_residence'];
      cust_id = jsonData[0]['workinfo'][0][0]['customer'];
      assign_to = jsonData[0]['customers'][0]['assign_to'];
      was_assign = jsonData[0]['customers'][0]['was_assign'];
      print('?????????????? $was_assign');
      print('?????????????? $assign_to');
      _streamController_basic_info.add([
        jsonData[0]['customers'][0]['first_name'],
        jsonData[0]['customers'][0]['last_name'],
        jsonData[0]['customers'][0]['email'],
        jsonData[0]['customers'][0]['mobile'],
        jsonData[0]['customers'][0]['whatsapp_no'],
        jsonData[0]['customers'][0]['residence_address']
      ]);
      _streamController_work_info.add([
        jsonData[0]['workinfo'][0][0]['occupation'],
        jsonData[0]['workinfo'][0][0]['organization'],
        jsonData[0]['workinfo'][0][0]['location'],
        jsonData[0]['workinfo'][0][0]['designtion']
      ]);
      _streamController_req.add([
        jsonData[0]['requirement'][0][0]['residence_configuration'],
        jsonData[0]['requirement'][0][0]['budget'],
        jsonData[0]['requirement'][0][0]['funding_mode'],
        jsonData[0]['requirement'][0][0]['purpose_of_purchase']
      ]);
    } else {
      print('Logged out ');
    }
  }

  putBasic() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/api-checkout/$project_url/$cust_url/personal_info_api');
      print('>>>>>>> url <>>>>>>>> $url');
      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.put(url, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      }, body: {
        'mobile': mobile,
        'project': project,
        'project_name': project_name,
        'whatsapp_no': whatsapp.text,
        'residence_address': res_add.text,
      });
      print('>>>>>>>> response >>>>>>>>. ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  putWork(String state, String pincode) async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/api-checkout/$project_url/workinfo_api');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.post(url, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      }, body: {
        'mobile': mobile,
        'project': project,
        'project_name': project_name,
        'state': state,
        'pincode': pincode
      });
      print('11111111111111111 ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  putReq(String config_requi) async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/api/checkout/$project_url/$cust_url/requirement_info_api');
      print('>>>>>>>>>>> url put >>>>>>>>> $url');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');
      print('?>>>>>>>>>>>>>>>>>>>>>>>>>');
      print(cust_id.runtimeType);
      print(cust_id);
      print('============$_value');
      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.put(url, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      }, body: {
        //'mobile': mobile,
        //'project': project,
        //'project_name': project_name,
        'customer': cust_id.toString(),
      });
      print('22222222222222222222 ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  putReq1() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/api-checkout/$project_url/$cust_url/personal_info_api');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.put(url, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      }, body: {
        'mobile': mobile,
        'project': project.toString(),
        'project_name': project_name,
        'family_type': _value,
        'current_residence': _value1,
      });
      print('>>>>> response > ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  checkoutfunc() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse('https://geteazyapp.com/checkout/feedback_api');

      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();

      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');

      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.put(url, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      }, body: {
        'feedback': feedback.text,
        'status': valueChoose!.toLowerCase(),
        'customer': cust_id.toString(),
        'date_time': '${DateTime.now()}',
        //'customer_checked_out': 1.toString(),
      });

      print(
          '>>>>>>>>>>>>>>>>>>>>>>>>>>>. RESP >>>>>>>>>>>>>. ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  checked_out() async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/api-checkout/$project_url/$cust_url/personal_info_api');
      print('>>>>>>> url <>>>>>>>> $url');
      String sessionId = await FlutterSession().get('session');

      String csrf = await FlutterSession().get('csrf');

      final sp = await SharedPreferences.getInstance();
      //print('>>>>>>>>>>>> >>>>>>>>. ${assign_to.runtimeType}');
      //final finalToken = 'Token ${token[token]}';

      final cookie = sp.getString('cookie');
      //print('?????????????? 4444444 $was_assign');
      final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
      http.Response response = await http.put(url, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      }, body: {
        'mobile': mobile,
        'assign_to': assign_to.toString(),
        'project': project.toString(),
        'project_name': project_name,
        'checked_out': 'true',
        //'assign_to': assign_to,
        'was_assign': assign_to.toString(),
      });
      print('>>>>>>>> checkout response >>>>>>>>. ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  //checkedValue = List<bool?>.filled(configurations.length, false);

  void initState() {
    super.initState();
    _streamController_basic_info = BehaviorSubject();
    _stream_basic_info = _streamController_basic_info.stream;
    _streamController_work_info = BehaviorSubject();
    _stream_work_info = _streamController_work_info.stream;
    _streamController_req = BehaviorSubject();
    _stream_req = _streamController_req.stream;

    getUrl().whenComplete(() {
      getData();
    });

    //getConfig();
    // getConfig().whenComplete(
    //  () => checkedValue = List<bool?>.filled(configurations.length, false),
    //);
  }

  final items = ['Hot', 'Warm', 'Cold', 'Lost'];
  final family = ['  Joint Family', '  Nuclear Family'];
  String? valueChoose;
  String? valueChoose2;
  int activeStep = 0; // Initial step set to 5.

  int upperBound = 3;
  bool isLoading = false;
  bool changed = false;
  bool changedL = false;
  String _value = "";
  String _value1 = "";
  String _value2 = "";

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics().setCurrentScreen(
        screenName: 'Assigned Customer Page',
        screenClassOverride: 'Assigned Customer Page');
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    return GestureDetector(
      onTap: () {
        setState(() {
          changedL = false;
          changed = false;
        });
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //centerTitle : true,
          iconTheme: IconThemeData(color: myColor),
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              SizedBox(width: width * 0.12),
              Text(
                'Customer CheckOut',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: myColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: width * 0.155),
              Image.asset(
                'images/eazyapp-logo-blue.png',
                height: 48,
                width: 40,
              ),
            ],
          ),
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
                      if (activeStep == 0) {
                        setState(() {
                          activeStep = 0;
                        });
                      } else {
                        setState(() {
                          --activeStep;
                        });
                      }
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
                    onPressed: () async {
                      if (activeStep == 0) {
                        putBasic();
                      } else if (activeStep == 1) {
                        putWork(state.text, pincode.text);
                      } else if (activeStep == 2) {
                        //putReq(config_req.text);
                        putReq1();
                      } else if (activeStep == 3) {
                        print('>>>>> test ?>>>>');
                        checkoutfunc();
                        checked_out();
                      } else {
                        print('>>> else on pressed');
                      }

                      if (activeStep < upperBound) {
                        setState(() {
                          ++activeStep;
                        });
                        if (activeStep == 1) {
                          //getConfig();
                          //checkedValue = List<bool?>.filled(configurations.length, false);

                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EazyCustomers(),
                            settings: RouteSettings(arguments: project_name),
                          ),
                        );
                      }

                      setState(() {
                        isLoading = !isLoading;
                      });
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
        key: _scaffoldKey,
        body: GestureDetector(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Theme(
              data: ThemeData(
                  colorScheme: ColorScheme.light(primary: Colors.white)),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: height * 0.07,
                    color: Color(0xff007bff),
                    child: Container(
                      padding: EdgeInsets.only(left: 10, top: 12),
                      child: FutureBuilder(
                          future: getUrl(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Text('none');
                              case ConnectionState.active:
                                return Text('active');
                              case ConnectionState.waiting:
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              case ConnectionState.done:
                                return Text(
                                  "Managing site visit for : ${snapshot.data} ",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, color: Colors.white),
                                ); //Image.network('${snapshot.data}');
                            }
                          }),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15),
                    child: IconStepper(
                      enableNextPreviousButtons: false,
                      enableStepTapping: false,
                      stepPadding: 0,
                      stepColor: Colors.grey.shade400,
                      activeStepColor: myColor,
                      activeStepBorderColor: myColor,
                      activeStepBorderWidth: 1,
                      activeStep: activeStep,
                      icons: [
                        Icon(FontAwesomeIcons.user, color: Colors.white),
                        Icon(FontAwesomeIcons.building, color: Colors.white),
                        Icon(FontAwesomeIcons.briefcase, color: Colors.white),
                        Icon(FontAwesomeIcons.check, color: Colors.white)
                      ],
                      onStepReached: (index) {
                        setState(() {
                          activeStep = index;
                        });
                      },
                    ),
                  ),
                  Divider(color: Colors.grey.shade400, thickness: 1),
                  Container(
                    child: Text('${headerText()}',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  Divider(color: Colors.grey.shade400, thickness: 1),
                  body()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget basic() {
    return StreamBuilder(
      stream: _stream_basic_info,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //print('+++++++++++++++++++++++++++++      ${snapshot.connectionState}');

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('none');
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            return Container(
              padding: EdgeInsets.only(top: 10, left: 25),
              height: 380,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'First Name: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            readOnly: true,
                            //controller: fname..text = ftext,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: '${snapshot.data[0]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE
                            //enabled: _isEnabled,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() {});
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Last Name: ',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: '${snapshot.data[1]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    print('change in  second   $changed'),
                                    changedL = !changedL,
                                  });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Email: ',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: '${snapshot.data[2]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    changed = !changed,
                                  });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Phone: ',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: '${snapshot.data[3]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    changed = !changed,
                                  });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Whatsapp: ',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            //initialValue: '${snapshot.data[4]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            onEditingComplete: () {
                              setState(() => {
                                    changed = !changed,
                                  });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          'Residential Address: ',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(right: 10 , top : 5),
                      child: TextFormField(
                          controller: res_add,
                          minLines: 6,
                          maxLines: null,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500),
                            ),
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                          ),
                          //initialValue: '${snapshot.data[5]}',
                          style: GoogleFonts.poppins(
                              fontSize: 18), // GIVE THE NAME HERE

                          onEditingComplete: () {
                            print('>>>>>>>>>>>>>>>>>>>>>>> ${res_add.text}');
                          }),
                    ),
                  ),
                ],
              ),
            );
          case ConnectionState.done:
            return Text('done');
        }
      },
    );
  }

  Widget work() {
    return StreamBuilder(
      stream: _stream_work_info,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('none');
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            return Container(
              padding: EdgeInsets.only(top: 10, left: 25),
              height: 350,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Occupation: ',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: '${snapshot.data[0]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Organization: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: '${snapshot.data[1]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Office Location: ',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: '${snapshot.data[2]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Designation: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: '${snapshot.data[3]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'State: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            controller: state,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Pincode: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            controller: pincode,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            //initialValue: '${snapshot.data[5]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            );
          case ConnectionState.done:
            return Text('done');
        }
      },
    );
  }

  Widget req() {
    //getConfig();

    return StreamBuilder(
      stream: _stream_req,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('none');
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            return Container(
              padding: EdgeInsets.only(top: 10, left: 25),
              height: 380,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 210),
                    child: Text(
                      'Current Residence:',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio(
                                value: "Self Owned",
                                groupValue: _value1,
                                activeColor: myColor,
                                onChanged: (value) {
                                  setState(() {
                                    _value1 = value.toString();
                                  });
                                }),
                            Text(
                              'Self Owned',
                              style: GoogleFonts.poppins(fontSize: 18),
                            ),
                            SizedBox(width: 20),
                            Radio(
                                value: "Leased",
                                groupValue: _value,
                                activeColor: myColor,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value.toString();
                                  });
                                }),
                            Text(
                              'Leased',
                              style: GoogleFonts.poppins(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 270),
                    child: Text(
                      'Family Type:',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          //margin: EdgeInsets.only(left: 0, right: 0),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                  value: "Joint Family",
                                  groupValue: _value,
                                  activeColor: myColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value.toString();
                                      print('>>>>>>> _value -------- $_value');
                                    });
                                  }),
                              Text(
                                'Joint Family',
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                              Radio(
                                  value: "Nuclear Family",
                                  groupValue: _value,
                                  activeColor: myColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value.toString();
                                    });
                                  }),
                              Text(
                                'Nuclear Family',
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 6, bottom: 10, right: 8),
                        child: Text(
                          'Configuration Required: ',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        '${snapshot.data[0]}',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Budget: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: '${snapshot.data[1]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Mode of Funding: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: '${snapshot.data[2]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Purpose of Purchase: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: '${snapshot.data[3]}',
                            style: GoogleFonts.poppins(
                                fontSize: 18), // GIVE THE NAME HERE

                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            );
          case ConnectionState.done:
            return Text('done');
        }
      },
    );
  }

  Widget checkOut() {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 25, right: 20),
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: TextFormField(
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
              controller: feedback,
              minLines: 6,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: 'Provide your Feedback.',
                hintStyle:
                    GoogleFonts.poppins(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            //margin: EdgeInsets.only(left: 0, right: 0),
            padding: EdgeInsets.all(5),
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
              isExpanded: true,
              iconSize: 40,
              iconEnabledColor: Colors.grey,
              icon: Icon(Icons.arrow_drop_down),
              underline: SizedBox(),
              hint: Text(
                " Status",
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              value: valueChoose,
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
        ],
      ),
    );
  }

  Widget body() {
    switch (activeStep) {
      case 0:
        return basic();
      case 1:
        return work();
      case 2:
        return req();
      case 3:
        return checkOut();

      default:
        return Text('');
    }
  }

  String headerText() {
    switch (activeStep) {
      case 0:
        return 'Basic Information';

      case 1:
        return 'Work Information';

      case 2:
        return 'Requirments';

      case 3:
        return 'Check Out';

      default:
        return '';
    }
  }
}
