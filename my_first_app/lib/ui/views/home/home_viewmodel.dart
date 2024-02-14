import 'package:flutter/material.dart';
import 'package:my_first_app/app/app.bottomsheets.dart';
import 'package:my_first_app/app/app.dialogs.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:my_first_app/notification_service.dart';
import 'package:my_first_app/ui/common/app_strings.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeViewModel extends BaseViewModel {
  final PageController pageController = PageController(initialPage: 0);
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _snackbarService = locator<SnackbarService>();
  NotificationService notificationService = NotificationService();

  // final LocalNotifications _localNotifications = LocalNotifications();
    final _navigationService = locator<NavigationService>();
   int currentPageIndex = 0;

  bool btnMedSelected = false;
  bool btnFireSelected = false;
  bool btnPoliceSelected = false;

  get counterLabel => null;

    
void initState(){
  notificationService.requestNotificationPermission();
}



  void goToProfileView() {
    _navigationService.navigateToProfileViewView();
  }

 void onPageChanged(int index) {
    currentPageIndex = index;
    rebuildUi();
  }

  void onDestinationSelected(int index) {
    currentPageIndex = index;
    changePage(currentPageIndex);
  }

  void changePage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  Future<void> helpPressed() async {
    // LocalNotifications.showSimpleNotification(
    //     title: "Simple Notification",
    //     body: "This is a simple notification",
    //     payload: "This is a simple data");

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
