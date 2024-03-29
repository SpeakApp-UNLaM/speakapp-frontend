import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_front/config/helpers/no_connection_backend_exception.dart';
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
  late User _loggedUser;
  bool _loggedIn = false;
  String _typeUser = "patient";
  int _userSelected = 0;
  String _userToFirstName = "";
  String _userToLastName = "";
  Image? _userToImageData;

  AuthProvider(this.prefs) {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
    _typeUser = prefs.getString('type') ?? "";
    _userSelected = 0;
    getUser();
  }

  bool get loggedIn => _loggedIn;
  String get typeUser => _typeUser;
  int get userSelected => _userSelected;
  String get userToFirstName => _userToFirstName;
  String get userToLastName => _userToLastName;
  Image? get userToImageData => _userToImageData;
  User get loggedUser => _loggedUser;

  void selectUser(
      int user, String firstName, String lastName, String? imageData) {
    _userSelected = user;
    _userToFirstName = firstName;
    _userToLastName = lastName;
    _userToImageData = imageData != null
        ? Image.memory(base64.decode(imageData), fit: BoxFit.cover)
        : null;
    notifyListeners();
  }

  void selectUserRfi(int user) {
    _userSelected = user;
  }

  set loggedIn(bool value) {
    _loggedIn = value;
    prefs.setBool('LoggedIn', value);
    notifyListeners();
  }

  void getUser() async {
    if (_loggedIn) {
      _loggedUser = await UserPreferences().getUser();
    }
  }

  Future<void> checkLoggedIn() async {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
    if (loggedIn) {
      final token = await UserPreferences().getToken();
      bool tokenIsExpired = JwtDecoder.isExpired(token);
      if (tokenIsExpired) {
        //eliminamos el sharedPreference del usuario ya que vence el token
        await UserPreferences().removeUser();
        loggedIn = false;
        Param.showToast("Su sesión ha vencido");
      } else {
        Api.setToken(token);
        print(token);
      }
    }
  }

  Status _loggedInStatus = Status.NotLoggedIn;
  final Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String username, String password) async {
    Map<String, dynamic> result = {};

    Map<String, dynamic> data = {'username': username, 'password': password};

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    try {
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
            renewalToken: responseData['token'],
            imageData: responseData["imageData"]);

        _loggedUser = authUser;
        await UserPreferences().saveUser(authUser);
        _loggedInStatus = Status.LoggedIn;
        _typeUser = responseData['type'];
        notifyListeners();

        result = {'status': true, 'message': 'Successful', 'user': authUser};
      } else {
        if (response == "401") {
          Param.showToast("Usuario y contraseña incorrectos!");
        } else if (response == "400") {
          Param.showToast(
              "el Nombre de usuario debe tener entre 6 y 50 caracteres!");
        }
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': 'ERROR'};
      }
    } on NoBackendConnectionException catch (_) {
      Param.showToast("Error de conexión");
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
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
