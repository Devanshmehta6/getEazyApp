import 'package:eazy_app/sales%20part/customers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detailspage extends StatefulWidget {
  const Detailspage({Key? key}) : super(key: key);

  @override
  _DetailspageState createState() => _DetailspageState();
}

class _DetailspageState extends State<Detailspage> {
  String cust_name = '';
  bool _isEnabled = false;

  getName() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      cust_name = pref.getString('cust_name');
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
              Navigator.pop(
                context,
                MaterialPageRoute(
                    builder: (context) => EazyCustomers(), maintainState: true),
              );
            },
          ),
          iconTheme: IconThemeData(color: Colors.blue.shade800),
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              SizedBox(width: width * 0.19),
              // Text(
              //   cust_name == '' ? 'Loading...' : cust_name,
              //   style: GoogleFonts.poppins(
              //     textStyle: TextStyle(fontSize: 16, color: Colors.black),
              //   ),
              // ),
              Text(
                'Customer Details',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              SizedBox(width: width * 0.16),
              Image.asset('images/eazyapp-logo-blue.png',
                  height: 45, width: 40),
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade300,
        body: TabBarView(
          children: [
            Column(
              children: [
                Container(
                  height: height * 0.25,
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.07,
                          width: double.infinity,
                          child: Card(
                            color: Colors.blue.shade200,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8.2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Basic Info',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(width: 200),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 18),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(FontAwesomeIcons.edit,
                                            size: 20),
                                        onPressed: () {
                                          print('executed edit');
                                          setState(() {
                                            _isEnabled = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 18),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(FontAwesomeIcons.save,
                                            size: 20),
                                        onPressed: () {
                                          print('executed');
                                          setState(() {
                                            _isEnabled = !_isEnabled;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: 'Name', // GIVE THE NAME HERE
                            enabled: _isEnabled,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                            TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: 'Email', // GIVE THE NAME HERE
                            enabled: _isEnabled,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                            TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: 'Phone', // GIVE THE NAME HERE
                            enabled: _isEnabled,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                            TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: 'Whatsapp', // GIVE THE NAME HERE
                            enabled: _isEnabled,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                            TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: 'Location', // GIVE THE NAME HERE
                            enabled: _isEnabled,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                            TextFormField(
                              scrollPadding: EdgeInsets.zero,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            initialValue: 'Resident', // GIVE THE NAME HERE
                            enabled: _isEnabled,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() => {
                                    _isEnabled = false,
                                  });
                            }),
                      ],
                    ),
                  ),
                ),

                //NAME FROM JSON
              ],
            ),
            Text(''),
            Text('')
          ],
        ),
      ),
    );
  }
}
