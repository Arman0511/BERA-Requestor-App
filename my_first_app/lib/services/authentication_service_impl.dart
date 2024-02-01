import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/model/user.dart';
import 'package:my_first_app/services/authentication_service.dart';
import 'package:my_first_app/services/shared_pref_service.dart';
import '../exception/app_exception.dart';
import '../ui/common/app_exception_constants.dart';

import '../ui/common/firebase_constants.dart';

class AuthenticationServiceImpl implements AuthenticationService {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  Future<Either<AppException, None>> signup(
      String name, String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return left(AppException(AppExceptionConstants.userNotFound));
      }

      User user = User(
        name: name,
        email: email,
        uid: credential.user!.uid,
      );

      await db
          .collection(FirebaseConstants.userCollection)
          .doc(credential.user?.uid)
          .set(user.toJson());

      return right(const None());
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message.toString();
      if (e.code == 'weak-password') {
        errorMessage = AppExceptionConstants.passwordIsWeak;
      } else if (e.code == 'email-already-in-use') {
        errorMessage = AppExceptionConstants.accountAlreadyExists;
      }
      return left(AppException(errorMessage));
    } catch (error) {
      return left(AppException(error.toString()));
    }
  }

  @override
  bool get isLoggedIn => auth.currentUser != null;
}
