import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_course_shop_app/models/http_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _AuthType { signIn, signUp }

class Auth with ChangeNotifier {
  static const _apiHostUrl = 'identitytoolkit.googleapis.com';
  static const _apiSignInUrl = 'v1/accounts:signInWithPassword';
  static const _apiSignUpUrl = 'v1/accounts:signUp';
  static const _apiKey = 'AIzaSyCqiQ7k3drf1TzllAqgk3cdy0YPPEU9clk';
  final Uri _signUpUri = Uri.https(_apiHostUrl, _apiSignUpUrl, {'key': _apiKey});
  final Uri _signInUri = Uri.https(_apiHostUrl, _apiSignInUrl, {'key': _apiKey});
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  String? get token {
    if (_expiryDate == null) return null;
    if (!_expiryDate!.isAfter(DateTime.now())) return null;
    return _token;
  }

  String? get userId {
    if (_expiryDate == null) return null;
    if (!_expiryDate!.isAfter(DateTime.now())) return null;
    return _userId;
  }

  bool get isAuth {
    if (_token == null || _expiryDate == null) return false;
    if (!_expiryDate!.isAfter(DateTime.now())) return false;
    return true;
  }

  Future<void> signup(String email, String password) async {
    return _auth(email, password, _AuthType.signUp);
  }

  Future<void> login(String email, String password) async {
    return _auth(email, password, _AuthType.signIn);
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }

  Future<void> _auth(String email, String password, _AuthType authType) async {
    final jsonData = json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });

    try {
      final _uri = (authType == _AuthType.signUp) ? _signUpUri : _signInUri;
      final response = await http.post(_uri, body: jsonData);
      if (response.statusCode >= 400) {
        final responseData = json.decode(response.body);
        if (responseData['error'] != null) {
          throw HttpException(responseData['error']['message'] ?? 'Unknown error');
        }
        throw HttpException('Error logging in');
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        if (responseData['error'] != null) {
          throw HttpException(responseData['error']['message'] ?? 'Unknown error');
        }
        if (responseData['idToken'] == null || responseData['localId'] == null || responseData['expiresIn'] == null) {
          throw HttpException('Unknown error');
        }
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
        await _saveAuth();
        notifyListeners();
      } else {
        throw HttpException('Unknown error');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _autoLogin() async {
    try {
      final SharedPreferences prefs = await _prefs;
      final String? sharedPrefAuth = prefs.getString('auth');
      if (sharedPrefAuth == null) return;
      final jsonData = json.decode(sharedPrefAuth) as Map<String, dynamic>?;
      if (jsonData == null) return;
      _token = jsonData['token'];
      _userId = jsonData['userid'];
      _expiryDate = DateTime.parse(jsonData['expirydate']);
      notifyListeners();
    } catch (error) {
      print('No autologin data retrieved');
      print(error.toString());
    }
  }

  Future<void> _saveAuth() async {
    try {
      final SharedPreferences prefs = await _prefs;
      if (_token == null || _userId == null || _expiryDate == null) return;
      final String jsonData =
          json.encode({'token': _token, 'userid': _userId, 'expirydate': _expiryDate!.toIso8601String()});
      bool result = await prefs.setString('auth', jsonData);
      if (result)
        print('Auth data stored in shared preferences');
      else
        print('Auth data could not be stored in shared preferences');
    } catch (error) {
      print('No autologin data stored');
      print(error.toString());
    }
  }

  Auth() {
    _autoLogin();
  }
}
