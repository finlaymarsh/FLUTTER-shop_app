import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import '../constants.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  String _refreshToken;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(Uri url, String email, String password) async {
    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
          'returnSecureToken': 'true',
        },
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _refreshToken = responseData['refreshToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoTokenRefresh();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
          'refreshToken': _refreshToken,
        },
      );
      prefs.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${Constants.firebaseApiKey}');
    return _authenticate(url, email, password);
  }

  Future<void> logIn(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${Constants.firebaseApiKey}');
    return _authenticate(url, email, password);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      _refreshToken = extractedUserData['refreshToken'];
      try {
        await refreshTokenLogin();
        return true;
      } catch (error) {
        throw (error);
      }
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _refreshToken = extractedUserData['refreshToken'];
    _expiryDate = expiryDate;
    _autoTokenRefresh();
    notifyListeners();
    return true;
  }

  Future<void> refreshTokenLogin() async {
    final url = Uri.parse(
        'https://securetoken.googleapis.com/v1/token?key=${Constants.firebaseApiKey}');
    final response = await http.post(
      url,
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': _refreshToken,
      },
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['error']['message']);
    }
    _token = responseData['id_token'];
    _userId = responseData['user_id'];
    _refreshToken = responseData['refresh_token'];
    _expiryDate = DateTime.now()
        .add(Duration(seconds: int.parse(responseData['expires_in'])));
    _autoTokenRefresh();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'refreshToken': _refreshToken,
      },
    );
    prefs.setString("userData", userData);
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }

  void _autoTokenRefresh() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), refreshTokenLogin);
  }
}
