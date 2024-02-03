import 'package:my_first_app/app/app.bottomsheets.dart';
import 'package:my_first_app/app/app.dialogs.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/notification_service.dart';
import 'package:my_first_app/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _snackbarService = locator<SnackbarService>();
  final LocalNotifications _localNotifications = LocalNotifications();

  bool btnMedSelected = false;
  bool btnFireSelected = false;
  bool btnPoliceSelected = false;

  get counterLabel => null;

  Future<void> helpPressed() async {
   
     LocalNotifications.showSimpleNotification(title: "Simple Notification",
      body: "This is a simple notification",
      payload: "This is a simple data");
      
    if (btnFireSelected == false &&
        btnMedSelected == false &&
        btnPoliceSelected == false) {
      _snackbarService.showSnackbar(
          message: "Select Emergency Concern!",
          duration: const Duration(seconds: 1));
      return;
    }

    _snackbarService.showSnackbar(
        message: "Rescue Coming!!", duration: const Duration(seconds: 2));
    btnMedSelected = false;
    btnFireSelected = false;
    btnPoliceSelected = false;
    rebuildUi();
  }
   

  void medPressed() {
    btnMedSelected = !btnMedSelected;
    rebuildUi();
  }

  void firePressed() {
    btnFireSelected = !btnFireSelected;
    rebuildUi();
  }

  void policePressed() {
    btnPoliceSelected = !btnPoliceSelected;
    rebuildUi();
  }

  void incrementCounter() {}

  void showBottomSheet() {}
}
