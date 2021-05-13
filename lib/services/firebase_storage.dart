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
        .child("profile_photo.png");

    firebase_storage.UploadTask uploadTask = _reference.putFile(fileToUpload);

    /*firebase_storage.TaskSnapshot snapshot =*/
    await uploadTask;

    var url = await _reference.getDownloadURL();
    return url;
  }

  @override
  Future<String> uploadVerifyFile(
      String userId, File verifyFile, String fileName) async{
    _reference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(userId)
        .child("verify_file")
        .child(fileName);

    firebase_storage.UploadTask uploadTask = _reference.putFile(verifyFile);

    await uploadTask;

    var url = await _reference.getDownloadURL();
    return url;
  }
}
