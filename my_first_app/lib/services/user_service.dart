import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/exception/app_exception.dart';
import 'package:my_first_app/model/user.dart';
import 'package:my_first_app/services/authentication_service.dart';
import 'package:my_first_app/services/image_service.dart';
import 'package:my_first_app/services/internet_service.dart';
import 'package:my_first_app/services/shared_pref_service.dart';

class UserService {
  final _internetService = locator<InternetService>();
  final _db = FirebaseFirestore.instance;
  final _sharedPref = locator<SharedPreferenceService>();
  final _authServ = locator<AuthenticationService>();
  final _imageService = locator<ImageService>();

  Future<Either<AppException, None>> updateName(String name) async {
    final bool hasInternet = await _internetService.hasInternetConnection();
    if (hasInternet) {
      User? user = await _sharedPref.getCurrentUser();
      try {
        await _db
            .collection("users")
            .doc(user!.uid)
            .set({"name": name}, SetOptions(merge: true));
        _authServ.getCurrentUser();
        return const Right(None());
      } catch (e) {
        return Left(AppException(e.toString()));
      }
    } else {
      return Left(AppException("Please check your internet connection!"));
    }
  } Future<Either<AppException, None>> updateNumber(String number) async {
    final bool hasInternet = await _internetService.hasInternetConnection();
    if (hasInternet) {
      User? user = await _sharedPref.getCurrentUser();
      try {
        await _db
            .collection("users")
            .doc(user!.uid)
            .set({"phonenumber": number}, SetOptions(merge: true));
        _authServ.getCurrentUser();
        return const Right(None());
      } catch (e) {
        return Left(AppException(e.toString()));
      }
    } else {
      return Left(AppException("Please check your internet connection!"));
    }
  }

  Future<Either<AppException, None>> uploadProfilePicture(
      File imageFile) async {
    final bool hasInternet = await _internetService.hasInternetConnection();
    if (hasInternet) {
      User? user = await _sharedPref.getCurrentUser();
      String path = "Images/${user!.uid}.png";
      try {
        final response = await _imageService.uploadImage(imageFile, path);
        return response.fold(
          (l) => Left(AppException(l.message)),
          (imageUrl) async {
            try {
              await _db
                  .collection("users")
                  .doc(user.uid)
                  .set({"image": imageUrl}, SetOptions(merge: true));
              await _authServ.getCurrentUser();
              return const Right(None());
            } catch (e) {
              return Left(AppException(e.toString()));
            }
          },
        );
      } catch (e) {
        return Left(AppException(e.toString()));
      }
    } else {
      return Left(AppException("Please check your internet connection!"));
    }
  }
}
