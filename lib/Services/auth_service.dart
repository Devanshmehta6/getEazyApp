import 'dart:convert';

import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final baseUrl = 'https://geteazyapp.com/api/login/';
  static final SESSION = FlutterSession();

  Future<dynamic> login(String email, String password) async {
    try {
      var res = await http.post(baseUrl, body: {
        'username': email,
        'password': password,
      });
      print('----------- LOGIN RESP -------------- ${res.body}');
      return res;
    } finally {
      //nothing
    }
  }

  static setToken(String token) async {
    AuthData data = AuthData(token);
    print('--------- SET TOKEN -----------$data');
    return await SESSION.set('tokens', data);
  }

  static setExpiry(String expiry) async {
    return await SESSION.set('expiry', expiry);
  }

  static getExpiry() async {
    return await SESSION.get('expiry');
  }

  static Future<Map<String, dynamic>> getToken() async {
    return await SESSION.get('tokens');
  }

  static removeToken() async {
    await SESSION.prefs.clear();
  }
}

class AuthData {
  String token;
  AuthData(this.token);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['token'] = token;

    return data;
  }
}
