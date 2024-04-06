import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/app/app.bottomsheets.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/model/user.dart';
import 'package:my_first_app/services/shared_pref_service.dart';
import 'package:my_first_app/services/user_service.dart';
import 'package:my_first_app/ui/constants/app_png.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UpdateProfileImageDialogModel extends BaseViewModel {
  final _sharedPref = locator<SharedPreferenceService>();
  final _userRepo = locator<UserService>();
  final _bottomSheetServ = locator<BottomSheetService>();

  late User user;

  File? image;

  void init() async {
    setBusy(true);
    user = (await _sharedPref.getCurrentUser())!;
    setBusy(false);
  }

  void pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      final imageTemp = File(image.path);
      this.image = imageTemp;
      rebuildUi();
    }
  }

  void uploadImage() async {
    if (image == null) {
      showBottomSheet("Please select a new image to save!");
    } else {
      setBusy(true);
      final response = await _userRepo.uploadProfilePicture(image!);
      setBusy(false);
      response.fold((l) => showBottomSheet(l.message),
          (r) => showBottomSheet("Photo uploaded successfully"));
    }
  }

  void showBottomSheet(String description) {
    _bottomSheetServ.showCustomSheet(
      variant: BottomSheetType.notice,
      description: description,
      title: "Notice",
    );
  }

  ImageProvider getImage() {
    if (image != null) {
      return FileImage(image!);
    } else {
      if (user.image == null) return const AssetImage(AppPng.AppAvatarPath);
      return NetworkImage(user.image!);
    }
  }
}
