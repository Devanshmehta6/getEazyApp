import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamLeadDashboard extends StatefulWidget {
  const TeamLeadDashboard({Key? key}) : super(key: key);

  @override
  _TeamLeadDashboardState createState() => _TeamLeadDashboardState();
}

class _TeamLeadDashboardState extends State<TeamLeadDashboard> {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics().setCurrentScreen(
      screenName: 'Team Lead Dashboard',
      screenClassOverride: 'Team Lead Dashboard',
    );
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: myColor),
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: Container(
              margin: EdgeInsets.only(left: 10),
              child: Image.asset(
                'images/eazyapp-logo-blue.png',
                height: 48,
                width: 40,
              ),
            ),
            title: Text(
              'EazyDashboard',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: myColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
