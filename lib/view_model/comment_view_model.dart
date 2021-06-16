import 'package:consultation_app/locator.dart';
import 'package:consultation_app/models/case_model.dart';
import 'package:consultation_app/models/comment_model.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/repository/user_repository.dart';
import 'package:flutter/material.dart';

enum CommentViewState { Idle, Busy }

class CommentViewModel with ChangeNotifier {
  CommentViewState _state = CommentViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();

  final UserModel currentUser;

  CommentViewModel({this.currentUser});

  CommentViewState get state => _state;

  set state(CommentViewState value) {
    _state = value;
    notifyListeners();
  }

  Future<bool> saveComment(
      CommentModel commentModel, CaseModel caseModel, String userId) async {
    return await _userRepository.saveComment(commentModel, caseModel, userId);
  }

  Stream<List<CommentModel>>getComments(CaseModel caseModel) {
    return _userRepository.getComments(caseModel);
  }

  Future<void> deleteComment(String commentId, CaseModel caseModel, String userId) async{
    return await _userRepository.deleteComment(commentId, caseModel, userId);
  }
}
