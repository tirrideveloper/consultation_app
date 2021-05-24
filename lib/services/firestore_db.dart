import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultation_app/models/case_model.dart';
import 'package:consultation_app/models/chats_model.dart';
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
  Future<bool> updateUser(
      String userId, String nameSurname, String aboutUser, String userProfession) async {
    await _firestoreDB
        .collection("users")
        .doc(userId)
        .update({"nameSurname": nameSurname, "aboutUser": aboutUser, "userProfession": userProfession});
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
}
