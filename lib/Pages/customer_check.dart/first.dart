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

class _FirstPageState extends State<FirstPage> {
  List sendMobile = [];

  postData(){
    final mobile = mobileController.text;
    sendMobile.add(mobile); 
  }

  @override
  final TextEditingController mobileController = TextEditingController();

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
    return MaterialApp(
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
                          builder: (context) => SecondPage(),
                          settings: RouteSettings(arguments: sendMobile),
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
        body: Center(
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
                Text(
                  'Check In - UrbanPlace Project',
                  style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Container(
                  margin: EdgeInsets.only(
                      top: 10, left: width * 0.075, right: width * 0.075),
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    controller: mobileController,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontSize: 16),
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
                      suffixIcon: Icon(Icons.phone, color: myColor, size: 20),
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
    );
  }
}
