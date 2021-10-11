import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class EazyTeams extends StatefulWidget {
  @override
  State<EazyTeams> createState() => _EazyTeamsState();
}

class _EazyTeamsState extends State<EazyTeams> {
  String mockData = '';
  final parsedData = '';
  final String name = '';

  // Future getData() async {
  //   Uri url = Uri.parse('https://jsonplaceholder.typicode.com/users');
  //   final sp = await SharedPreferences.getInstance();
  //   String? authorization = sp.getString('token2');
  //   final response = await http.get(url, headers: {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     //HttpHeaders.authorizationHeader: authorization!,
  //   });

  //   print(response);
  //   setState(() {
  //     mockData = response.body.toString();
  //   });
  //   return response.body;
  // }

  // Future decodeData() async {
  //   final parsedData = json.decode(mockData);
  //   //final String name = parsedData[0]['address']['street'];
  //   //print(parsedData[0]['team_member_ser'][0]['role']);
  //   print(parsedData);
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue.shade800),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            SizedBox(width: 280),
            Image.asset(
              'images/eazyapp-logo-blue.png',
              height: 48,
              width: 40,
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 70,
              width: double.infinity,
              child: Card(
                child: Container(
                  padding: EdgeInsets.only(top: 6),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '  Team Members - UrbanPlace Project',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          DateFormat("dd-MM-yyyy").format(
                            DateTime.now(),
                          ),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: height * 0.25,
              width: width,
              child: Card(
                child: Row(
                  children: <Widget>[
                    Image.asset('images/user_image.png',
                        height: 140, width: 130),
                    VerticalDivider(
                      color: Colors.grey,
                      thickness: 1.5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 9),
                          child: Text(
                            'name : $name',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 9),
                          child: Text(
                            'Check In Time : ',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 9),
                          child: Text(
                            'Check Out Time : ',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 9),
                          child: Text(
                            'Role : ',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        // Container(
                        //   padding : EdgeInsets.only(left : 100),
                        //   child : ElevatedButton(
                        //   onPressed: () {},
                        //   child: Text(
                        //     'Check Out',
                        //     style: GoogleFonts.poppins(
                        //       textStyle: TextStyle(
                        //         fontSize: 16,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Team {
  final String? name;

  Team({this.name});
}
