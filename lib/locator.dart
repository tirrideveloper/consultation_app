import 'package:consultation_app/repository/user_repository.dart';
import 'package:consultation_app/services/fake_auth.dart';
import 'package:consultation_app/services/firebase_auth.dart';
import 'package:consultation_app/services/firebase_storage.dart';
import 'package:consultation_app/services/firestore_db.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => FireStoreDbService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirebaseStorageService());
}
