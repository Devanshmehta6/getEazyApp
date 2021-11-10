import 'dart:async';
import 'package:eazy_app/sales%20part/view_details.dart';
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
  TextEditingController res_add = TextEditingController();
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
  int activeStep = 1;
  int upperBound = 3;

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
      project_url = jsonData[0]['project'][0]['project_url'];
      mobile = jsonData[0]['customers'][0]['mobile'];
      project = jsonData[0]['customers'][0]['project'].toString();
      project_name = jsonData[0]['project'][0]['project_name'];
      current_residence = jsonData[0]['customers'][0]['current_residence'];
      cust_id = jsonData[0]['workinfo'][0][0]['customer'];
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
        jsonData[0]['requirement'][0][0]['budget'],
        jsonData[0]['requirement'][0][0]['funding_mode'],
        jsonData[0]['requirement'][0][0]['purpose_of_purchase']
      ]);
    } else {
      print('Logged out ');
    }
  }

  putBasic(String resi_add) async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/projects/$project_url/$cust_url/api');

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
        'residence_address': resi_add,
      });
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
          'https://geteazyapp.com/projects/$project_url/workinfo_api');

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
          'https://geteazyapp.com/projects/$project_url/requirements_api');

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
        'customer': cust_id,
        'residence_configuration': config_requi,
      });
      print('22222222222222222222 ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  putReq1(String family_type) async {
    final pref = await SharedPreferences.getInstance();

    final isLoggedIn = pref.getBool('log');
    print('Logged in dashboard : $isLoggedIn');

    if (isLoggedIn == true) {
      final token = await AuthService.getToken();
      //print('TOKENENNENEN :$token');
      final settoken = 'Token ${token['token']}';

      Uri url = Uri.parse(
          'https://geteazyapp.com/projects/$project_url/$cust_url/api');

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
        'family_type': family_type
      });
    } else {
      print('Logged out ');
    }
  }

  checkout() async {
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
      http.Response response = await http.post(url, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': settoken,
        HttpHeaders.cookieHeader: setcookie,
      }, body: {
        'feedback': feedback.text,
        'status': valueChoose,
        'customer': cust_id.toString(),
        'date_time': '${DateTime.now()}',
        'checked_out': 'True'
      });

      print(
          '>>>>>>>>>>>>>>>>>>>>>>>>>>>. RESP >>>>>>>>>>>>>. ${response.body}');
    } else {
      print('Logged out ');
    }
  }

  void initState() {
    super.initState();
    _streamController_basic_info = StreamController();
    _stream_basic_info = _streamController_basic_info.stream;
    _streamController_work_info = StreamController();
    _stream_work_info = _streamController_work_info.stream;
    _streamController_req = StreamController();
    _stream_req = _streamController_req.stream;
    getUrl().whenComplete(() {
      getData();
      WidgetsBinding.instance!.addPostFrameCallback(
        (_) => _scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: myColor,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
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

  final items = ['Hot', 'Warm', 'Cold', 'Lost'];
  String? valueChoose;

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
            SizedBox(width: width * 0.13),
            Text(
              'Customer CheckOut',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: myColor, fontSize: 16, fontWeight: FontWeight.w600),
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
      body: Theme(
        data: ThemeData(colorScheme: ColorScheme.light(primary: Colors.white)),
        child: IconStepper(
          activeStepColor: Colors.white,
          icons: [
            Icon(FontAwesomeIcons.user, color: myColor),
            Icon(FontAwesomeIcons.building, color: myColor),
            Icon(FontAwesomeIcons.cogs, color: myColor),
            Icon(FontAwesomeIcons.check, color: myColor)
          ],
        ),
      ),
    );

//       body: Theme(
//         data: ThemeData(
//             colorScheme: ColorScheme.light(primary: Color(0xff17a2b8))),
//         child: Stepper(
//           elevation: 0,
//           type: StepperType.vertical,
//           steps: steps(),
//           currentStep: currentStep,
//           onStepContinue: () {
//             final isLastStep = currentStep == steps().length - 1;
//             if (isLastStep) {
//               checkout();
//             } else {
//               setState(() {
//                 currentStep += 1;
//               });
//             }
//           },
//           onStepCancel: currentStep == 0
//               ? null
//               : () => setState(() {
//                     currentStep -= 1;
//                   }),
//         ),
//       ),
//     );
//   }

//   List<Step> steps() => [
//         Step(
//           isActive: currentStep >= 0,
//           title: currentStep == 0
//               ? Row(
//                   children: [
//                     Text('Basic Info',
//                         style: GoogleFonts.poppins(fontSize: 15)),
//                     SizedBox(width: 200),
//                     Expanded(
//                       flex: 2,
//                       child: Container(
//                         //margin: EdgeInsets.only(bottom: 18),
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           icon: Icon(FontAwesomeIcons.edit,
//                               size: 20, color: Color(0xff17a2b8)),
//                           onPressed: () {
//                             print('executed edit');
//                             setState(() {
//                               _isEnabled = true;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           icon: Icon(FontAwesomeIcons.save,
//                               size: 20, color: Color(0xff17a2b8)),
//                           onPressed: () async {
//                             putBasic(res_add.text);
//                             print('executed');
//                             setState(() {
//                               _isEnabled = !_isEnabled;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : Text('Basic Info', style: GoogleFonts.poppins(fontSize: 15)),
//           content: StreamBuilder(
//             stream: _stream_basic_info,
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               //print('+++++++++++++++++++++++++++++      ${snapshot.connectionState}');
//               switch (snapshot.connectionState) {
//                 case ConnectionState.none:
//                   return Text('none');
//                 case ConnectionState.waiting:
//                   return Center(child: CircularProgressIndicator());
//                 case ConnectionState.active:
//                   return Container(
//                     height: 290,
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Text('First Name : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[0]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Last Name : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[1]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Email : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[2]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Phone : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[3]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Whatsapp : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[4]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Residential Address  : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   controller: res_add,
//                                   maxLines: null,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   //initialValue: '${snapshot.data[5]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     print(
//                                         '>>>>>>>>>>>>>>>>>>>>>>> ${res_add.text}');
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 case ConnectionState.done:
//                   return Text('done');
//               }
//             },
//           ),
//         ),
//         Step(
//           isActive: currentStep >= 1,
//           title: currentStep == 1
//               ? Row(
//                   children: [
//                     Text('Work Info', style: GoogleFonts.poppins(fontSize: 15)),
//                     SizedBox(width: 200),
//                     Expanded(
//                       flex: 2,
//                       child: Container(
//                         //margin: EdgeInsets.only(bottom: 18),
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           icon: Icon(FontAwesomeIcons.edit,
//                               size: 20, color: Color(0xff17a2b8)),
//                           onPressed: () {
//                             print('executed edit');
//                             setState(() {
//                               _isEnabled = true;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           icon: Icon(FontAwesomeIcons.save,
//                               size: 20, color: Color(0xff17a2b8)),
//                           onPressed: () {
//                             putWork(state.text, pincode.text);
//                             print('executed');
//                             setState(() {
//                               _isEnabled = !_isEnabled;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : Text('Work Info', style: GoogleFonts.poppins(fontSize: 15)),
//           content: StreamBuilder(
//             stream: _stream_work_info,
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.none:
//                   return Text('none');
//                 case ConnectionState.waiting:
//                   return Center(child: CircularProgressIndicator());
//                 case ConnectionState.active:
//                   return Container(
//                     height: 290,
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Text('Occupation : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[0]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Organization : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[1]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Office Location : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[2]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Designation : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[3]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('State : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   controller: state,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Pincode  : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   controller: pincode,
//                                   maxLines: null,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   //initialValue: '${snapshot.data[5]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 case ConnectionState.done:
//                   return Text('done');
//               }
//             },
//           ),
//         ),
//         Step(
//           isActive: currentStep >= 2,
//           title: currentStep == 2
//               ? Row(
//                   children: [
//                     Text('Requirements',
//                         style: GoogleFonts.poppins(fontSize: 15)),
//                     SizedBox(width: 165),
//                     Expanded(
//                       flex: 2,
//                       child: Container(
//                         //margin: EdgeInsets.only(bottom: 18),
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           icon: Icon(FontAwesomeIcons.edit,
//                               size: 20, color: Color(0xff17a2b8)),
//                           onPressed: () {
//                             print('executed edit');
//                             setState(() {
//                               _isEnabled = true;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           icon: Icon(FontAwesomeIcons.save,
//                               size: 20, color: Color(0xff17a2b8)),
//                           onPressed: () async {
//                             putReq(config_req.text);
//                             putReq1(family_type.text);
//                             print('executed');
//                             setState(() {
//                               _isEnabled = !_isEnabled;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : Text('Requirements', style: GoogleFonts.poppins(fontSize: 15)),
//           content: StreamBuilder(
//             stream: _stream_req,
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.none:
//                   return Text('none');
//                 case ConnectionState.waiting:
//                   return Center(child: CircularProgressIndicator());
//                 case ConnectionState.active:
//                   return Container(
//                     height: 290,
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Text('Current Residence Type : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '$current_residence',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Family Type : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   controller: family_type,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Configuration Required : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   controller: config_req,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Budget : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[0]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Mode of Funding : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[1]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text('Purpose of Purchase  : ',
//                                 style: GoogleFonts.poppins(fontSize: 15)),
//                             Expanded(
//                               flex: 1,
//                               child: TextFormField(
//                                   maxLines: null,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     enabledBorder: UnderlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colors.grey.shade300),
//                                     ),
//                                     errorBorder: InputBorder.none,
//                                     disabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 11,
//                                         top: 11,
//                                         right: 15),
//                                   ),
//                                   initialValue: '${snapshot.data[2]}',
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 15), // GIVE THE NAME HERE
//                                   enabled: _isEnabled,
//                                   textInputAction: TextInputAction.done,
//                                   onEditingComplete: () {
//                                     setState(() => {
//                                           _isEnabled = false,
//                                         });
//                                   }),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 case ConnectionState.done:
//                   return Text('done');
//               }
//             },
//           ),
//         ),
//         Step(
//           isActive: currentStep >= 3,
//           title: Text('Check Out', style: GoogleFonts.poppins(fontSize: 15)),
//           content: Container(
//             height: 200,
//             child: Column(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: feedback,
//                     minLines: 6,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(),
//                       ),
//                       contentPadding: EdgeInsets.only(
//                           left: 15, bottom: 11, top: 11, right: 15),
//                       hintText: 'Provide your Feedback.',
//                       hintStyle: GoogleFonts.poppins(
//                           fontSize: 16, color: Colors.black),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Container(
//                   margin: EdgeInsets.only(left: 0, right: 150),
//                   padding: EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     border: Border(
//                       bottom: BorderSide(
//                         color: Colors.grey,
//                       ),
//                       top: BorderSide(color: Colors.grey),
//                       left: BorderSide(color: Colors.grey),
//                       right: BorderSide(color: Colors.grey),
//                     ),
//                   ),
//                   child: DropdownButton<String>(
//                     isExpanded: true,
//                     iconSize: 40,
//                     iconEnabledColor: Colors.grey,
//                     icon: Icon(Icons.arrow_drop_down),
//                     underline: SizedBox(),
//                     hint: Text(
//                       " Status",
//                       style: GoogleFonts.poppins(fontSize: 16),
//                     ),
//                     value: valueChoose,
//                     style: GoogleFonts.poppins(
//                       textStyle: TextStyle(color: Colors.black, fontSize: 16),
//                     ),
//                     items: items.map((valueItem) {
//                       return DropdownMenuItem(
//                           value: valueItem, child: Text(valueItem));
//                     }).toList(),
//                     onChanged: (newValue) {
//                       setState(() {
//                         print('>>>>>>>>>>>>>>..  $valueChoose');
//                         valueChoose = newValue;
//                         print('>>>>>>>>>>>>>>..  $valueChoose');
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ];
  }
}
