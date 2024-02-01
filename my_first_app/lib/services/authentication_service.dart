import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../exception/app_exception.dart';

abstract interface class AuthenticationService {
  Future<Either<AppException, None>> signup(
      String name, String email, String password);
}
