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
  bool _isEditingText = false;
  late TextEditingController emailController;
  late TextEditingController nameController;

  String initialName = '';
  String initialEmail = '';
  String initialPhone = '';
  String initialWhatsapp = '';
  String initialLocation = '';
  String initialResidence = '';

  getName() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      cust_name = pref.getString('cust_name');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //nameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getName();
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);
    nameController = TextEditingController(text: initialName)
      ..addListener(
        () {
          setState(() {});
        },
      );
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
                ),
              ),
              Tab(
                child: Text(
                  'History',
                  style: TextStyle(
                      fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
                ),
              ),
              Tab(
                child: Text(
                  'Follow Ups',
                  style: TextStyle(
                      fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          ),
          iconTheme: IconThemeData(color: Colors.blue.shade800),
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              SizedBox(width: width * 0.18),
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
                    //height: height * 0.2,
                    width: double.infinity,
                    child: Container(
                      margin : EdgeInsets.symmetric(horizontal: 4),
                      child: ExpansionTile(
                        textColor: Colors.black,
                        collapsedIconColor: Colors.grey,
                        collapsedTextColor: Colors.grey,
                        iconColor: Colors.black,
                        initiallyExpanded: true,
                        //tilePadding: EdgeInsets.symmetric(horizontal: 8),
                        //collapsedBackgroundColor: Color(0xff007bff),
                        title: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Basic Information',
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                        children: [
                          Container(
                            height: height * 0.42,
                            width: double.infinity,
                            child: Card(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(8),
                                        child: Text(
                                          'Name:',
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        width: width * 0.7,
                                        padding: EdgeInsets.zero,
                                        //margin: EdgeInsets.only(left: 8),
                                        //padding: EdgeInsets.only(right  : 30),
                                        child: TextFormField(
                                          //scrollPadding: EdgeInsets.zero,
                                          keyboardType: TextInputType.name,
                                          onFieldSubmitted: (value) {
                                            initialName =
                                                value; //snapshot.data = value
                                          },
                                          initialValue:
                                              '$initialName', //snapshot.data
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                          //controller: nameController,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,

                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: myColor),
                                            ),
                                            //helperText: 'Helper Text',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(8),
                                        child: Text(
                                          'Email:',
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        width: width * 0.7,
                                        padding: EdgeInsets.zero,
                                        //margin: EdgeInsets.only(left: 8),
                                        //padding: EdgeInsets.only(right  : 30),
                                        child: TextFormField(
                                          //scrollPadding: EdgeInsets.zero,
                                          keyboardType: TextInputType.name,
                                          onFieldSubmitted: (value) {
                                            initialEmail =
                                                value; //snapshot.data = value
                                          },
                                          initialValue:
                                              '$initialEmail', //snapshot.data
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                          //controller: nameController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: myColor),
                                            ),
                                            //helperText: 'Helper Text',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(8),
                                        child: Text(
                                          'Phone:',
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        width: width * 0.7,
                                        padding: EdgeInsets.zero,
                                        //margin: EdgeInsets.only(left: 8),
                                        //padding: EdgeInsets.only(right  : 30),
                                        child: TextFormField(
                                          //scrollPadding: EdgeInsets.zero,
                                          keyboardType: TextInputType.name,
                                          onFieldSubmitted: (value) {
                                            initialPhone =
                                                value; //snapshot.data = value
                                          },
                                          initialValue:
                                              '$initialPhone', //snapshot.data
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                          //controller: nameController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: myColor),
                                            ),
                                            //helperText: 'Helper Text',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(8),
                                        child: Text(
                                          'Whatsapp:',
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        width: width * 0.65,
                                        padding: EdgeInsets.zero,
                                        //margin: EdgeInsets.only(left: 8),
                                        //padding: EdgeInsets.only(right  : 30),
                                        child: TextFormField(
                                          //scrollPadding: EdgeInsets.zero,
                                          keyboardType: TextInputType.name,
                                          onFieldSubmitted: (value) {
                                            initialWhatsapp =
                                                value; //snapshot.data = value
                                          },
                                          initialValue:
                                              '$initialWhatsapp', //snapshot.data
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                          //controller: nameController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: myColor),
                                            ),
                                            //helperText: 'Helper Text',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(8),
                                        child: Text(
                                          'Location:',
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        width: width * 0.7,
                                        padding: EdgeInsets.zero,
                                        //margin: EdgeInsets.only(left: 8),
                                        //padding: EdgeInsets.only(right  : 30),
                                        child: TextFormField(
                                          //scrollPadding: EdgeInsets.zero,
                                          keyboardType: TextInputType.name,
                                          onFieldSubmitted: (value) {
                                            initialLocation =
                                                value; //snapshot.data = value
                                          },
                                          initialValue:
                                              '$initialLocation', //snapshot.data
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                          //controller: nameController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: myColor),
                                            ),
                                            //helperText: 'Helper Text',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(8),
                                        child: Text(
                                          'Residence:',
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        width: width * 0.65,
                                        padding: EdgeInsets.zero,
                                        //margin: EdgeInsets.only(left: 8),
                                        //padding: EdgeInsets.only(right  : 30),
                                        child: TextFormField(
                                          //scrollPadding: EdgeInsets.zero,
                                          keyboardType: TextInputType.name,
                                          onFieldSubmitted: (value) {
                                            initialResidence =
                                                value; //snapshot.data = value
                                          },
                                          initialValue:
                                              '$initialResidence', //snapshot.data
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                          //controller: nameController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: myColor),
                                            ),
                                            //helperText: 'Helper Text',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                Container(
                    //height: height * 0.2,
                    width: double.infinity,
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.white,
                      title: Text('Work Info' , style : GoogleFonts.poppins(fontSize : 16)),
                      children: [],
                    )),
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

  Widget name() {
    if (_isEditingText)
      return Center(
        child: TextFormField(
          onFieldSubmitted: (newValue) {
            setState(() {
              initialName = newValue;
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: nameController,
        ),
      );
    return InkWell(
      onFocusChange: (value) => setState(() {
        initialName = initialName;
      }),
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: Text(
        initialName,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget email() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              initialEmail = newValue;
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: emailController,
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: Text(
        initialEmail,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
    );
  }
}
