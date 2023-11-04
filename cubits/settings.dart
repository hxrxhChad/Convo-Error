import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/index.dart';
import 'index.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository settingsRepository;
  SettingsCubit(this.settingsRepository) : super(const SettingsState());

  Future<void> signOut() async {
    setStatus(Status.loading);
    try {
      await FirebaseAuth.instance.signOut();
      setStatus(Status.success);
    } catch (e) {
      setStatus(Status.error);
      setError(e.toString());
    }
  }

  void settingsInit(userId) {
    setStatus(Status.loading);
    try {
      settingsRepository.getName(userId).listen((name) {
        setName(name);
      });
      settingsRepository.getUsername(userId).listen((username) {
        setUsername(username);
      });
      settingsRepository.getPhoto(userId).listen((photo) {
        setPhoto(photo);
      });
      settingsRepository.getCover(userId).listen((cover) {
        setCover(cover);
      });
      setStatus(Status.initial);
    } catch (e) {
      setStatus(Status.error);
      setError(error);
    }
  }

  Future<void> updateName(String name) async {
    // setStatus(Status.loading);
    try {
      await settingsRepository.setName(name);
      setName(name);
      settingsInit(FirebaseAuth.instance.currentUser?.uid);
      setStatus(Status.initial);
    } catch (e) {
      setStatus(Status.error);
      setError(e.toString());
    }
  }

  Future<void> updateUsername(String username) async {
    // setStatus(Status.loading);
    try {
      await settingsRepository.setUsername(username);
      setUsername(username);
      settingsInit(FirebaseAuth.instance.currentUser?.uid);
      setStatus(Status.initial);
    } catch (e) {
      setStatus(Status.error);
      setError(e.toString());
    }
  }

  Future<void> updatePhoto(String photo) async {
    setStatus(Status.loading);
    try {
      await settingsRepository.setPhoto(photo);
      setPhoto(photo);
      settingsInit(FirebaseAuth.instance.currentUser?.uid);
      setStatus(Status.initial);
    } catch (e) {
      setStatus(Status.error);
      setError(e.toString());
    }
  }

  Future<void> updateCover(String cover) async {
    setStatus(Status.loading);
    try {
      await settingsRepository.setCover(cover);
      setCover(cover);
      settingsInit(FirebaseAuth.instance.currentUser?.uid);
      setStatus(Status.initial);
    } catch (e) {
      setStatus(Status.error);
      setError(e.toString());
    }
  }

  void setName(String name) => emit(state.copyWith(name: name));
  void setUsername(String username) => emit(state.copyWith(username: username));
  void setPhoto(String photo) => emit(state.copyWith(photo: photo));
  void setCover(String cover) => emit(state.copyWith(cover: cover));
  void setError(String error) => emit(state.copyWith(error: error));
  void setStatus(Status status) => emit(state.copyWith(status: status));

  String get name => state.name;
  String get username => state.username;
  String get photo => state.photo;
  String get cover => state.cover;
  String get error => state.error;
  Status get status => state.status;
}

class SettingsState extends Equatable {
  final String name;
  final String username;
  final String photo;
  final String cover;
  final String error;
  final Status status;

  const SettingsState(
      {this.name = '',
      this.username = '',
      this.photo = '',
      this.cover = '',
      this.error = '',
      this.status = Status.initial});

  SettingsState copyWith(
      {String? name,
      String? username,
      String? photo,
      String? cover,
      String? error,
      Status? status}) {
    return SettingsState(
        name: name ?? this.name,
        username: username ?? this.username,
        photo: photo ?? this.photo,
        cover: cover ?? this.cover,
        error: error ?? this.error,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [name, username, photo, cover, error, status];
}
