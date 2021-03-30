import 'package:flutter/material.dart';

class UserModel {
  final String userId;

  UserModel({@required this.userId});

  Map<String, dynamic> toMap(){
    return{
      "userId" : userId,
    };
  }
}
