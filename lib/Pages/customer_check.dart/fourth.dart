import 'package:eazy_app/Pages/customer_check.dart/second.dart';
import 'package:eazy_app/Pages/customer_check.dart/third.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({Key? key}) : super(key: key);

  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  String? valueChoose;
  int _value = 1;
  int _value2 = 1;
  final budgetList = [
    'Self Employeed',
    'Employeed - Private',
    'Employeed - Government',
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
                    margin: EdgeInsets.only(
                        top: height * 0.02,
                        left: width * 0.05,
                        right: width * 0.25),
                    child: Text(
                      'What is your occupation?',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.005),
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
                        "Choose your occupation",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      value: valueChoose,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: myColor, fontSize: 16),
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
                        left: width * 0.12,
                        right: width * 0.12),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: myColor)),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Name your organization',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.02,
                        left: width * 0.12,
                        right: width * 0.12),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: myColor)),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'What is your designation',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.02,
                        left: width * 0.05,
                        right: width * 0.5),
                    child: Text(
                      'Office Location',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.005),
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
                        "Choose your office location",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      value: valueChoose,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: myColor, fontSize: 16),
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
                  SizedBox(height : height*0.03),
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
                                builder: (context) => ThirdPage(),
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
                                builder: (context) => ThirdPage(),
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
