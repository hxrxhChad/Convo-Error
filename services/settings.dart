import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/index.dart';


class SettingsService {
  Future<void> setCover(String cover) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'cover': cover});
  }

  Future<void> setPhoto(String photo) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'photo': photo});
  }

  Future<void> setName(String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'name': name});
  }

  Future<void> setUsername(String username) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'username': username});
  }

  Future<String?> uploadCover() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return null;
    final Reference storageReference = FirebaseStorage.instance.ref().child(
        "cover/${DateTime.now()}.jpg"); // Replace "images" with your desired folder name.
    final UploadTask uploadTask =
        storageReference.putFile(File(pickedImage.path));
    final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() {}));
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }

  Future<String?> uploadPhoto() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return null;
    final Reference storageReference = FirebaseStorage.instance.ref().child(
        "photo/${DateTime.now()}.jpg"); // Replace "images" with your desired folder name.
    final UploadTask uploadTask =
        storageReference.putFile(File(pickedImage.path));
    final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() {}));
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }

  Stream<UsersModel> getUser(String userId) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return firestore
        .collection('users')
        .doc(userId) // Specify the document ID (userId) you want to retrieve
        .snapshots()
        .asyncMap((documentSnapshot) async {
      if (documentSnapshot.exists) {
        final userData = documentSnapshot.data();

        // Fetch the active status from another collection
        final activeStatus = await fetchActiveStatus(userId);

        return UsersModel(
          userId: userId,
          name: userData!['name'],
          email: userData['email'],
          username: userData['username'],
          photo: userData['photo'],
          cover: userData['cover'],
          active: activeStatus,
        );
      } else {
        // If the document doesn't exist, return an empty UsersModel or handle it as needed
        return UsersModel(
          userId: '',
          name: '',
          email: '',
          username: '',
          photo: '',
          cover: '',
          active: false,
        );
      }
    });
  }

  Future<bool> fetchActiveStatus(String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final activeStatusSnapshot =
        await firestore.collection('active_status').doc(userId).get();

    if (activeStatusSnapshot.exists) {
      final activeStatusData = activeStatusSnapshot.data();
      return activeStatusData!['active'] ?? false;
    } else {
      return false; // Default to false if the document doesn't exist
    }
  }

  Stream<String> getCover(String userId) {
    StreamController<String> controller = StreamController<String>();

    // Create a reference to the user's document in Firestore
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Listen for changes in the 'cover' field and emit updates to the stream
    final subscription = userDocRef.snapshots().listen((userDoc) {
      if (userDoc.exists) {
        final cover = userDoc.data()?['cover'] ?? '';
        controller.add(cover);
      } else {
        controller.add(''); // User not found
      }
    });

    return controller.stream;
  }

  Stream<String> getName(String userId) {
    StreamController<String> controller = StreamController<String>();

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    final subscription = userDocRef.snapshots().listen((userDoc) {
      if (userDoc.exists) {
        final name = userDoc.data()?['name'] ?? '';
        controller.add(name);
      } else {
        controller.add(''); // User not found
      }
    });

    return controller.stream;
  }

  Stream<String> getPhoto(String userId) {
    StreamController<String> controller = StreamController<String>();

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    final subscription = userDocRef.snapshots().listen((userDoc) {
      if (userDoc.exists) {
        final photo = userDoc.data()?['photo'] ?? '';
        controller.add(photo);
      } else {
        controller.add(''); // User not found
      }
    });

    return controller.stream;
  }

  Stream<String> getUsername(String userId) {
    StreamController<String> controller = StreamController<String>();

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    final subscription = userDocRef.snapshots().listen((userDoc) {
      if (userDoc.exists) {
        final username = userDoc.data()?['username'] ?? '';
        controller.add(username);
      } else {
        controller.add(''); // User not found
      }
    });

    return controller.stream;
  }
}
