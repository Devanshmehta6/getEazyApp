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

class AssginedCustomer extends StatefulWidget {
  const AssginedCustomer({Key? key}) : super(key: key);

  @override
  _AssginedCustomerState createState() => _AssginedCustomerState();
}

class _AssginedCustomerState extends State<AssginedCustomer> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? cust_name;
  String? cust_url;
  Color myColor = Color(0xff4044fc);
  int currentStep = 0;
  bool _isEnabled = false;
  List<BasicInfo> basic_info = [];
  List customers = [];

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
      print('>>>>>>>>>>>>>>>>>>>. ${response.body}');
      final jsonData = jsonDecode(response.body);
      customers.addAll([
        jsonData[0]['customers'][0]['first_name'],
        jsonData[0]['customers'][0]['last_name'],
        jsonData[0]['customers'][0]['email'],
        jsonData[0]['customers'][0]['mobile'],
        jsonData[0]['customers'][0]['whatsapp_no'],
        jsonData[0]['customers'][0]['residence_address']
      ]);

      print('>>>>>>>> CUST AFTER ASSIGN >>>>>>>>>.. $customers');
    } else {
      print('Logged out ');
    }

    return customers;
  }

  void initState() {
    super.initState();
    getData();
    getUrl().whenComplete(() {
      getData();
      WidgetsBinding.instance!.addPostFrameCallback(
        (_) => _scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 10),
            backgroundColor: myColor,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            elevation: 10,
            content: Text(
              "Managing site visit for : $cust_name ",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        //centerTitle : true,
        iconTheme: IconThemeData(color: myColor),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            SizedBox(width: width * 0.10),
            Text(
              'Customer CheckOut',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: myColor, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(width: width * 0.135),
            Image.asset(
              'images/eazyapp-logo-blue.png',
              height: 48,
              width: 40,
            ),
          ],
        ),
      ),
      body: Theme(
        data: ThemeData(
            colorScheme: ColorScheme.light(primary: Color(0xff17a2b8))),
        child: Stepper(
          elevation: 0,
          type: StepperType.vertical,
          steps: steps(),
          currentStep: currentStep,
          onStepContinue: () {
            final isLastStep = currentStep == steps().length - 1;
            if (isLastStep) {
              print('LAST STEP');
            } else {
              setState(() {
                currentStep += 1;
              });
            }
          },
          onStepCancel: currentStep == 0
              ? null
              : () => setState(() {
                    currentStep -= 1;
                  }),
        ),
      ),
    );
  }

  List<Step> steps() => [
        Step(
          isActive: currentStep >= 0,
          title: Row(
            children: [
              Text('Basic Info', style: GoogleFonts.poppins(fontSize: 15)),
              SizedBox(width: 200),
              Expanded(
                flex: 2,
                child: Container(
                  //margin: EdgeInsets.only(bottom: 18),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(FontAwesomeIcons.edit,
                        size: 20, color: Color(0xff17a2b8)),
                    onPressed: () {
                      print('executed edit');
                      setState(() {
                        _isEnabled = true;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(FontAwesomeIcons.save,
                        size: 20, color: Color(0xff17a2b8)),
                    onPressed: () {
                      print('executed');
                      setState(() {
                        _isEnabled = !_isEnabled;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          content: FutureBuilder(
            future: Future.delayed(Duration(seconds: 1), () => getData()),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('none');
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                  return Text('active');
                case ConnectionState.done:
                  return Container(
                    height: 290,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('First Name : ',
                                style: GoogleFonts.poppins(fontSize: 15)),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                  ),
                                  initialValue: '${snapshot.data[0]}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15), // GIVE THE NAME HERE
                                  enabled: _isEnabled,
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
                            Text('Last Name : ',
                                style: GoogleFonts.poppins(fontSize: 15)),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                  ),
                                  initialValue: '${snapshot.data[1]}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15), // GIVE THE NAME HERE
                                  enabled: _isEnabled,
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
                            Text('Email : ',
                                style: GoogleFonts.poppins(fontSize: 15)),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                  ),
                                  initialValue: '${snapshot.data[2]}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15), // GIVE THE NAME HERE
                                  enabled: _isEnabled,
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
                            Text('Phone : ',
                                style: GoogleFonts.poppins(fontSize: 15)),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                  ),
                                  initialValue: '${snapshot.data[3]}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15), // GIVE THE NAME HERE
                                  enabled: _isEnabled,
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
                            Text('Whatsapp : ',
                                style: GoogleFonts.poppins(fontSize: 15)),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                  ),
                                  initialValue: '${snapshot.data[4]}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15), // GIVE THE NAME HERE
                                  enabled: _isEnabled,
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
                            Text('Residential Address  : ',
                                style: GoogleFonts.poppins(fontSize: 15)),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                  ),
                                  initialValue: '${snapshot.data[5]}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15), // GIVE THE NAME HERE
                                  enabled: _isEnabled,
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
              }
            },
          ),
        ),
        Step(
          isActive: currentStep >= 1,
          title: Row(
            children: [
              Text('Work Info', style: GoogleFonts.poppins(fontSize: 15)),
              SizedBox(width: 200),
              Expanded(
                flex: 2,
                child: Container(
                  //margin: EdgeInsets.only(bottom: 18),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(FontAwesomeIcons.edit,
                        size: 20, color: Color(0xff17a2b8)),
                    onPressed: () {
                      print('executed edit');
                      setState(() {
                        _isEnabled = true;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(FontAwesomeIcons.save,
                        size: 20, color: Color(0xff17a2b8)),
                    onPressed: () {
                      print('executed');
                      setState(() {
                        _isEnabled = !_isEnabled;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          content: Container(),
        ),
        Step(
          isActive: currentStep >= 2,
          title: Text('Requirements', style: GoogleFonts.poppins(fontSize: 14)),
          content: Container(),
        ),
        Step(
          isActive: currentStep >= 3,
          title: Text('Check Out', style: GoogleFonts.poppins(fontSize: 14)),
          content: Container(),
        ),
      ];
}
