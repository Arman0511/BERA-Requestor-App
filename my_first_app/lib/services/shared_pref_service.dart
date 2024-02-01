import 'package:firebase_auth/firebase_auth.dart';

abstract interface class SharedPrefServiceService {
  Future<void> saveUser(User user);
  Future<User?> getCurrentUser();
  Future<void> deleteUser();

  Future<bool> appIntroGuideValidation();
  Future<void> setAppIntroGuide();
}
