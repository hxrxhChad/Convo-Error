import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../repository/index.dart';
import 'index.dart';

class EditProfileCubit extends HydratedCubit<EditProfileState> {
  final SettingsRepository settingsRepository;
  EditProfileCubit(this.settingsRepository) : super(const EditProfileState());

  @override
  EditProfileState fromJson(Map<String, dynamic> json) {
    return EditProfileState(
      name: json['name'],
      username: json['username'],
      photo: json['photo'],
      cover: json['cover'],
      status: Status.values[json['status'] as int],
    );
  }

  @override
  Map<String, dynamic> toJson(EditProfileState state) {
    return {
      'name': state.name,
      'username': state.username,
      'photo': state.photo,
      'cover': state.cover,
      'status': state.status.index,
    };
  }

  late StreamSubscription<DocumentSnapshot> _subscription;

  Future<void> updateUsername(String username) async {
    setStatus(Status.loading);
    try {
      await settingsRepository.setUsername(username);
      setUsername(username);
      setStatus(Status.initial);
    } catch (e) {
      setStatus(Status.error);
    }
  }

  Future<void> updateName(String name) async {
    setStatus(Status.loading);
    try {
      await settingsRepository.setName(name);
      setName(name);
      setStatus(Status.initial);
    } catch (e) {
      setStatus(Status.error);
    }
  }

  Future<void> updatePhoto(String photo) async {
    setStatus(Status.loading);
    try {
      await settingsRepository.setPhoto(photo);
      setPhoto(photo);
      setStatus(Status.initial);
    } catch (e) {
      setStatus(Status.error);
    }
  }

  Future<void> updateCover(String cover) async {
    setStatus(Status.loading);
    try {
      await settingsRepository.setCover(cover);
      setCover(cover);
      setStatus(Status.initial);
    } catch (e) {
      setStatus(Status.error);
    }
  }

  void fetchUserData(String authId) {
    final userRef = FirebaseFirestore.instance.collection('users').doc(authId);

    _subscription = userRef.snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final name = data['name'] ?? '';
        final username = data['username'] ?? '';
        final photo = data['photo'] ?? '';
        final cover = data['cover'] ?? '';

        emit(EditProfileState(
            name: name,
            username: username,
            photo: photo,
            cover: cover,
            status: Status.initial));
      } else {
        // Handle the case when the document does not exist
        emit(const EditProfileState(
            name: '',
            username: '',
            photo: '',
            cover: '',
            status: Status.initial));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  void setName(String name) => emit(state.copyWith(name: name));
  void setUsername(String username) => emit(state.copyWith(username: username));
  void setPhoto(String photo) => emit(state.copyWith(photo: photo));
  void setCover(String cover) => emit(state.copyWith(cover: cover));
  void setStatus(Status status) => emit(state.copyWith(status: status));

  String get name => state.name;
  String get username => state.username;
  String get photo => state.photo;
  String get cover => state.cover;
  Status get status => state.status;
}

class EditProfileState extends Equatable {
  final String name;
  final String username;
  final String photo;
  final String cover;
  final Status status;

  const EditProfileState(
      {this.name = '',
      this.username = '',
      this.photo = '',
      this.cover = '',
      this.status = Status.initial});

  EditProfileState copyWith(
      {String? name,
      String? username,
      String? photo,
      String? cover,
      Status? status}) {
    return EditProfileState(
      name: name ?? this.name,
      username: username ?? this.username,
      photo: photo ?? this.photo,
      cover: cover ?? this.cover,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [name, username, photo, cover, status];
}
