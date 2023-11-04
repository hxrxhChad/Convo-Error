import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/index.dart';
import '../services/index.dart';
import 'index.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService chatService = ChatService();
  late StreamSubscription<List<ChatTileModel>> chatTileModelSubscription;

  ChatCubit() : super(const ChatState()) {
    chatTileModelSubscription =
        chatService.getChatTileModel().listen((chatTileModel) {
      setChatTileModel(chatTileModel);
    });
  }

  @override
  Future<void> close() {
    chatTileModelSubscription.cancel();
    return super.close();
  }

  void setStatus(Status status) => emit(state.copyWith(status: status));
  void setError(String error) => emit(state.copyWith(error: error));
  void setIsSearching(bool isSearching) =>
      emit(state.copyWith(isSearching: isSearching));
  void setSearchedName(String searchedName) =>
      emit(state.copyWith(searchedName: searchedName));
  void setChatTileModel(List<ChatTileModel> chatTileModel) =>
      emit(state.copyWith(chatTileModel: chatTileModel));

  Status get status => state.status;
  String get error => state.error;
  bool get isSearching => state.isSearching;
  String get searchedName => state.searchedName;
  List<ChatTileModel> get chatTileModel => state.chatTileModel;
}

class ChatState extends Equatable {
  final Status status;
  final String error;
  final bool isSearching;
  final String searchedName;
  final List<ChatTileModel> chatTileModel;

  const ChatState({
    this.status = Status.initial,
    this.error = '',
    this.isSearching = false,
    this.searchedName = '',
    this.chatTileModel = const [],
  });

  ChatState copyWith(
      {Status? status,
      String? error,
      bool? isSearching,
      String? searchedName,
      List<ChatTileModel>? chatTileModel}) {
    return ChatState(
        status: status ?? this.status,
        error: error ?? this.error,
        isSearching: isSearching ?? this.isSearching,
        searchedName: searchedName ?? this.searchedName,
        chatTileModel: chatTileModel ?? this.chatTileModel);
  }

  @override
  List<Object?> get props =>
      [status, error, isSearching, searchedName, chatTileModel];
}
