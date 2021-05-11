import 'dart:io';

import 'package:consultation_app/services/storage_base.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageService implements StorageBase {

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  firebase_storage.Reference _reference;

  @override
  Future<String> uploadPhoto(
      String userId, String fileType, File fileToUpload) async {
    _reference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType)
        .child("profil_foto.png");

    firebase_storage.UploadTask uploadTask = _reference.putFile(fileToUpload);

    firebase_storage.TaskSnapshot snapshot = await uploadTask;

    var url = await _reference.getDownloadURL();
    return url;
  }
}
