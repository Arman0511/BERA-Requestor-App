import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/exception/app_exception.dart';
import 'package:my_first_app/services/internet_service.dart';

class ImageService {
  final _storageRef = FirebaseStorage.instance.ref();
  final _internetService = locator<InternetService>();

  Future<Either<AppException, String>> uploadImage(
      File image, String path) async {
    final bool hasInternet = await _internetService.hasInternetConnection();
    if (hasInternet) {
      try {
        final imageProfile = await _storageRef.child(path).putFile(image);
        final imageUrl = await imageProfile.ref.getDownloadURL();
        return Right(imageUrl);
      } catch (e) {
        return Left(AppException(e.toString()));
      }
    } else {
      return Left(AppException("Please check your internet connection!"));
    }
  }
}
