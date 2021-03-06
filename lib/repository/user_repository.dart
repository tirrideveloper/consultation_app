import 'dart:io';

import 'package:consultation_app/locator.dart';
import 'package:consultation_app/models/case_model.dart';
import 'package:consultation_app/models/chats_model.dart';
import 'package:consultation_app/models/comment_model.dart';
import 'package:consultation_app/models/message_model.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/services/auth_base.dart';
import 'package:consultation_app/services/fake_auth.dart';
import 'package:consultation_app/services/firebase_auth.dart';
import 'package:consultation_app/services/firebase_storage.dart';
import 'package:consultation_app/services/firestore_db.dart';
import 'package:timeago/timeago.dart' as timeAgo;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FireStoreDbService _firestoreDBService = locator<FireStoreDbService>();
  FirebaseStorageService _storageService = locator<FirebaseStorageService>();

  //RELEASE => firebase
  //DEBUG => random
  AppMode appMode = AppMode.RELEASE;
  List<UserModel> usersList = [];
  List<CaseModel> allCaseList = [];
  List<CaseModel> allSearchedCaseList = [];

  @override
  Future<UserModel> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserModel _user = await _firebaseAuthService.currentUser();
      if (_user != null)
        return await _firestoreDBService.readUser(_user.userId);
      else
        return null;
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
      if (_user != null) {
        bool _result = await _firestoreDBService.saveUser(_user);
        if (_result) {
          return await _firestoreDBService.readUser(_user.userId);
        } else {
          await _firebaseAuthService.signOut();
          return null;
        }
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
      if (_user != null) {
        bool _result = await _firestoreDBService.saveUser(_user);
        if (_result) {
          return await _firestoreDBService.readUser(_user.userId);
        } else {
          await _firebaseAuthService.signOut();
          return null;
        }
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

  Future<bool> updateUser(String userId, String nameSurname, String aboutUser,
      String userProfession) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUser(
          userId, nameSurname, aboutUser, userProfession);
    }
  }

  Future<String> uploadFile(
      String userId, String fileType, File profilePhoto) async {
    if (appMode == AppMode.DEBUG) {
      return "file_download_link";
    } else {
      var profilePhotoUrl =
          await _storageService.uploadPhoto(userId, fileType, profilePhoto);
      await _firestoreDBService.updateProfilePhoto(userId, profilePhotoUrl);
      return profilePhotoUrl;
    }
  }

  @override
  Future resetUserPassword(String email) async {
    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      return await _firebaseAuthService.resetUserPassword(email);
    }
  }

  Future<String> uploadVerifyFile(
      String userId, File verifyFile, String fileName) async {
    if (appMode == AppMode.DEBUG) {
      return "file_download_link";
    } else {
      var verifyFileUrl =
          await _storageService.uploadVerifyFile(userId, verifyFile, fileName);
      await _firestoreDBService.updateVerifyFile(userId, verifyFileUrl);
      return verifyFileUrl;
    }
  }

  Future<bool> saveMessage(Message message) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDBService.saveMessage(message);
    }
  }

  Future<List<UserModel>> getUsersList() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      usersList = await _firestoreDBService.usersList();
      return null;
    }
  }

  Future<List<Chats>> getAllConversations(String userId) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _time = await _firestoreDBService.showTime(userId);
      var chatsList = await _firestoreDBService.getAllConversations(userId);
      for (var snapChat in chatsList) {
        var userInUsersList = findUser(snapChat.messageReceiver);

        if (userInUsersList != null) {
          snapChat.spokenUserName = userInUsersList.userName;
          snapChat.spokenUserProfileURL = userInUsersList.profileURL;
        } else {
          var _readUser =
              await _firestoreDBService.readUser(snapChat.messageReceiver);
          snapChat.spokenUserName = _readUser.nameSurname;
          snapChat.spokenUserProfileURL = _readUser.profileURL;
        }
        calculateTimeAgo(snapChat, _time);
      }
      return chatsList;
    }
  }

  Future<String> uploadCasePhotos(
      String caseId, String fileName, File casePhoto) async {
    if (appMode == AppMode.DEBUG) {
      return "file_download_link";
    } else {
      var casePhotoUrl =
          await _storageService.uploadCasePhotos(caseId, fileName, casePhoto);
      return casePhotoUrl;
    }
  }

  Future<bool> updateUserCases(String userId, String newCaseId) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return _firestoreDBService.updateUserCases(userId, newCaseId);
    }
  }

  void calculateTimeAgo(Chats snapChat, DateTime time) {
    snapChat.lastReadTime = time;

    timeAgo.setLocaleMessages("tr", timeAgo.TrMessages());

    var _duration = time.difference(snapChat.creationDate.toDate());
    snapChat.timeDifference =
        timeAgo.format(time.subtract(_duration), locale: "tr");
  }

  UserModel findUser(String userId) {
    for (int i = 0; i < usersList.length; i++) {
      if (usersList[i].userId == userId) {
        return usersList[i];
      }
    }
    return null;
  }

  Future<List<Message>> getMessageWithPagination(String currentUserId,
      String otherUserId, Message lastMessage, int numberOfElements) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      return await _firestoreDBService.getMessagesWithPagination(
          currentUserId, otherUserId, lastMessage, numberOfElements);
    }
  }

  Stream<List<Message>> getMessages(String currentUserId, String otherUserId) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDBService.getMessages(currentUserId, otherUserId);
    }
  }

  Future<bool> saveCase(CaseModel caseModel) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDBService.saveCase(caseModel);
    }
  }

  Future<List<CaseModel>> getCaseWithPagination(
      CaseModel lastLoadedCase, int valuePerPage) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<CaseModel> _caseList = await _firestoreDBService
          .getCaseWithPagination(lastLoadedCase, valuePerPage);
      allCaseList.addAll(_caseList);
      return _caseList;
    }
  }

  Future<List<CaseModel>> getTagSearchedCases(
      String tag) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<CaseModel> _caseList = await _firestoreDBService
          .getTagSearchedCases(tag);
      allSearchedCaseList.addAll(_caseList);
      return _caseList;
    }
  }

  Future<bool> checkPassword(String password) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return await _firebaseAuthService.checkPassword(password);
    }
  }

  Future<bool> updateUserPassword(String password) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return await _firebaseAuthService.updateUserPassword(password);
    }
  }

  Future<bool> sendFeedback(String userId, String feedback) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return await _firestoreDBService.sendFeedback(userId, feedback);
    }
  }

  Future<bool> saveComment(
      CommentModel commentModel, CaseModel caseModel, String userId) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDBService.saveComment(commentModel, caseModel, userId);
    }
  }

  Stream<List<CommentModel>> getComments(CaseModel caseModel) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDBService.getComments(caseModel);
    }
  }


  Future<void> deleteComment(
      String commentId, CaseModel caseModel, String userId) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDBService.deleteComment(commentId, caseModel, userId);
    }
  }
}
