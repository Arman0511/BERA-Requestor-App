import 'package:flutter/cupertino.dart';
import 'package:my_first_app/app/app.bottomsheets.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/services/shared_pref_service.dart';
import 'package:my_first_app/services/user_service.dart';
import 'package:my_first_app/ui/common/input_validation.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UpdateNumberDialogModel extends BaseViewModel with InputValidation {
  final _userRepo = locator<UserService>();
  final _bottomSheetServ = locator<BottomSheetService>();
  final _sharedPref = locator<SharedPreferenceService>();

  TextEditingController numberTextController = TextEditingController();

  void init() async {
    setBusy(true);
    final user = await _sharedPref.getCurrentUser();
    numberTextController.text = user!.name;
    setBusy(false);
  }

  Future<void> updateNumber() async {
    String? numberValidation = isValidInput(numberTextController.text, "number");
    if (numberValidation == null) {
      setBusy(true);
      final response = await _userRepo.updateName(numberTextController.text);
      response.fold(
        (l) => showBottomSheet(l.message),
        (r) => showBottomSheet("Name updated successfully"),
      );
      setBusy(false);
    } else {
      showBottomSheet(numberValidation);
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
