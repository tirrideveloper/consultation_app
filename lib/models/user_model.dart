import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String userId;
  String email;
  String userName;
  String nameSurname;
  String profileURL;
  DateTime createdAt;
  DateTime updatedAt;
  double rank;
  String aboutUser;
  bool verifiedUser;
  String verifyFileURL;
  String userProfession;
  List userCases;
  List userComments;

  UserModel({@required this.userId, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "email": email,
      "userName": userName ??
          email.substring(0, email.indexOf("@")) + createRandomNumber(),
      "nameSurname": nameSurname ?? "",
      "profileURL": profileURL ??
          "https://i.pinimg.com/originals/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.png",
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "updatedAt": updatedAt ?? FieldValue.serverTimestamp(),
      "rank": rank ?? 1.0,
      "aboutUser": aboutUser ?? "",
      "verifiedUser": verifiedUser ?? false,
      "verifyFileURL": verifyFileURL ?? "",
      "userProfession": userProfession ?? "",
      "userCases": userCases ?? [],
      "userComments": userComments ?? [],
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : userId = map["userId"],
        email = map["email"],
        userName = map["userName"],
        nameSurname = map["nameSurname"],
        profileURL = map["profileURL"],
        createdAt = (map["createdAt"] as Timestamp).toDate(),
        updatedAt = (map["updatedAt"] as Timestamp).toDate(),
        rank = map["rank"],
        aboutUser = map["aboutUser"],
        verifiedUser = map["verifiedUser"],
        verifyFileURL = map["verifyFileURL"],
        userProfession = map["userProfession"],
        userCases = map["userCases"],
        userComments = map["userComments"];

  @override
  String toString() {
    return 'UserModel{userId: $userId, email: $email, userName: $userName, nameSurname: $nameSurname ,profileURL: $profileURL, createdAt: $createdAt, updatedAt: $updatedAt, rank: $rank}';
  }

  String createRandomNumber() {
    int randomNumber = Random().nextInt(999999);
    return randomNumber.toString();
  }
}
