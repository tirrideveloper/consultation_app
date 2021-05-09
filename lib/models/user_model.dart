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

  UserModel({@required this.userId, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "email": email,
      "userName": userName ??
          email.substring(0, email.indexOf("@")) + createRandomNumber(),
      "nameSurname": "İsminizi Giriniz",
      "profileURL": profileURL ??
          "https://visualpharm.com/assets/233/Consultation-595b40b75ba036ed117d5a39.svg",
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "updatedAt": updatedAt ?? FieldValue.serverTimestamp(),
      "rank": rank ?? 1.0,
      "aboutUser": aboutUser ?? "null"
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
        aboutUser = map["aboutUser"];

  @override
  String toString() {
    return 'UserModel{userId: $userId, email: $email, userName: $userName, nameSurname: $nameSurname ,profileURL: $profileURL, createdAt: $createdAt, updatedAt: $updatedAt, rank: $rank}';
  }

  String createRandomNumber() {
    int randomNumber = Random().nextInt(999999);
    return randomNumber.toString();
  }
}
