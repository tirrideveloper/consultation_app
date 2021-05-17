import 'package:cloud_firestore/cloud_firestore.dart';

class Chats {
  final String messageSender;
  final String messageReceiver;
  final bool wasSeen;
  final Timestamp creationDate;
  final String lastMessage;
  final Timestamp lastSeenTime;
  String spokenUserName;
  String spokenUserProfileURL;
  DateTime lastReadTime;
  String timeDifference;


  Chats(
      {this.messageSender,
      this.messageReceiver,
      this.wasSeen,
      this.creationDate,
      this.lastMessage,
      this.lastSeenTime});

  Map<String, dynamic> toMap() {
    return {
      "message_sender": messageSender,
      "message_receiver": messageReceiver,
      "was_seen": wasSeen,
      "creation_date": creationDate ?? FieldValue.serverTimestamp(),
      "last_message": lastMessage,
      "last_seen_time": lastSeenTime,
    };
  }

  Chats.fromMap(Map<String, dynamic> map)
      : messageSender = map["message_sender"],
        messageReceiver = map["message_receiver"],
        wasSeen = map["was_seen"],
        creationDate = map["creation_date"],
        lastMessage = map["last_message"],
        lastSeenTime = map["last_seen_time"];

  @override
  String toString() {
    return 'Chats{messageSender: $messageSender, messageReceiver: $messageReceiver, wasSeen: $wasSeen, creationDate: $creationDate, lastMessage: $lastMessage, lastSeenTime: $lastSeenTime}';
  }
}
