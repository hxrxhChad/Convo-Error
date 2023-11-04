import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/index.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessage(String chatId) {
    return _firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('time')
        .snapshots()
        .map((event) => event.docs
            .map((e) => MessageModel(e['messageId'], e['chatId'], e['senderId'],
                e['receiverId'], e['time'], e['seen'], e['type'], e['content']))
            .toList());
  }
}
