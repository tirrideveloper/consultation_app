import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/models/case_model.dart';
import 'package:consultation_app/models/chats_model.dart';
import 'package:consultation_app/models/comment_model.dart';
import 'package:consultation_app/models/message_model.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/services/db_base.dart';

class FireStoreDbService implements DbBase {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel userModel) async {
    DocumentSnapshot _checkUser =
        await FirebaseFirestore.instance.doc("users/${userModel.userId}").get();

    if (_checkUser.data() == null) {
      await _firestoreDB
          .collection("users")
          .doc(userModel.userId)
          .set(userModel.toMap());
      return true;
    } else
      return true;
  }

  @override
  Future<UserModel> readUser(String userId) async {
    DocumentSnapshot _readUser =
        await _firestoreDB.collection("users").doc(userId).get();
    Map<String, dynamic> _userInformationMap = _readUser.data();

    UserModel _readUserObject = UserModel.fromMap(_userInformationMap);
    return _readUserObject;
  }

  @override
  Future<bool> updateUserName(String userId, String userName) async {
    var users = await _firestoreDB
        .collection("users")
        .where("userName", isEqualTo: userName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestoreDB
          .collection("users")
          .doc(userId)
          .update({"userName": userName});
      return true;
    }
  }

  @override
  Future<bool> updateUser(String userId, String nameSurname, String aboutUser,
      String userProfession) async {
    await _firestoreDB.collection("users").doc(userId).update({
      "nameSurname": nameSurname,
      "aboutUser": aboutUser,
      "userProfession": userProfession
    });
    return true;
  }

  @override
  Future<bool> updateProfilePhoto(String userId, String profilePhotoUrl) async {
    await _firestoreDB
        .collection("users")
        .doc(userId)
        .update({"profileURL": profilePhotoUrl});
    return true;
  }

  @override
  Future<bool> updateVerifyFile(String userId, String verifyFileUrl) async {
    await _firestoreDB
        .collection("users")
        .doc(userId)
        .update({"verifyFileURL": verifyFileUrl});
    return true;
  }

  Future<bool> saveMessage(Message message) async {
    var _messageId = _firestoreDB.collection("chats").doc().id;
    var _senderDocumentId = message.sender + "--" + message.receiver;
    var _receiverDocumentId = message.receiver + "--" + message.sender;
    var _messageMap = message.toMap();

    await _firestoreDB
        .collection("chats")
        .doc(_senderDocumentId)
        .collection("messages")
        .doc(_messageId)
        .set(_messageMap);

    await _firestoreDB.collection("chats").doc(_senderDocumentId).set({
      "message_sender": message.sender,
      "message_receiver": message.receiver,
      "last_message": message.message,
      "was_seen": false,
      "creation_date": FieldValue.serverTimestamp(),
    });

    _messageMap.update("isFromCurrentUser", (value) => false);

    await _firestoreDB
        .collection("chats")
        .doc(_receiverDocumentId)
        .collection("messages")
        .doc(_messageId)
        .set(_messageMap);

    await _firestoreDB.collection("chats").doc(_receiverDocumentId).set({
      "message_sender": message.receiver,
      "message_receiver": message.sender,
      "last_message": message.message,
      "was_seen": false,
      "creation_date": FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<Chats>> getAllConversations(String userId) async {
    QuerySnapshot querySnapshot = await _firestoreDB
        .collection("chats")
        .where("message_sender", isEqualTo: userId)
        .orderBy("creation_date", descending: true)
        .get();

    List<Chats> allMessages = [];

    for (DocumentSnapshot conversation in querySnapshot.docs) {
      Chats _chat = Chats.fromMap(conversation.data());
      allMessages.add(_chat);
    }
    return allMessages;
  }

  Future<List<Message>> getMessagesWithPagination(String currentUserId,
      String otherUserId, Message lastMessage, int numberOfElements) async {
    QuerySnapshot _querySnapshot;
    List<Message> _allMessages = [];

    if (lastMessage == null) {
      _querySnapshot = await _firestoreDB
          .collection("chats")
          .doc(currentUserId + "--" + otherUserId)
          .collection("messages")
          .orderBy("date", descending: true)
          .limit(numberOfElements)
          .get();
    } else {
      _querySnapshot = await _firestoreDB
          .collection("chats")
          .doc(currentUserId + "--" + otherUserId)
          .collection("messages")
          .orderBy("date", descending: true)
          .startAfter([lastMessage.date])
          .limit(numberOfElements)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Message _message = Message.fromMap(snap.data());
      _allMessages.add(_message);
    }

    return _allMessages;
  }

  @override
  Future<DateTime> showTime(String userId) async {
    await _firestoreDB
        .collection("server")
        .doc(userId)
        .set({"saat": FieldValue.serverTimestamp()});
    var readMap = await _firestoreDB.collection("server").doc(userId).get();
    Timestamp readDate = readMap.data()["saat"];
    return readDate.toDate();
  }

  Future<List<UserModel>> usersList() async {
    QuerySnapshot querySnapshot = await _firestoreDB.collection("users").get();

    List<UserModel> users = [];

    for (DocumentSnapshot user in querySnapshot.docs) {
      UserModel _user = UserModel.fromMap(user.data());
      users.add(_user);
    }

    return users;
  }

  Stream<List<Message>> getMessages(String currentUserId, String otherUserId) {
    var snapshot = _firestoreDB
        .collection("chats")
        .doc(currentUserId + "--" + otherUserId)
        .collection("messages")
        .orderBy("date", descending: true)
        .snapshots();
    return snapshot.map((messageList) => messageList.docs
        .map((message) => Message.fromMap(message.data()))
        .toList());
  }

  Future<bool> saveCase(CaseModel caseModel) async {
    var _caseMap = caseModel.toMap();
    await _firestoreDB
        .collection("vakalar")
        .doc(caseModel.caseTag)
        .collection(caseModel.caseTag + "_vakalari")
        .doc(caseModel.caseId)
        .set(_caseMap);
    return true;
  }

  Future<bool> updateUserCases(String userId, String newCaseId) async {
    await _firestoreDB.collection("users").doc(userId).update({
      "userCases": FieldValue.arrayUnion([newCaseId])
    });
    return true;
  }

  Future<bool> sendFeedback(String userId, String feedback) async {
    var _feedbackId = _firestoreDB.collection("feedbacks").doc().id;

    await _firestoreDB.collection("feedbacks").doc(_feedbackId).set({
      "feedback_sender": userId,
      "feedback_message": feedback,
      "creation_date": FieldValue.serverTimestamp(),
    });

    return true;
  }

  Future<List<CaseModel>> getCaseWithPagination(
      CaseModel lastLoadedCase, int valuePerPage) async {
    QuerySnapshot _querySnapshot;
    List<CaseModel> _allCases = [];
    List tagCases = [];

    if (lastLoadedCase == null) {
      for (String tag in vakaTagi) {
        _querySnapshot = await _firestoreDB
            .collection("vakalar")
            .doc(tag)
            .collection(tag + "_vakalari")
            .orderBy("case_date", descending: true)
            .limit(valuePerPage)
            .get();
        tagCases.add(_querySnapshot);
      }
    } else {
      for (String tag in vakaTagi) {
        _querySnapshot = await _firestoreDB
            .collection("vakalar")
            .doc(tag)
            .collection(tag + "_vakalari")
            .orderBy("case_date", descending: true)
            .startAfter([lastLoadedCase.caseId])
            .limit(valuePerPage)
            .get();
        tagCases.add(_querySnapshot);
      }
      await Future.delayed(Duration(seconds: 1));
    }
    for (QuerySnapshot query in tagCases) {
      for (DocumentSnapshot snap in query.docs) {
        CaseModel _case = CaseModel.fromMap(snap.data());

        String titleId = _case.caseTitle.replaceAll(RegExp(r"\s+"), "");
        String _caseOwnerId = _case.caseId;
        String ownerId = _caseOwnerId.replaceAll("-" + titleId, "");

        DocumentSnapshot _owner = await FirebaseFirestore.instance
            .collection("users")
            .doc(ownerId)
            .get();
        Map<String, dynamic> _ownerMap = _owner.data();

        _case.caseOwner = _ownerMap;

        _allCases.add(_case);
      }
    }
    return _allCases;
  }

  Future<bool> saveComment(
      CommentModel commentModel, CaseModel caseModel, String userId) async {

    var _commentId = _firestoreDB
        .collection("vakalar")
        .doc(caseModel.caseTag)
        .collection(caseModel.caseTag + "_vakalari")
        .doc(caseModel.caseId)
        .collection("comments")
        .doc()
        .id;
    commentModel.commentId = _commentId;

    var _commentMap = commentModel.toMap();

    await _firestoreDB
        .collection("vakalar")
        .doc(caseModel.caseTag)
        .collection(caseModel.caseTag + "_vakalari")
        .doc(caseModel.caseId)
        .collection("comments")
        .doc(_commentId)
        .set(_commentMap);

    await _firestoreDB.collection("users").doc(userId).update({
      "userComments": FieldValue.arrayUnion([_commentId])
    });

    return true;
  }

  Stream<List<CommentModel>> getComments(CaseModel caseModel) {
    var snapshot = _firestoreDB
        .collection("vakalar")
        .doc(caseModel.caseTag)
        .collection(caseModel.caseTag + "_vakalari")
        .doc(caseModel.caseId)
        .collection("comments")
        .orderBy("comment_date")
        .snapshots();

    return snapshot.map((commentList) => commentList.docs
        .map((comment) => CommentModel.fromMap(comment.data()))
        .toList());
  }

  Future<void> deleteComment(String commentId, CaseModel caseModel, String userId) async{
    await _firestoreDB
        .collection("vakalar")
        .doc(caseModel.caseTag)
        .collection(caseModel.caseTag + "_vakalari")
        .doc(caseModel.caseId)
        .collection("comments")
        .doc(commentId).delete();

    await _firestoreDB.collection("users").doc(userId).update({
      "userComments": FieldValue.arrayRemove([commentId])
    });
  }
}

List<String> vakaTagi = [
  "agiz-dis",
  "beyin-sinir",
  "paediatric",
  "diger",
  "genel-cerrahi",
  "gogus-cerrahi",
  "goz-hastaklıkları",
  "kadın-hastalıkları",
  "kalp-damar",
  "kulak-burun-bogaz",
  "ortopedi",
  "plastik-estetik",
  "uroloji"
];
