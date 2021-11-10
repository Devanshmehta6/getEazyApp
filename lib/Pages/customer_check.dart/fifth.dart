import 'package:eazy_app/Pages/customer_check.dart/fourth.dart';
import 'package:eazy_app/Pages/customer_check.dart/sixth.dart';
import 'package:eazy_app/Pages/eazy_visits.dart';
import 'package:eazy_app/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:camera_camera/camera_camera.dart';

class FifthPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const FifthPage({Key? key, this.cameras});

  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  List cameras = [];

  XFile? ogFile;
  bool isCameraBack = false;
  GlobalKey<_FifthPageState> _cameraWidgetStateKey =
      new GlobalKey<_FifthPageState>();
  late int selectedIndex;
  final photos = <File>[];

  // @override
  // void initState() {
  //   super.initState();
  //   availableCameras().then((availableCameras) {
  //     cameras = availableCameras;
  //     if (cameras.length > 0) {
  //       setState(() {
  //         selectedIndex = 0;
  //         print('>>>>>>>>>>>>>>>>>>>>> INDEX >>>>> $selectedIndex');
  //       });
  //       _initCameraController(cameras[selectedIndex]).then((void v) {});
  //     }
  //   });
  //   // controller = CameraController(widget.cameras![0], ResolutionPreset.max);
  //   // controller.initialize().then((_) {
  //   //   if (!mounted) {
  //   //     print('>>>>>>>>>>>>>> >>>>>>>>>>>>>');
  //   //     return;
  //   //   }
  //   //   setState(() {});
  //   // });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CameraCamera(onFile: (file){
      
    }); 
    
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    final width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xff4044fc);

    void openCamera() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CameraCamera(
                    onFile: (file) {
                      photos.add(file);
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),),
                  );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _cameraWidgetStateKey,
        backgroundColor: Colors.grey.shade300,
        bottomNavigationBar: Container(
          height: height * 0.1,
          margin: EdgeInsets.only(top: 2),
          child: SafeArea(
            child: Row(children: [
              Container(
                height: height * 0.12,
                margin: EdgeInsets.only(top: height * 0.031),
                width: width * 0.50,
                child: SizedBox(
                  height: height * 0.06,
                  child: FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FourthPage(),
                          ));
                    },
                    child: Text(
                      'Back',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                //height: height * 0.01,
                margin: EdgeInsets.only(top: height * 0.031),
                height: height * 0.12,
                width: width * 0.50,
                child: SizedBox(
                  child: FlatButton(
                    height: 300,
                    color: myColor,
                    onPressed: () async {
                      // XFile tempFile = await controller.takePicture();

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SixthPage(),
                      //     settings: RouteSettings(arguments: tempFile),
                      //   ),
                      // );
                    },
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              SizedBox(width: 24),
                              Text(
                                'Please Wait',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          )
                        : Text(
                            'Capture Image',
                            style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ),
                  ),
                ),
              ),
            ]),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 520),
              IconButton(icon: Icon(Icons.camera), onPressed: openCamera)
              // IconButton(
              //   icon: Icon(Icons.flip_camera_ios),
              //   onPressed: () {
              //     int cameraPos = isCameraBack ? 0 : 1;
              //     print(
              //         "+++++++++++++++++++++ $isCameraBack ++++++ $cameraPos +++++++++++++++++");
              //     print(
              //         "=========================== ${widget.cameras![cameraPos]} ============");
              //     controller = CameraController(
              //         widget.cameras![cameraPos], ResolutionPreset.max);
              //     setState(
              //       () {
              //         isCameraBack = !isCameraBack;
              //       },
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
