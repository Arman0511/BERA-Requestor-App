import 'package:dartz/dartz.dart';

import '../exception/app_exception.dart';
import 'authentication_service.dart';

class AuthenticationServiceMock implements AuthenticationService {
  @override
  Future<Either<AppException, None>> signup(
      String name, String email, String password) {
    // TODO: implement signup
    throw UnimplementedError();
  }
}
