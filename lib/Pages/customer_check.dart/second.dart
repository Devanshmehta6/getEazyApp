import 'package:eazy_app/Pages/customer_check.dart/first.dart';
import 'package:eazy_app/Pages/eazy_visits.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:eazy_app/Pages/customer_check.dart/second.dart';
import 'package:eazy_app/Pages/customer_check.dart/third.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String? valueChoose;
  int _value = 1;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;

    Color myColor = Color(0xff4044fc);
    final items = [
      'Webiste',
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: height * 0.1,
                  margin: EdgeInsets.only(top: height * 0.05),
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
                  child: Padding(
                    padding: EdgeInsets.only(right: width * 0.38),
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
                      textStyle: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    readOnly: true,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: myColor),
                      ),
                      suffixIcon: Icon(Icons.phone, color: myColor, size: 18),
                      border: InputBorder.none,
                      hintText: 'Cant edit this(phone number)',
                      hintStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 16, color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.050,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: width * 0.3),
                        child: Text('Is this your whatsapp number?',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 16))),
                      ),
                      Row(
                        children: [
                          Radio(
                              value: 1,
                              groupValue: _value,
                              onChanged: (value) {
                                setState(() {
                                  _value = value as int;
                                });
                              }),
                          Text(
                            'Yes',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14,
                              ),
                            ),
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
                            'No',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: _value == 2
                      ? Container(
                          margin: EdgeInsets.only(
                              left: width * 0.075, right: width * 0.075),
                          padding: EdgeInsets.all(5),
                          child: TextFormField(
                            style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                                    fontSize: 16, color: Colors.grey.shade700),
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
                      suffixIcon: Icon(Icons.mail, color: myColor, size: 18),
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
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    autovalidate: true,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: myColor),
                      ),
                      suffixIcon: Icon(FontAwesomeIcons.mapMarkerAlt,
                          color: myColor, size: 18),
                      border: InputBorder.none,
                      hintText: 'Selected Residential Location',
                      hintStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 16, color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: width * 0.085, right: width * 0.085),
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
                    disabledHint: Text('MYdata'),
                    underline: SizedBox(),
                    hint: Text(
                      "Where did you heard about us",
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    value: valueChoose,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: myColor, fontSize: 14),
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
                SizedBox(height: height * 0.22),
              ],
            ),
            //color: Colors.grey.shade200,
          ),
        ),
      ),
    );
  }
}
