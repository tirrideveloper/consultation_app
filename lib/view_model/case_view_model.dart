import 'dart:io';

import 'package:consultation_app/locator.dart';
import 'package:consultation_app/models/case_model.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/repository/user_repository.dart';
import 'package:flutter/material.dart';

enum CaseViewState { Idle, Busy }

class CaseViewModel with ChangeNotifier {
  CaseViewState _state = CaseViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();

  final UserModel currentUser;

  CaseViewModel({this.currentUser});

  CaseViewState get state => _state;

  set state(CaseViewState value) {
    _state = value;
    notifyListeners();
  }

  Future<bool> saveCase(CaseModel caseModel) async {
    return await _userRepository.saveCase(caseModel);
  }

  Future<String> uploadCasePhoto(
      String caseId, String fileName, File casePhoto) async {
    var result =
        await _userRepository.uploadCasePhotos(caseId, fileName, casePhoto);
    return result;
  }

  Future<bool> updateUserCases(String userId, String newCaseId) async {
    return await _userRepository.updateUserCases(userId, newCaseId);
  }

  Future<List<CaseModel>> getTagSearchedCases(String tag) async {
    List<CaseModel> searchedList =
    await _userRepository.getTagSearchedCases(tag);
    return searchedList;
  }
}
