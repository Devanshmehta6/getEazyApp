import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_session/flutter_session.dart';

class ApiServices {
  Future<LoginApiResponse> apiCallLogin(Map<String, dynamic> param) async {
    var url = Uri.parse('https://geteazyapp.com/api/login/');
    var response = await http.post(url, body: param);
    print('Response status : ${response.statusCode}');
    print(response.headers);
    
    
    
    

    final  header = response.headers.toString();
    final str = header;
    final start = 'setCookie:';
    final end = '; SameSite=Lax, date:';
    

    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);
    final id = str.substring(startIndex + start.length, endIndex);
    await FlutterSession().set('session', id);

    final str1 = header;
    final start1= 'csrftoken=';
    final end1 = '; expires=';

    final startIndex1 = str1.indexOf(start1);
    final endIndex1 = str1.indexOf(end1, startIndex1 + start1.length);
    final csrf = str1.substring(startIndex1 + start1.length, endIndex1);
    await FlutterSession().set('csrf', csrf);


    
    print('IDD2 :::: $csrf');

    // final p = await SharedPreferences.getInstance();
    //  p.setString('cookie', data2['set-cookie']);
    //  final set_cookie = p.getString('cookie');
    // print('cokiya : $set_cookie');
    // print('mapp :${data2['set-cookie'][0]}');
    

    print('====================================');
    //print('data : ${data2}');
    

    //print( 'COOKIE ${details["set-cookie"]}');
    //String session = details["set-cookie"];

    //print(session);
    print('====================================');
    ;
    //await FlutterSession().set("session" , data2["sessionid"]);
    //dynamic sessionid = await FlutterSession().get("session");
    final data = jsonDecode(response.body);
    print('Token : ${data["token"]}');
    final token = data["token"];
    final pref = await SharedPreferences.getInstance();
    pref.setString('token', token);
    //final error = pref.setString('error' , data["error"]);
    //print(token);
    return LoginApiResponse(
        token: data["token"], error: data["error"], expiry: data["expiry"]);
  }
}

//  getToken() async {
//       final pref1 = await SharedPreferences.getInstance();
//       pref1.setString('token', data["token"]);
//       final pref2 = await SharedPreferences.getInstance();
//       pref2.setString('expiry', data['expiry']);
//     }

class LoginApiResponse {
  final String? token;
  final String? error;
  final String? expiry;

  LoginApiResponse({this.token, this.error, this.expiry});
}
