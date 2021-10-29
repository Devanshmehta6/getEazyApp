import 'package:eazy_app/Pages/customer_check.dart/fourth.dart';
import 'package:eazy_app/Pages/customer_check.dart/sixth.dart';
import 'package:eazy_app/Pages/eazy_visits.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

class FifthPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const FifthPage({Key? key, this.cameras});

  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  late CameraController controller;
  XFile? ogFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = CameraController(widget.cameras![0], ResolutionPreset.max);
    //controller = CameraController(widget.cameras![0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // Future<http.StreamedResponse> patchImage(String filepath) async {
  //   final pref = await SharedPreferences.getInstance();
  //   final project_url = pref.getString('project_url');
  //   final cust_url = pref.getString('customer_url');

  //   final url = "https://geteazyapp.com/projects/$project_url/$cust_url/api";
  //   print('URL IN FIFTH PAGE -------------- $url');

  //   String sessionId = await FlutterSession().get('session');
  //   String csrf = await FlutterSession().get('csrf');
  //   String? authorization = pref.getString('token');
  //   String? tokenn = authorization;
  //   final cookie = pref.getString('cookie');
  //   final token = await AuthService.getToken();
  //   final settoken = 'Token ${token['token']}';
  //   final setcookie = "csrftoken=$csrf; sessionid=$sessionId";
  //   final cust_id = pref.getInt('cust_id');
  //   final mobile = pref.getString('mobile');

  //   var request = http.MultipartRequest('PUT', Uri.parse(url));
  //   request.files.add(await http.MultipartFile.fromPath("pic", filepath));
  //   request.headers.addAll({
  //     'Content-Type': 'multipart/form-data',
  //     'Authorization': settoken,
  //     HttpHeaders.cookieHeader: setcookie,
  //   });
  //   request.fields['project'] = '2';
  //   request.fields['customer'] = '$cust_id';
  //   request.fields['mobile'] = mobile;

  //   var response = request.send();

  //   return response;
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    if (!controller.value.isInitialized) {
      return SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Center(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: height * 0.067, bottom: height * 0.03),
                  height: height * 0.95,
                  width: width,
                  child: CameraPreview(controller)),

              Container(
                height: height * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xff007bff)),
                  onPressed: () async {
                    XFile tempFile = await controller.takePicture();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SixthPage(),
                        settings: RouteSettings(arguments: tempFile),
                      ),
                    );
                    //ogFile = await controller.takePicture().whenComplete(() {
                    //print('>>>>>>>>>>>>>>>>... ${ogFile!.path.toString()}');
                    //setState(() {});

                    //});
                    // ogFile = await controller.takePicture().whenComplete(() {
                    //   //setState(() {});
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => SixthPage(),
                    //       settings: RouteSettings(arguments: ogFile),
                    //     ),
                    //   );
                    // });
                  },
                  child: Text(
                    'Capture Image',
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              // Positioned.fill(
              //   child: ogFile == null
              //       ? Text('')
              //       : Image.file(
              //           File(ogFile!.path),
              //         ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
