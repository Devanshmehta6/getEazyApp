import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final baseUrl = 'https://geteazyapp.com/api/login/';
  static final SESSION = FlutterSession();

  Future<dynamic> login(String email, String password) async {
    try {
      print(" >>>>>>>>>>>> ${email} ");
      print(" >>>>>>>>>>>> ${password} ");
      var res = await http.post(baseUrl, body: {
        'username': email,
        'password': password,
      });

      return res;
    } finally {
      //nothing
    }
  }

  static setToken(String token ) async {
    AuthData data = AuthData(token);
    return await SESSION.set('tokens', data);
  }

  static Future<Map<String , dynamic>>getToken() async {
    return await SESSION.get('tokens');
  }

  static  removeToken() async {
    await SESSION.prefs.clear();
  }
}

  

class AuthData{

  String token ;
  AuthData(this.token);

  Map<String , dynamic> toJson(){
    final Map<String , dynamic> data = Map<String , dynamic>();

    data['token'] = token;
    
    return data;
  }
}
