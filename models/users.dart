import 'dart:convert';

import 'package:equatable/equatable.dart';

UsersModel usersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel extends Equatable {
  final String userId;
  final String name;
  final String email;
  final String password;
  final String photo;
  final int time;

  const UsersModel(
      {required this.userId,
      required this.name,
      required this.email,
      required this.password,
      required this.photo,
      required this.time});

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      photo: json['photo'],
      time: json['time']);

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'email': email,
        'password': password,
        'photo': photo,
        'time': time
      };

  @override
  List<Object?> get props => [userId, name, email, password, photo, time];
}
