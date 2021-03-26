import 'package:consultation_app/models/user_model.dart';
import 'package:consultation_app/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel _firebaseUser(User user) {
    if (user == null) {
      return null;
    }
    return UserModel(userId: user.uid);
  }

  @override
  Future<UserModel> currentUser() async {
    try {
      User user = _firebaseAuth.currentUser;
      return _firebaseUser(user);
    } catch (e) {
      print("ERROR CURRENT USER " + e.toString());
      return null;
    }
  }

  @override
  Future<UserModel> signInAnon() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return _firebaseUser(userCredential.user);
    } catch (e) {
      print("ERROR ANONYMOUSLY AUTH" + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();

      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("ERROR SIGN OUT" + e.toString());
      return false;
    }
  }

  @override
  Future<UserModel> signInGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        return _firebaseUser(userCredential.user);
      }

      /*on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // aynı maille zaten hesap var
          // facebook google gibi hesapları birbirine bağlamak için
          // linkWithCredential var ama güvenlik açığı oluşturuyor.
        }
        else if (e.code == 'invalid-credential') {
          // hatalı veya eksik bilgi
        }
      }*/

      catch (e) {
        print("USER CREDENTIAL ERROR" + e.toString());
        return null;
      }
    } else {
      print("GOOGLE SIGN IN ACCOUNT LINE ERROR");
      return null;
    }
  }

  //Yalnızca test kullanıcıları giriş yapabiliyor.(Facebook dev üzerinden ayarlanıyor)
  @override
  Future<UserModel> signInFacebook() async {
    final FacebookLogin facebookSignIn = FacebookLogin();

    final FacebookLoginResult _result =
        await facebookSignIn.logIn(['email', 'public_profile']);

    switch (_result.status) {
      case FacebookLoginStatus.loggedIn:
        if (_result.accessToken != null && _result.accessToken.isValid()) {
          final FacebookAccessToken accessToken = _result.accessToken;
          UserCredential _firebaseResult =
              await _firebaseAuth.signInWithCredential(
                  FacebookAuthProvider.credential(accessToken.token));
          User _user = _firebaseResult.user;
          return _firebaseUser(_user);
        }
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("FACEBOOK CANCELLED BY USER" + _result.errorMessage);
        break;

      case FacebookLoginStatus.error:
        print("FACEBOOK LOGIN STATUS ERROR" + _result.errorMessage);
        break;
    }
    return null;
  }
}
