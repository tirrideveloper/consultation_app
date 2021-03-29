import 'package:consultation_app/locator.dart';
import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/services/auth_base.dart';
import 'package:consultation_app/services/fake_auth.dart';
import 'package:consultation_app/services/firebase_auth.dart';

// bu sınıf uygulamayı test etmeye yardımcı olacak
enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();

  //Release yapılırsa gerçek firebase girişleri yapılacak
  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      return await _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<UserModel> signInAnon() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnon();
    } else {
      return await _firebaseAuthService.signInAnon();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel> signInGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInGoogle();
    } else {
      return await _firebaseAuthService.signInGoogle();
    }
  }

  @override
  Future<UserModel> signInFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInFacebook();
    } else {
      return await _firebaseAuthService.signInFacebook();
    }
  }
}