import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/index.dart';

class AuthService {
  String loginFormError(String email, String password) {
    if (email.isEmpty) {
      return "Email can't be empty";
    } else if (password.isEmpty) {
      return "Password can't be empty";
    } else if (password.length < 8) {
      return "Password can't be less than 8 characters";
    } else {
      return 'null';
    }
  }

  String registerFormError(
      String username, String email, String password, String rePassword) {
    if (username.isEmpty) {
      return "Username can't be empty";
    } else if (email.isEmpty) {
      return "Email can't be empty";
    } else if (password.isEmpty) {
      return "Password can't be empty";
    } else if (password.length < 8) {
      return "Password can't be less than 8 characters";
    } else if (rePassword != password) {
      return "re-check your password";
    } else {
      return 'null';
    }
  }

  Future<String?> login(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return credential.user?.uid;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<User?> register(String username, String email, String password) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  Future<void> registerCloud(
    String username,
    String email,
    String password,
  ) async {
    Register user = Register(
        username: username,
        email: email,
        password: password,
        name: '',
        time: DateTime.now().millisecondsSinceEpoch.toString(),
        photo: '',
        cover: '');

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    user.id = userRef.id;
    final data = user.toJson();

    userRef.set(data);
  }
}
