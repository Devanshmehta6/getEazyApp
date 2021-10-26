import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Sales_Dashboard extends StatefulWidget {
  const Sales_Dashboard({Key? key}) : super(key: key);

  @override
  _Sales_DashboardState createState() => _Sales_DashboardState();
}

class _Sales_DashboardState extends State<Sales_Dashboard> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //centerTitle : true,
        iconTheme: IconThemeData(color: Colors.blue.shade800),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Image.asset(
              'images/eazyapp-logo-blue.png',
              height: 48,
              width: 40,
            ),
            SizedBox(width: width * 0.24),
            Text(
              'EazyDashboard',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: myColor, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: height*0.013),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.28,
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.013, vertical: height * 0.013),
                  color: Colors.blue.shade800,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.05, top: height * 0.04),
                            child: Text(
                              'Total Customers',
                              style: GoogleFonts.poppins(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: width * 0.33, top: height * 0.02),
                            child: Text(
                              '0',
                              style: GoogleFonts.poppins(fontSize: 60),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: width * 0.085,
                            vertical: height * 0.035),
                        child: Icon(
                          FontAwesomeIcons.users,
                          size: 110,
                          color: Colors.blue.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.28,
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.013, vertical: height * 0.013),
                  color: Colors.red,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.05, top: height * 0.04),
                            child: Text(
                              'Hot Customers',
                              style: GoogleFonts.poppins(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: width * 0.3, top: height * 0.02),
                            child: Text(
                              '0',
                              style: GoogleFonts.poppins(fontSize: 60),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: width * 0.19, top: height * 0.035),
                        child: Icon(
                          FontAwesomeIcons.grinHearts,
                          size: 110,
                          color: Colors.red.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.28,
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.013, vertical: height * 0.013),
                  color: Colors.lime.shade600,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.05, top: height * 0.04),
                            child: Text(
                              'Warm Customers',
                              style: GoogleFonts.poppins(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: width * 0.3, top: height * 0.02),
                            child: Text(
                              '0',
                              style: GoogleFonts.poppins(fontSize: 60),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: width * 0.12, top: height * 0.035),
                        child: Icon(
                          FontAwesomeIcons.smile,
                          size: 110,
                          color: Colors.lime.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.28,
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.013, vertical: height * 0.013),
                  color: Colors.greenAccent.shade700,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.05, top: height * 0.04),
                            child: Text(
                              'Total Follow Ups',
                              style: GoogleFonts.poppins(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: width * 0.3, top: height * 0.02),
                            child: Text(
                              '0',
                              style: GoogleFonts.poppins(fontSize: 60),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: width * 0.16, top: height * 0.035),
                        child: Icon(
                          FontAwesomeIcons.headset,
                          size: 110,
                          color: Colors.greenAccent.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
