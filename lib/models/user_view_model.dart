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

  ViewState get state => _state;
  set state(ViewState value){
    _state = value;
    notifyListeners();
  }

  UserViewModel(){
    currentUser();
  }

  @override
  Future<UserModel> currentUser() async{
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
  Future<UserModel> signInAnon() async{
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
  Future<bool> signOut() async{
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
    try{
      state = ViewState.Busy;
      _userModel = await _userRepository.signInGoogle();
      return _userModel;
    }
    catch(e){
      print("VIEW MODEL SIGN IN GOOGLE ERROR" + e);
      return null;
    }
    finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInFacebook() async{
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
}
