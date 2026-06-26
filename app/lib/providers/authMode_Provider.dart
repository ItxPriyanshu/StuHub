import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:stuhub/models/userModel.dart';

enum AuthMode{
  login,
  register,
}


class AuthModeNotifier extends Notifier<AuthMode>{
  @override
  AuthMode build() {
    return AuthMode.login;
  }

  void setLogin(){
    state = AuthMode.login;
  }

  void setRegister(){
    state = AuthMode.register;
  }
  
}


final authModeProvider = NotifierProvider<AuthModeNotifier,AuthMode>(
  AuthModeNotifier.new,
);


