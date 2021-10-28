import 'package:eazy_app/sales%20part/sales_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    // String img = '';
    // getImage() async {
    //   final pref = await SharedPreferences.getInstance();
    //   img = pref.getString('image_url');
    // }
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.17,
              padding: EdgeInsets.only(top: height * 0.01),
              child: DrawerHeader(
                child: Text('Developer Logo'),
              ),
            ),
            Divider(thickness: 1, color: Colors.black),
            ListTile(
              title: Row(
                children: [
                  SizedBox(width: width * 0.01),
                  Icon(FontAwesomeIcons.chartPie, color: myColor),
                  SizedBox(width: width * 0.06),
                  Text(
                    'EazyDashboard',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 18, color: myColor),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Sales_Dashboard(),
                  ),
                );
              },
            ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                iconColor: Colors.black,
                title: Row(
                  children: [
                    SizedBox(width: width * 0.01),
                    Icon(
                      FontAwesomeIcons.users,
                    ),
                    SizedBox(width: width * 0.06),
                    Text(
                      'EazyCustomers',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        SizedBox(width: width * 0.07),
                        Icon(FontAwesomeIcons.userClock,
                            color: Colors.grey.shade700, size: 16),
                        SizedBox(width: width * 0.04),
                        Text(
                          'Project',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
