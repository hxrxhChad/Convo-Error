import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../models/index.dart';

class ChatService {
  Stream<List<ChatTileModel>> getChatTileModel() {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('participants',
            arrayContains: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .asyncMap((chatSnapshot) async {
      final List<ChatTileModel> chatTileList = [];

      for (final doc in chatSnapshot.docs) {
        final chat = ChatModel(
          doc.id,
          List<String>.from(doc['participants']),
          doc['lastMessageId'],
        );

        final lastMessageStream = fetchLastMessage(chat.lastMessageId);
        final lastMessage = await lastMessageStream.first;

        final receiverStream = fetchReceiver(chat.participants);
        final receiver = await receiverStream.first;

        final chatTile = ChatTileModel(
          chatId: chat.chatId,
          image: receiver.photo,
          name: receiver.name,
          content: lastMessage.content,
          time: lastMessage.time.toString(),
          newMessage: lastMessage.seen,
          active: receiver.active,
        );

        chatTileList.add(chatTile);
      }

      return chatTileList;
    });
  }

  Stream<MessageModel> fetchLastMessage(String messageId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .snapshots()
        .map((messageSnapshot) {
      final data = messageSnapshot.data() as Map<String, dynamic>;
      return MessageModel(
        messageId,
        data['chatId'],
        data['senderId'],
        data['receiverId'],
        data['time'],
        data['seen'],
        data['type'],
        data['content'],
      );
    });
  }

  Stream<UsersModel> fetchReceiver(List<String> participants) {
    String otherParticipantId = participants.firstWhere(
      (participantId) =>
          participantId != FirebaseAuth.instance.currentUser?.uid,
      orElse: () => '',
    );

    if (otherParticipantId.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(otherParticipantId)
          .snapshots()
          .asyncMap((userSnapshot) async {
        final userData = userSnapshot.data() as Map<String, dynamic>;

        final activeStatusSnapshot = await FirebaseFirestore.instance
            .collection('active_status')
            .doc(otherParticipantId)
            .get();

        final activeData = activeStatusSnapshot.data() as Map<String, dynamic>;

        return UsersModel(
          userId: otherParticipantId,
          name: userData['name'],
          email: userData['email'],
          username: userData['username'],
          photo: userData['photo'],
          cover: userData['cover'],
          active: activeData['active'] ?? false,
        );
      });
    } else {
      return Stream.value(UsersModel(
        userId: '',
        name: '',
        email: '',
        username: '',
        photo: '',
        cover: '',
        active: false,
      ));
    }
  }

  Stream<List<UsersModel>> getSearchedList(String searchedName) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: searchedName)
        .where('name', isLessThan: '${searchedName}z')
        .snapshots()
        .asyncMap((querySnapshot) async {
      final List<UsersModel> searchedUsers = [];

      for (var documentSnapshot in querySnapshot.docs) {
        final userData = documentSnapshot.data();

        final activeStatus = await fetchActiveStatus(documentSnapshot.id);

        final user = UsersModel(
          userId: documentSnapshot.id,
          name: userData['name'],
          email: userData['email'],
          username: userData['username'],
          photo: userData['photo'],
          cover: userData['cover'],
          active: false,
        );

        searchedUsers.add(user);
      }

      return searchedUsers;
    });
  }

  Stream<bool> fetchActiveStatus(String userId) {
    return FirebaseFirestore.instance
        .collection('active_status')
        .doc(userId)
        .snapshots()
        .map((activeStatusSnapshot) {
      if (activeStatusSnapshot.exists) {
        final activeStatusData = activeStatusSnapshot.data();
        return activeStatusData!['active'] ?? false;
      } else {
        return false; // Default to false if the document doesn't exist
      }
    });
  }
}
