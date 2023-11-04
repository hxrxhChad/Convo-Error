import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/index.dart';
import '../services/index.dart';
import 'index.dart';

class MessageCubit extends Cubit<MessageState> {
  final String ChatId;
  final MessageService messageService = MessageService();
  late StreamSubscription<List<MessageModel>> _messageSubscription;

  MessageCubit({required this.ChatId}) : super(const MessageState()) {
    if (ChatId != '') {
      _messageSubscription =
          messageService.getMessage(ChatId).listen((messages) {
        setMessageModel(messages);
      });
    }
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    return super.close();
  }

  void setStatus(Status status) => emit(state.copyWith(status: status));
  void setError(String error) => emit(state.copyWith(error: error));
  void setWriting(bool writing) => emit(state.copyWith(writing: writing));
  void setChatId(String chatId) => emit(state.copyWith(chatId: chatId));
  void setMessageModel(List<MessageModel> messageModel) =>
      emit(state.copyWith(messageModel: messageModel));

  Status get status => state.status;
  String get error => state.error;
  bool get writing => state.writing;
  String get chatId => state.chatId;

  List<MessageModel> get messageModel => state.messageModel;
}

class MessageState extends Equatable {
  final Status status;
  final String error;
  final bool writing;
  final String chatId;
  final List<MessageModel> messageModel;

  const MessageState(
      {this.status = Status.initial,
      this.error = '',
      this.writing = false,
      this.chatId = '',
      this.messageModel = const []});

  MessageState copyWith(
      {Status? status,
      String? error,
      bool? writing,
      String? chatId,
      List<MessageModel>? messageModel}) {
    return MessageState(
        status: status ?? this.status,
        error: error ?? this.error,
        writing: writing ?? this.writing,
        chatId: chatId ?? this.chatId,
        messageModel: messageModel ?? this.messageModel);
  }

  @override
  List<Object?> get props => [status, error, writing, chatId, messageModel];
}
