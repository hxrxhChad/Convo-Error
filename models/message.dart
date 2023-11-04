import 'dart:convert';

import 'package:equatable/equatable.dart';

MessageModel messageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel extends Equatable {
  final String messageId;
  final String chatId;
  final String senderId;
  final int time;
  final String type;
  final String content;

  const MessageModel(
      {required this.messageId,
      required this.chatId,
      required this.senderId,
      required this.time,
      required this.type,
      required this.content});

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
      messageId: json["messageId"],
      chatId: json["chatId"],
      senderId: json["senderId"],
      time: json["time"],
      type: json["type"],
      content: json["content"]);

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'chatId': chatId,
        'senderId': senderId,
        'time': time,
        'type': type,
        'content': content
      };

  @override
  List<Object?> get props => [messageId, chatId, senderId, time, type, content];
}
