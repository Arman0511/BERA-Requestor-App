import 'package:flutter/cupertino.dart';
import 'package:my_first_app/ui/common/input_validation.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.bottomsheets.dart';
import '../../../app/app.locator.dart';
import '../../../services/authentication_service.dart';

class UpdatePasswordDialogModel extends BaseViewModel with InputValidation {
  final _bottomSheetServ = locator<BottomSheetService>();
  final _authServ = locator<AuthenticationService>();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Future<void> changePassword() async {
    String? currentPassValidation =
        isValidPassword(currentPasswordController.text);
    String? newPassValidation = isValidPassword(newPasswordController.text);
    if (currentPassValidation == null) {
      if (newPassValidation == null) {
        setBusy(true);
        final response = await _authServ.updatePassword(
          currentPassword: currentPasswordController.text,
          newPassword: newPasswordController.text,
        );
        response.fold(
          (l) => showBottomSheet(l.message),
          (r) => showBottomSheet("Password changed successfully"),
        );
        setBusy(false);
      } else {
        showBottomSheet(newPassValidation);
      }
    } else {
      showBottomSheet(currentPassValidation);
    }
  }

  void showBottomSheet(String description) {
    _bottomSheetServ.showCustomSheet(
      variant: BottomSheetType.notice,
      title: "Notice",
      description: description,
    );
  }
}
