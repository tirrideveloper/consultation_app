import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String userId;
  String email;
  String userName;
  String profileURL;
  DateTime createdAt;
  DateTime updatedAt;
  double rank;

  UserModel({@required this.userId, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "email": email,
      "userName": userName ?? "",
      "profileURL": profileURL ??
          "https://visualpharm.com/assets/233/Consultation-595b40b75ba036ed117d5a39.svg",
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "updatedAt": updatedAt ?? FieldValue.serverTimestamp(),
      "rank": rank ?? 1.0,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : userId = map["userId"],
        email = map["email"],
        userName = map["userName"],
        createdAt = (map["createdAt"] as Timestamp).toDate(),
        updatedAt = (map["updatedAt"] as Timestamp).toDate(),
        rank = map["rank"];

  @override
  String toString() {
    return 'UserModel{userId: $userId, email: $email, userName: $userName, profileURL: $profileURL, createdAt: $createdAt, updatedAt: $updatedAt, rank: $rank}';
  }
}
