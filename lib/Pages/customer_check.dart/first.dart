import 'package:eazy_app/Pages/eazy_visits.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:eazy_app/Pages/customer_check.dart/second.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            height: height,
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
                    
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: myColor, fontSize: 16),
                    ),
                    autovalidate: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder( 
                        borderSide : BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder( 
                        borderSide : BorderSide(color: myColor),
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
                              builder: (context) => EazyVisits(),
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
                              builder: (context) => SecondPage(),
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
    );
  }
}
