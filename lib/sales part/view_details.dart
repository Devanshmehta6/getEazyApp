import 'package:eazy_app/sales%20part/customers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detailspage extends StatefulWidget {
  const Detailspage({ Key? key }) : super(key: key);

  @override
  _DetailspageState createState() => _DetailspageState();
}

class _DetailspageState extends State<Detailspage> {
  String cust_name = '';

  getName() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      cust_name  = pref.getString('cust_name');
    });
    
  }

  @override
  Widget build(BuildContext context) {
    getName();
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Profile',
                  style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                ),
              ),
              Tab(
                child: Text(
                  'History',
                  style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                ),
              ),
               Tab(
                child: Text(
                  'Follow Ups',
                  style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EazyCustomers()),
              );
            },
          ),
          iconTheme: IconThemeData(color: Colors.blue.shade800),
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              SizedBox(width: width * 0.13),
              Text(
                cust_name == '' ? 'Loading...' : cust_name,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              SizedBox(width: width * 0.12),
              Image.asset('images/eazyapp-logo-blue.png',
                  height: 45, width: 40),
            ],
          ),
        ),
    ));
  }
}