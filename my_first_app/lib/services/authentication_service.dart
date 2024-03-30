import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart'  hide User;
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/services/shared_pref_service.dart';
import 'package:my_first_app/ui/common/app_exception_constants.dart';
import 'package:my_first_app/ui/common/firebase_constants.dart';
import '../exception/app_exception.dart';
import '../model/user.dart';

class AuthenticationService {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final _sharedPref = locator<SharedPreferenceService>();

 bool get isLoggedIn => auth.currentUser != null;


  Future<Either<AppException, None>> logout() async{
    try {
      await auth.signOut();
      await _sharedPref.deleteCurrentUser();
      return const Right(None());
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }


  Future<Either<AppException, User>> login(
      {required String email, required String password}) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user == null) {
        return Left(AppException("User not found"));
      }
      final userId = credential.user!.uid;
      final snap = await db.collection("users").doc(userId).get();
      final user = User.fromJson(snap.data()!);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message.toString();
      if (errorMessage == "wrong-password") {
        errorMessage = "The password you entered is wrong!";
      } else if (errorMessage == "user-not-found") {
        errorMessage = "No user found!";
      }

      return Left(AppException(errorMessage));
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }



  Future<Either<AppException, None>> signup(
      String name, String email, String password, String phoneNum) async {
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
        phonenumber: phoneNum,
        uid: credential.user!.uid,
      );

      await db
          .collection(FirebaseConstants.userCollection)
          .doc(credential.user?.uid)
          .set(user.toJson());

      return right(const None());
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message.toString();
      print(errorMessage);
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
}
