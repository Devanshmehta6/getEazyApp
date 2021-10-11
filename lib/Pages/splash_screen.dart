import 'package:eazy_app/Pages/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateToLogin();
  }

  navigateToLogin() async {
    await Future.delayed(Duration(milliseconds:1500), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Container(
        color : Color(0xff4044fc),
        child: Center(
          child: Image.asset('images/eazyapp-logo-white.png' , width: width*0.5,),
        ),
      ),
    );
  }
}
