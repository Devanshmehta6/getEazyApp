import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:eazy_app/Pages/customer_check.dart/first.dart';
import 'package:eazy_app/Pages/eazy_visits.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:eazy_app/Pages/customer_check.dart/second.dart';
import 'package:eazy_app/Pages/customer_check.dart/third.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List recievedItems = [];
  String? data;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  fetchItem() async {
    final pref = await SharedPreferences.getInstance();
    final mobile = pref.getString('mobile');
    print('====================$mobile');
    data = mobile;
  }

  postData() async {
    var curr_date = DateFormat("yyyy-MM-dd").format(
      DateTime.now(),
    );
    final pref = await SharedPreferences.getInstance();
    final project_url = pref.getString('project_url');

    final cust_mobile =
        wNumber.text == null ? wNumber.text : pref.getString('mobile');
    print('>>>>>>>>>>>> MOBILE >>>>>>>>> $cust_mobile');

    final cust_url = pref.getString('customer_url');

    Uri url =
        Uri.parse('https://geteazyapp.com/projects/$project_url/$cust_url/api');
    print('>>>>>>>>>>>>>url>>>>>>>>>.. $url');

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
    final project_id = pref.getString('project_id');
    http.Response response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': settoken,
          HttpHeaders.cookieHeader: setcookie,
        },
        body: jsonEncode(
          {
            'project': project_id,
            'last_visited': curr_date,
            'customer': cust_id,
            'mobile': cust_mobile,
            'whatsapp_no': wNumber.text == null ? cust_mobile : wNumber.text,
            'first_name': fname.text,
            'last_name': lname.text,
            'email': email.text,
            'residence_location': valueChooseForLocation,
          },
        ));

    print('===========SECOND========${response.body}');
  }

  String? valueChoose;
  String? valueChooseForLocation;
  int _value = 1;
  List values = [];
  bool value = true;

  final TextEditingController fname = TextEditingController();
  final TextEditingController lname = TextEditingController();
  final TextEditingController wNumber = TextEditingController();
  final TextEditingController email = TextEditingController();

  moveTopreviousScreen() {
    print('----------- is called-----------');
    Navigator.pop(
      context,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics().setCurrentScreen(
      screenName: 'Customer Check In Page 2',
      screenClassOverride: 'Customer Check In Page 2',
    );
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    final locationList = [
      'Aarey Road',
      'Agashi',
      'Agripada',
      'Alibag',
      'Altamount Road',
      'Ambernath',
      'Ambernath East',
      'Ambernath West',
      'Ambivali',
      'Amboli',
      'Anand park',
      'Andheri East',
      'Andheri West',
      'Andheri-Kurla Road',
      'Antop Hill',
      'Anushakti Nagar',
      'Asangaon',
      'Atgaon',
      'Azad Nagar',
      'Badlapur East',
      'Badlapur West',
      'Bandra East',
      'Bandra Kurla Complex',
      'Bandra West',
      'Bangur Nagar',
      'Barve Nagar',
      'Behram Baug',
      'Best Nagar',
      'Beverly Park',
      'Bhadane',
      'Bhandup East',
      'Bhandup West',
      'Bhayandar East',
      'Bhayandar West',
      'Bhivpuri',
      'Bhiwandi',
      'Bhuleshwar',
      'Boisar',
      'Boraj',
      'Borivali East',
      'Borivali West',
      'Borla',
      'Breach Candy',
      'Byculla East',
      'Byculla West',
      'C.P. Tank',
      'Carter Road',
      'Chakala',
      'Chandivali',
      'Charkop',
      'Charni Road',
      'Chedda Nagar',
      'Chembur East',
      'Chembur West',
      'Chembur Colony',
      'Chikuwadi',
      'Chinchpada',
      'Chinchpokli',
      'Chiplun',
      'Chira Bazar',
      'chirag Nagar',
      'Chuna Bhatti',
      'Church Gate',
      'Colaba',
      'Cuffe Parade',
      'Cumballa Hill',
      'Currey Road',
      'Dadar',
      'Dadar East',
      'Dadar West',
      'Dahanu',
      'Dahanu Road',
      'Dahisar East',
      'Dahisar West',
      'Deonar',
      'Dhamote',
      'Dharavi',
      'Dindoshi',
      'Dohole',
      'Dombivli East',
      'Dombivli West',
      'Dongri',
      'Elphinstone Road',
      'Evershine Nagar',
      'Fort',
      'G T B Nagar',
      'Gaibi Nagar',
      'Gamdevi',
      'Gandhi Nagar',
      'Ghatkopar East',
      'Ghatkopar West',
      'Ghatla',
      'Ghera Sudhagad',
      'Ghodbunder',
      'Girgaon',
      'Gokuldam',
      'Gokuldham Colony',
      'Golibar',
      'Gorai',
      'Goregaon Eas',
      'Goregaon West',
      'Govandi West',
      'Govandi East',
      'Govand Nagar',
      'Grant Road East',
      'Grant Road West',
      'Gulmohar Road',
      'Haji Ali',
      'Harihareshwar',
      'Hariyali',
      'IC Colony',
      'J B Nagar',
      'Jacob Circle',
      'Jai Ambe Nagar',
      'Jawhar',
      'Jogeshwari East ',
      'Jogeshwari West',
      'Juhu',
      'Juhu Tara Road',
      'Kajupada',
      'Kalbadevi',
      'Kalher',
      'Kalina',
      'Kalyan East',
      'Kalyan West',
      'Kalyan-Shil Road',
      'Kamatghar',
      'Kanakia Road',
      'Kandivali East',
      'Kandivali West',
      'Kanjurmarg',
      'Kanjurmarg East',
      'Kanjurmarg West',
      'Kannamwar Nagar',
      'Kanti Park',
      'Karjat',
      'Kasara',
      'Kashimira',
      'Kemps Corner',
      'Khadakpada',
      'Khan Abdul Gafar Road',
      'Khandale',
      'Khandas Road',
      'Khar East',
      'Khar West',
      'Kharbao',
      'Khardi',
      'Kharodi',
      'Khetwadi',
      'Khodala',
      'Khopoli',
      'Kidwai Nagar',
      'Kolad',
      'Kopargaon',
      'Kurla East',
      'Kurla West',
      'Lal Baug',
      'LBS Marg',
      'LBS Marg-Mulund',
      'Link Road',
      'Linking Road',
      'Lokhandwala',
      'Lonere',
      'Lower Parel',
      'Madh',
      'Magathane',
      'Mahad',
      'Mahalaxmi',
      'Mahavir Nagar',
      'Mahim',
      'Malabar Hill',
      'Malad East',
      'Malad West',
      'Malvani',
      'Mandapeshwar',
      'Mandvi',
      'Mankhurd',
      'Manor',
      'Manori',
      'Marine Lines',
      'Marol',
      'Masjid Bunder',
      'Matunga',
      'Matunga East',
      'Matunga West',
      'Mazgaon',
      'MHADA Colony',
      'Mhatwali',
      'Mira Bhayandar',
      'Mira Road',
      'Mulund Colony',
      'Mulund East',
      'Mulund West',
      'Mumbai - Nasik Highway',
      'Mumbai Central',
      'Murbad',
      'Murbad Karjat Road',
      'Murbad Road',
      'Murud',
      'Nagaon',
      'Nagothane',
      'Nagpada',
      'Nahur East',
      'Nahur West',
      'Naigaon East',
      'Naigaon West',
      'Nalasopara East',
      'Nalasopara West',
      'Narayan Patil Wadi',
      'Nariman Point',
      'Navapada',
      'Navghar',
      'Naya Nagar',
      'Nehru Nagar',
      'Nehru Road',
      'Neral',
      'Netaji Nagar',
      'Opera House',
      'Orlem Malad',
      'Oshiwara',
      'Palghar',
      'Pali',
      'Pali Hill',
      'Panth Nagar',
      'Parel',
      'Peddar Road',
      'Poonam Nagar',
      'Postal Colony',
      'Powai',
      'Prabhadevi',
      'Prabhu Ali',
      'Pydhonie',
      'Raigad',
      'Ramnagar',
      'Roha',
      'Royal Palms',
      'S V Road',
      'Sahakar Nagar',
      'Sahar',
      'Sakawar',
      'Sakinaka',
      'Samat Nagar',
      'Santacruz East',
      'Santacruz West',
      'Saralgoan',
      'Saravali',
      'Sarvodaya Nagar',
      'Senapati Bapat Marg',
      'Sewri',
      'Sewri West',
      'Shahad',
      'Shahapur',
      'Shastri Nagar',
      'Shivaji Nagar',
      'Shivaji Park',
      'Sindhi Society',
      'Sion Circle',
      'Sion East',
      'Sion West',
      'Sir JJ Road',
      'Tagore Nagar',
      'Talasari',
      'Tardeo',
      'Thakurdwar',
      'Thakurli',
      'Tilak Nagar',
      'Titwala',
      'Triveni Nagar',
      'Trombay',
      'Tulsiwadi',
      'Tungareshwar',
      'Ulhasnagar',
      'Umerkhadi',
      'Umroli',
      'Upper Parel',
      'Upper Worli',
      'Uttan',
      'V P ROAD',
      'Vakola',
      'Vangani',
      'Vasai East',
      'Vasai West',
      'Vasai Road',
      'Vasai-Nallasopara Link Road',
      'Vasind',
      'Veera Desai Road',
      'Vehloli',
      'Versova',
      'Vidya Nagari',
      'Vidyavihar',
      'Vidyavihar East',
      'Vidyavihar West',
      'Vijay Nagar',
      'Vikhroli East',
      'Vikhroli West',
      'Vikramgad',
      'Vile Parle East',
      'Vile Parle West',
      'Virar East',
      'Virar West',
      'Vitthalwadi',
      'Wada',
      'Wadala East',
      'Wadala West',
      'Walkeshwar',
      'Warden Road',
      'Western Express Highway',
      'Worli',
      'Yari Road',
      'Yogi Jawraj Nagar',
      'Zadghar',
    ];

    Color myColor = Color(0xff4044fc);
    final items = [
      'Website',
      'Newspaper',
      'Hoarding',
      '99acres',
      'Facebook',
      'Housing.com',
      'MagickBricks',
      'Other Property Portal',
      'Friend/Family Reference',
      'Other'
    ];

    fetchItem();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () {
          return moveTopreviousScreen();
        },
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
                          Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FirstPage(),
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
                          if (formKey.currentState!.validate()) {
                            postData().whenComplete(() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ThirdPage(),
                                      maintainState: true),
                                ));
                          }
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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 70),
                    Container(
                      height: height * 0.1,
                      margin: EdgeInsets.only(top: height * 0.02),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/eazyapp-logo-blue.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    Container(
                      margin: EdgeInsets.only(right: width * 0.33),
                      child: Container(
                        //padding: EdgeInsets.only(right: width * 0.38),
                        child: Text(
                          'Basic Information',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: width * 0.075, right: width * 0.075),
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: fname,
                        autofocus: true,
                        style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: RequiredValidator(
                            errorText: 'This field is required'),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red.shade500, width: 0.8),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: myColor),
                          ),
                          suffixIcon: Icon(FontAwesomeIcons.userAlt,
                              color: myColor, size: 18),
                          border: InputBorder.none,
                          hintText: 'First Name',
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 16, color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: width * 0.075, right: width * 0.075),
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: lname,
                        style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: RequiredValidator(
                            errorText: 'This field is required'),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red.shade500, width: 0.8),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: myColor),
                          ),
                          suffixIcon: Icon(FontAwesomeIcons.userAlt,
                              color: myColor, size: 18),
                          border: InputBorder.none,
                          hintText: 'Last Name',
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 16, color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: width * 0.075, right: width * 0.075),
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        readOnly: true,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          suffixIcon:
                              Icon(Icons.phone, color: myColor, size: 18),
                          border: InputBorder.none,
                          hintText: data,
                          hintStyle: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: height * 0.02,
                        left: width * 0.053,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                right: width * 0.03, left: width * 0.03),
                            child: Text(
                              'Is this your Whatsapp Number?',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Container(
                            child: Transform.scale(
                              scale: 1,
                              child: Switch.adaptive(
                                activeColor: myColor,
                                value: value,
                                onChanged: (value) => setState(() {
                                  this.value = value;
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: value == false
                          ? Container(
                              margin: EdgeInsets.only(
                                  left: width * 0.075, right: width * 0.075),
                              padding: EdgeInsets.all(5),
                              child: TextFormField(
                                controller: wNumber,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                autovalidate: true,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: myColor),
                                  ),
                                  suffixIcon: Icon(FontAwesomeIcons.whatsapp,
                                      color: myColor, size: 18),
                                  border: InputBorder.none,
                                  hintText: 'Whatsapp Number',
                                  hintStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade700),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: width * 0.075, right: width * 0.075),
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: email,
                        style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'This field is required'),
                          EmailValidator(
                              errorText: 'Please enter a valid Email')
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red.shade500, width: 0.8),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: myColor),
                          ),
                          suffixIcon:
                              Icon(Icons.mail, color: myColor, size: 18),
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 16, color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: width * 0.075, right: width * 0.075),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey),
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
                            "Select your Residential Location",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          value: valueChooseForLocation,
                          style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          items: locationList.map((valueItem) {
                            return DropdownMenuItem(
                                value: valueItem, child: Text(valueItem));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              valueChooseForLocation = newValue;
                              print(
                                  '------------------$valueChooseForLocation');
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: width * 0.075, right: width * 0.075),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        iconSize: 40,
                        iconDisabledColor: myColor,
                        iconEnabledColor: myColor,
                        icon: Icon(Icons.arrow_drop_down),
                        underline: SizedBox(),
                        hint: Text(
                          "Where did you heard about us",
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        value: valueChoose,
                        style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        items: items.map((valueItem) {
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
}
