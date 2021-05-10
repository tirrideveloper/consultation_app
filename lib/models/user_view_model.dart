import 'package:consultation_app/locator.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/repository/user_repository.dart';
import 'package:consultation_app/services/auth_base.dart';
import 'package:flutter/material.dart';

// Uygulamanın durumunu kontrol ediyoruz.
// İşlemlerimiz olurken durum busy oluyor işlem tamamlanınca idle duruma geliyor.
// Bu sayede karmaşıklıkların önüne geçiyoruz.
enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();

  UserModel _userModel;

  UserModel get user => _userModel;

  String emailError;
  String passwordError;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserViewModel() {
    currentUser();
  }

  @override
  Future<UserModel> currentUser() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.currentUser();
      if (_userModel != null)
        return _userModel;
      else
        return null;
    } catch (e) {
      print("VIEW MODEL CURRENT USER ERROR" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInAnon() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.signInAnon();
      return _userModel;
    } catch (e) {
      print("VIEW MODEL SIGN IN ANONYMOUSLY ERROR" + e);
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool result = await _userRepository.signOut();
      _userModel = null;
      return result;
    } catch (e) {
      print("VIEW MODEL SIGN OUT ERROR" + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInGoogle() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.signInGoogle();
      return _userModel;
    } catch (e) {
      print("VIEW MODEL SIGN IN GOOGLE ERROR" + e);
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInFacebook() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.signInFacebook();
      return _userModel;
    } catch (e) {
      print("VIEW MODEL SIGN IN GOOGLE ERROR" + e);
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> createEmailAndPassword(
      String email, String password) async {
    if (_checkValidEmailAndPassword(email, password)) {
      try {
        state = ViewState.Busy;
        _userModel =
            await _userRepository.createEmailAndPassword(email, password);
        return _userModel;
      } finally {
        state = ViewState.Idle;
      }
    } else
      return null;
  }

  @override
  Future<UserModel> signInEmailAndPassword(
      String email, String password) async {
    try {
      if (_checkValidEmailAndPassword(email, password)) {
        state = ViewState.Busy;
        _userModel =
            await _userRepository.signInEmailAndPassword(email, password);
        return _userModel;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<bool> updateUserName(String userId, String userName) async {
    var result = await _userRepository.updateUserName(userId, userName);
    if (result) {
      _userModel.userName = userName;
    }
    return result;
  }

  Future<bool> updateUser(String userId, String nameSurname, String aboutUser) async {
    var result = await _userRepository.updateUser(userId, nameSurname, aboutUser);
    if (result) {
      _userModel.nameSurname = nameSurname;
      _userModel.aboutUser = aboutUser;
    }
    return result;
  }

  bool _checkValidEmailAndPassword(String email, String password) {
    var result = true;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    bool passwordValid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(password);

    if (passwordValid == false) {
      passwordError = "en az 1 küçük harf "
          "1 büyük harf "
          "1 sayı ve 8 karakter olmalı";
      result = false;
    } else
      passwordError = null;
    if (emailValid == false) {
      emailError = "geçerli mail adresi giriniz";
      result = false;
    } else
      emailError = null;
    return result;
  }
}
