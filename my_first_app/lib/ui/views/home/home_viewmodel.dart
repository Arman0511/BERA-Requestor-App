import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_first_app/app/app.bottomsheets.dart';
import 'package:my_first_app/app/app.dialogs.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:my_first_app/model/user.dart';
import 'package:my_first_app/notification_service.dart';
import 'package:my_first_app/services/shared_pref_service.dart';
import 'package:my_first_app/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeViewModel extends BaseViewModel {
  final PageController pageController = PageController(initialPage: 0);
  final _snackbarService = locator<SnackbarService>();
  final _sharedPref = locator<SharedPreferenceService>();
  StreamSubscription<User?>? streamSubscription;

  NotificationService notificationService = NotificationService();
  Position? currentPositionOfUser;
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  // final LocalNotifications _localNotifications = LocalNotifications();
  final _navigationService = locator<NavigationService>();
  int currentPageIndex = 0;

  bool btnMedSelected = false;
  bool btnFireSelected = false;
  bool btnPoliceSelected = false;

  get counterLabel => null;
  late User user;

  init() async {
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
  
Future<void> storeCurrentLocationOfUser() async {
  setBusy(true);

  // Get current position of the user
  Position positionOfUser = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  currentPositionOfUser = positionOfUser;

  // Convert current position to LatLng
  LatLng positionOfUserInLatLang = LatLng(
      currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

  // Get current date and time
  DateTime currentDateTime = DateTime.now();

  // Store the location data in Firestore along with date and time
  await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
    'location': GeoPoint(positionOfUser.latitude, positionOfUser.longitude),
    'timestamp': Timestamp.fromDate(currentDateTime),
  });

  // Animate camera to user's current position
  CameraPosition cameraPosition =
      CameraPosition(target: positionOfUserInLatLang, zoom: 15);
  controllerGoogleMap!
      .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  setBusy(false);
}
  // getCurrentLiveLocationOfUser() async {
  //   Position positionOfUser = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   currentPositionOfUser = positionOfUser;

  //   LatLng positionOfUserInLatLang = LatLng(
  //       currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
  //   CameraPosition cameraPosition =
  //       CameraPosition(target: positionOfUserInLatLang, zoom: 15);
  //   controllerGoogleMap!
  //       .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //   rebuildUi();
  //   print("Created Map");
  // }

  void initState() {
    notificationService.requestNotificationPermission();
  }

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("themes/night_style.json")
        .then((value) => setGoogleMapStyle(value, controller));
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  void mapCreated(GoogleMapController mapController) {
    controllerGoogleMap = mapController;
    googleMapCompleterController.complete(controllerGoogleMap);
    updateMapTheme(controllerGoogleMap!);
    // getCurrentLiveLocationOfUser();
  }

  void goToProfileView() {
    _navigationService.navigateToProfileViewView();
  }

  void onPageChanged(int index) {
    currentPageIndex = index;
    rebuildUi();
    if (index == 1) {
      storeCurrentLocationOfUser();
      if (controllerGoogleMap != null) {
        updateMapTheme(controllerGoogleMap!);
      }
    }
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
