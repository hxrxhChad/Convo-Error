import 'dart:convert';

import 'package:equatable/equatable.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel extends Equatable {
  final String chatId;
  final List<String> participants;

  const ChatModel({required this.chatId, required this.participants});

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      ChatModel(chatId: json['chatId'], participants: json['participants']);

  Map<String, dynamic> toJson() =>
      {'chatId': chatId, 'participants': participants};

  @override
  List<Object?> get props => [chatId, participants];
}
