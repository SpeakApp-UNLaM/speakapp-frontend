
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/providers/auth_provider.dart';

import '../shared/infraestructure/inputs/email.dart';
import '../shared/infraestructure/inputs/password.dart';

class LoginProvider extends ChangeNotifier {
  bool isPosting;
  bool isFormPosted;
  bool isValid;
  Email email;
  Password password;

  LoginProvider(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    password = newPassword;
    isValid = Formz.validate([newPassword]);
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    email = newEmail;
    isValid = Formz.validate([newEmail]);
  }

  onFormSubmit(BuildContext context) {
    final _email = Email.dirty(email.value);
    final _password = Password.dirty(password.value);

    isFormPosted = true;
    isValid = Formz.validate([_email, _password]);

    notifyListeners();

/*
    if (!isValid) {
      return;
    }*/

    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);


        auth
        .login(email.value, password.value)
        .then((value) => {print(value)});
  }
}
