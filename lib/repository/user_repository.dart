import 'dart:io';

import 'package:consultation_app/locator.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/services/auth_base.dart';
import 'package:consultation_app/services/fake_auth.dart';
import 'package:consultation_app/services/firebase_auth.dart';
import 'package:consultation_app/services/firebase_storage.dart';
import 'package:consultation_app/services/firestore_db.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FireStoreDbService _firestoreDBService = locator<FireStoreDbService>();
  FirebaseStorageService _storageService = locator<FirebaseStorageService>();

  //RELEASE => firebase
  //DEBUG => random
  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserModel _user = await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_user.userId);
    }
  }

  @override
  Future<UserModel> signInAnon() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnon();
    } else {
      return await _firebaseAuthService.signInAnon();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel> signInGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInGoogle();
    } else {
      UserModel _user = await _firebaseAuthService.signInGoogle();
      bool _result = await _firestoreDBService.saveUser(_user);
      if (_result) {
        return await _firestoreDBService.readUser(_user.userId);
      } else
        return null;
    }
  }

  @override
  Future<UserModel> signInFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInFacebook();
    } else {
      UserModel _user = await _firebaseAuthService.signInFacebook();
      bool _result = await _firestoreDBService.saveUser(_user);
      if (_result) {
        return await _firestoreDBService.readUser(_user.userId);
      } else
        return null;
    }
  }

  @override
  Future<UserModel> createEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createEmailAndPassword(email, password);
    } else {
      UserModel _user =
          await _firebaseAuthService.createEmailAndPassword(email, password);
      bool _result = await _firestoreDBService.saveUser(_user);
      if (_result) {
        return await _firestoreDBService.readUser(_user.userId);
      } else
        return null;
    }
  }

  @override
  Future<UserModel> signInEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInEmailAndPassword(email, password);
    } else {
      UserModel _user =
          await _firebaseAuthService.signInEmailAndPassword(email, password);
      return await _firestoreDBService.readUser(_user.userId);
    }
  }

  Future<bool> updateUserName(String userId, String userName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(userId, userName);
    }
  }

  Future<bool> updateUser(
      String userId, String nameSurname, String aboutUser) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUser(
          userId, nameSurname, aboutUser);
    }
  }

  Future<String> uploadFile(
      String userId, String fileType, File profilePhoto) async{
    if (appMode == AppMode.DEBUG) {
      return "file_download_link";
    } else {
      var profilePhotoUrl =  await _storageService.uploadPhoto(
          userId, fileType, profilePhoto);
      await _firestoreDBService.updateProfilePhoto(userId, profilePhotoUrl);
      return profilePhotoUrl;
    }
  }

  @override
  Future resetUserPassword(String email) async {
    if(appMode == AppMode.DEBUG){
      return null;
    }
    else{
      return await _firebaseAuthService.resetUserPassword(email);
    }
  }

  Future<String> uploadVerifyFile(
      String userId, File verifyFile, String fileName) async{
    if (appMode == AppMode.DEBUG) {
      return "file_download_link";
    } else {
      var verifyFileUrl =  await _storageService.uploadVerifyFile(
          userId, verifyFile, fileName);
      await _firestoreDBService.updateVerifyFile(userId, verifyFileUrl);
      return verifyFileUrl;
    }
  }
}
