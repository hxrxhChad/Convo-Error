import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../services/index.dart';
import 'index.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  final AuthService authService;
  AuthCubit(this.authService) : super(const AuthState());

  Future<void> login() async {
    if (authService.loginFormError(email, password) == 'null') {
      // setStatus(Loading());
      debugPrint(email);
      debugPrint(password);
      setStatus(Status.loading);
      try {
        final uid = await authService.login(email, password);
        setUid(uid!);
        setIsLogin(true);
        // setStatus(Loaded());
        setStatus(Status.success);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          // setStatus(const Error("Please provide a valid email"));
          setStatus(Status.error);
          setError('Please provide a valid email');
          return;
        } else if (e.code == 'user-disabled') {
          // setStatus(const Error("The account has been disabled"));
          setStatus(Status.error);
          setError('The account has been disabled');
          return;
        } else if (e.code == 'user-not-found') {
          // setStatus(const Error("Provided user account does not exist"));
          setStatus(Status.error);
          setError('Provided user account does not exist');
          return;
        } else if (e.code == 'wrong-password') {
          // setStatus(const Error("You provided a wrong password"));
          setStatus(Status.error);
          setError('You provided a wrong password');
          return;
        }
      }
    } else {
      // setStatus(Error(authService.loginFormError(email, password)));
      setStatus(Status.error);
      setError(authService.loginFormError(email, password));
      return;
    }
  }

  Future<void> REGISTER() async {
    setRegister(false);
    String formError =
        authService.registerFormError(username, email, password, rePassword);
    if (formError == 'null') {
      setStatus(Status.loading);
      try {
        final user = await authService.register(username, email, password);
        if (user != null) {
          try {
            await authService.registerCloud(username, email, password);
            setUid(user.uid);
            setIsLogin(true);
            setStatus(Status.success);
          } catch (e) {
            setStatus(Status.error);
            setError('Unable to Save the Registered Data');
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          setStatus(Status.error);
          setError('Please provide a valid email');
          return;
        } else if (e.code == 'email-already-in-use') {
          setStatus(Status.error);
          setError('The email address is already in use by another account');
          return;
        } else if (e.code == 'operation-not-allowed') {
          setStatus(Status.error);
          setError('Provided operation is not allowed');
          return;
        } else if (e.code == 'weak-password') {
          setStatus(Status.error);
          setError(
              'You provided a very weak password, Please try again with a strong password');
          return;
        }
      }
    } else {
      setStatus(Status.error);
      setError(formError);
      return;
    }
  }

  void setUsername(String username) => emit(state.copyWith(username: username));
  void setEmail(String email) => emit(state.copyWith(email: email));
  void setPassword(String password) => emit(state.copyWith(password: password));
  void setRePassword(String rePassword) =>
      emit(state.copyWith(rePassword: rePassword));
  void setUsernameTaken(bool usernameTaken) =>
      emit(state.copyWith(usernameTaken: usernameTaken));
  void setRegister(bool register) => emit(state.copyWith(register: register));
  void setIsLogin(bool isLogin) => emit(state.copyWith(isLogin: isLogin));
  void setError(String error) => emit(state.copyWith(error: error));
  void setUid(String uid) => emit(state.copyWith(uid: uid));
  void setStatus(Status status) => emit(state.copyWith(status: status));

  String get username => state.username;
  String get email => state.email;
  String get password => state.password;
  String get rePassword => state.rePassword;
  bool get usernameTaken => state.usernameTaken;
  bool get register => state.register;
  bool get isLogin => state.isLogin;
  String get error => state.error;
  String get uid => state.uid;
  Status get status => state.status;

  @override
  AuthState fromJson(Map<String, dynamic> json) {
    return AuthState(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      rePassword: json['rePassword'] as String,
      usernameTaken: json['usernameTaken'] as bool,
      register: json['register'] as bool,
      isLogin: json['isLogin'] as bool,
      error: json['error'] as String,
      uid: json['uid'] as String,
      status: Status.values[json['status'] as int],
    );
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return {
      'username': state.username,
      'email': state.email,
      'password': state.password,
      'rePassword': state.rePassword,
      'usernameTaken': state.usernameTaken,
      'register': state.register,
      'isLogin': state.isLogin,
      'error': state.error,
      'uid': state.uid,
      'status': state.status.index,
    };
  }
}

class AuthState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String rePassword;
  final bool usernameTaken;
  final bool register;
  final bool isLogin;
  final String error;
  final String uid;
  final Status status;

  const AuthState(
      {this.username = '',
      this.email = '',
      this.password = '',
      this.rePassword = '',
      this.usernameTaken = false,
      this.register = false,
      this.isLogin = false,
      this.error = '',
      this.uid = '',
      this.status = Status.initial});

  AuthState copyWith(
      {String? username,
      String? email,
      String? password,
      String? rePassword,
      bool? usernameTaken,
      bool? register,
      bool? isLogin,
      String? error,
      String? uid,
      Status? status}) {
    return AuthState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      usernameTaken: usernameTaken ?? this.usernameTaken,
      register: register ?? this.register,
      isLogin: isLogin ?? this.isLogin,
      error: error ?? this.error,
      uid: uid ?? this.uid,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        username,
        email,
        password,
        rePassword,
        usernameTaken,
        register,
        isLogin,
        error,
        uid,
        status
      ];
}
