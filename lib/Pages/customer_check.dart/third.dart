import 'package:eazy_app/Pages/customer_check.dart/fourth.dart';
import 'package:eazy_app/Pages/customer_check.dart/second.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  String? valueChoose;
  int _value = 1;
  int _value2 = 1;
  final budgetList = [
    '50L - 75L',
    '75L - 1CR',
    '1CR - 1.25CR',
    '1.25CR - 1.50CR',
    '1.50CR - 1.75CR',
    '1.75CR - 2CR',
    '2CR AND ABOVE',
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              child: Column(
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
                    margin: EdgeInsets.only(
                        left: width * 0.12),
                    child: Text(
                      'UrbanPlace welcomes you to UrbanPlace Project',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.025),
                    child: Text(
                      'What configuration are you looking at?',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.12, right: width * 0.12),
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
                        textStyle: TextStyle(color: myColor, fontSize: 14),
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
                        top: height * 0.02,
                        left: width * 0.050,
                        right: width * 0.050),
                    child: Column(
                      children: [
                        Text('What is the purpose of your purchase?',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 16))),
                        Row(
                          children: [
                            SizedBox(width: width * 0.04),
                            Radio(
                                value: 1,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value as int;
                                  });
                                }),
                            Text(
                              'Self Use',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.16,
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
                              'Second home',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: width * 0.04),
                            Radio(
                                value: 3,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value as int;
                                  });
                                }),
                            Text(
                              'Investment',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(width: width * 0.10),
                            Radio(
                                value: 4,
                                groupValue: _value,
                                onChanged: (value) {
                                  setState(() {
                                    _value = value as int;
                                  });
                                }),
                            Text(
                              'Organizational',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.02 , right : width*0.16),
                    child: Text(
                      'Provide your mode of funding',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.050, right: width * 0.050),
                    child: Row(
                      children: [
                        SizedBox(width: width * 0.04),
                        Radio(
                            value: 1,
                            groupValue: _value2,
                            onChanged: (value) {
                              setState(() {
                                _value2 = value as int;
                              });
                            }),
                        Text(
                          'Maximum self',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        SizedBox(width:width*0.055),
                        Radio(
                            value: 2,
                            groupValue: _value2,
                            onChanged: (value) {
                              setState(() {
                                _value2 = value as int;
                              });
                            }),
                        Text(
                          'Maximum loan',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 14),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          textStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SecondPage(),
                              ));
                        },
                        child: Text('Go back'),
                      ),
                      SizedBox(width: width * 0.04),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: myColor,
                          textStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FourthPage(),
                              ));
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
              //color: Colors.grey.shade200,
            ),
          ),
        ),
      ),
    );
  }
}
