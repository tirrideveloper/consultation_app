import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sender;
  final String receiver;
  final bool isFromCurrentUser;
  final String message;
  final Timestamp date;

  Message(
      {this.sender,
      this.receiver,
      this.isFromCurrentUser,
      this.message,
      this.date});

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "receiver": receiver,
      "isFromCurrentUser": isFromCurrentUser,
      "message": message,
      "date": date ?? FieldValue.serverTimestamp(),
    };
  }

  Message.fromMap(Map<String, dynamic> map)
      : sender = map["sender"],
        receiver = map["receiver"],
        isFromCurrentUser = map["isFromCurrentUser"],
        message = map["message"],
        date = map["date"];

  @override
  String toString() {
    return 'Message{sender: $sender, receiver: $receiver, isFromCurrentUser: $isFromCurrentUser, message: $message, date: $date}';
  }
}
