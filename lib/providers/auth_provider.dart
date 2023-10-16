import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/user.dart';
import '../auth/user_preferences.dart';
import '../config/helpers/api.dart';
import '../config/helpers/param.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  final SharedPreferences prefs;
  bool _loggedIn = false;
  String _typeUser = "patient";
  int _userSelected = 0;
  AuthProvider(this.prefs) {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
    _typeUser = prefs.getString('type') ?? "";
    _userSelected = 0;
  }

  bool get loggedIn => _loggedIn;

  String get typeUser => _typeUser;
  int get userSelected => _userSelected;
  void selectUser(int user) {
    _userSelected = user;
    notifyListeners();
  }

  set loggedIn(bool value) {
    _loggedIn = value;
    prefs.setBool('LoggedIn', value);
    notifyListeners();
  }

  void checkLoggedIn() {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
  }

  Status _loggedInStatus = Status.NotLoggedIn;
  final Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String username, String password) async {
    var result;

    Map<String, dynamic> data = {'username': username, 'password': password};

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    final response = await Api.post(Param.postLogin, data);

    if (response is! String && response.statusCode == 200) {
      final Map<String, dynamic> responseData = response.data;

      loggedIn = true;
      //User authUser = User.fromJson(userData);
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(responseData['token']);
      responseData['type'] =
          decodedToken['is_patient'] ? "patient" : "professional";
      Api.setToken(responseData['token']);
      User authUser = User(
          userId: responseData['idUser'],
          username: responseData['username'],
          firstName: responseData['firstName'],
          lastName: responseData['lastName'],
          email: responseData['email'],
          phone: '11311984311',
          type: responseData['type'],
          token: responseData['token'],
          renewalToken: responseData['token']);

      await UserPreferences().saveUser(authUser);
      _loggedInStatus = Status.LoggedIn;
      _typeUser = responseData['type'];
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      Param.showToast(response);
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': 'ERROR'};
    }
    return result;
  }

  logout() {
    UserPreferences().removeUser();

    _loggedIn = false;

    notifyListeners();
  }

/* TODO REGISTER
  Future<Map<String, dynamic>> register(String email, String password, String passwordConfirmation) async {

    final Map<String, dynamic> registrationData = {
      'user': {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation
      }
    };


    _registeredInStatus = Status.Registering;
    notifyListeners();

    return await post(AppUrl.register,
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {

      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {

      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }
  */

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
