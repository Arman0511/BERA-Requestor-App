import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/app/app.bottomsheets.dart';
import 'package:my_first_app/app/app.dialogs.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:my_first_app/methods/common_methods.dart';
import 'package:my_first_app/model/user.dart';
import 'package:my_first_app/services/authentication_service.dart';
import 'package:my_first_app/services/shared_pref_service.dart';
import 'package:my_first_app/ui/constants/app_png.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

XFile? imageFile;
String urlOfUploadedImage = "";

class ProfileViewViewModel extends BaseViewModel {
  CommonMethods cmethods = CommonMethods();
  final _dialogService = locator<DialogService>();
  final _authService = locator<AuthenticationService>();
  final _bottomSheetServ = locator<BottomSheetService>();
  final _navigationService = locator<NavigationService>();
  final _sharedPref = locator<SharedPreferenceService>();
  StreamSubscription<User?>? streamSubscription;

  late User user;

  ImageProvider getImage() {
    if (user.image == null) return const AssetImage(AppPng.AppAvatarPath);
    return NetworkImage(user.image!);
  }

  void init() async {
    setBusy(true);
    user = (await _sharedPref.getCurrentUser())!;
    streamSubscription?.cancel();
    streamSubscription = _sharedPref.userStream.listen((userData) {
      if (userData != null) {
        user = userData;
        rebuildUi();
      }
    });
    setBusy(false);
  }

  void showUploadPictureDialog() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.updateProfileImage,
    );
  }

  void showUpdateNameDialog() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.updateName,
    );
  }

  void showUpdateNumberDialog() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.updateNumber,
    );
  }

  void showUpdatePasswordDialog() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.updatePassword,
    );
  }

  Future<void> logOut() async {
    setBusy(true);
    final response = await _authService.logout();
    setBusy(false);

    response.fold((l) {
      showBottomSheet(l.message);
    }, (r) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'status': 'offline',
      });
      _navigationService.popRepeated(1);
      _navigationService.replaceWithLoginView();
    });
  }

  void showBottomSheet(String description) {
    _bottomSheetServ.showCustomSheet(
      variant: BottomSheetType.notice,
      title: "Error",
      description: description,
    );
  }

  void showUpdateEmailDialog() async {
    await _dialogService.showCustomDialog(
      variant: DialogType.updateEmail,
    );
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }
}
