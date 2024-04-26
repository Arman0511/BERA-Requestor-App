import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_first_app/app/app.dialogs.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:my_first_app/model/no_acc.dart';
import 'package:my_first_app/services/shared_pref_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;

class NoAccountPageViewModel extends BaseViewModel {
  final _snackbarService = locator<SnackbarService>();
  final _sharedPref = locator<SharedPreferenceService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  bool btnMedSelected = false;
  bool btnFireSelected = false;
  bool btnPoliceSelected = false;

  Position? currentPositionOfUser;
  final double _radius = 1000; // 1 kilometer
  String? nearestFCMToken;
  String? nearestUID;
  String? phoneNum;

  late NoAcc? user;

  StreamSubscription<NoAcc?>? streamSubscription;

  final StreamController<Position> _positionStreamController =
      StreamController<Position>();

  Future<void> helpPressed() async {
    await init();

    List<String> selectedConcerns = [];

    if (btnFireSelected) {
      selectedConcerns.add('Fire');
    }
    if (btnMedSelected) {
      selectedConcerns.add('Medical');
    }
    if (btnPoliceSelected) {
      selectedConcerns.add('Police');
    }

    if (selectedConcerns.isEmpty) {
      _snackbarService.showSnackbar(
          message: "Select Emergency Concern!",
          duration: const Duration(seconds: 1));
      return;
    }

    await saveConcernsToFirestore(selectedConcerns);
    storeCurrentLocationOfUser();

    _snackbarService.showSnackbar(
        message: "Rescue Coming!!", duration: const Duration(seconds: 2));

    btnMedSelected = false;
    btnFireSelected = false;
    btnPoliceSelected = false;
    rebuildUi();
    _getFcmAndUidOfNearest();
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

  Future<void> _getFcmAndUidOfNearest() async {
    setBusy(true);

    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('responder').get();

    if (querySnapshot.docs.isEmpty) {
      print('No location data available');
      return;
    }

    Map<String, dynamic>? nearestLocation;
    double shortestDistance = _radius;

    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      double latitude = documentSnapshot.data()['latitude'];
      double longitude = documentSnapshot.data()['longitude'];
      double distance = Geolocator.distanceBetween(positionOfUser.latitude,
          positionOfUser.longitude, latitude, longitude);

      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestLocation = documentSnapshot.data();
        nearestFCMToken = documentSnapshot.data()['fcmToken'];
        nearestUID = documentSnapshot.data()['uid'];
      }
      print('FCM token of nearest responder: $nearestFCMToken');
      print('uid of the nearest responder:$nearestUID');
      sendNotification();
      saveUidToResponder();
    }

    setBusy(false);

    if (nearestLocation == null) {
      print('Error processing location data');
    } else {
      print('Successfully implemented _getLocationDataAndMarkNearest()');
    }

    print('Location data processing is complete');

    if (nearestLocation != null) {
      print('Nearest location data: $nearestLocation');
    }
  }

  Future<void> saveUidToResponder() async {
    try {
      final userSubUidRef = FirebaseFirestore.instance
          .collection('responder')
          .doc(nearestUID)
          .collection('userNeededHelp')
          .doc(user!.uid);

      await userSubUidRef.set({
        'userId': user!.uid,
        'timestamp': Timestamp.fromDate(DateTime.now()),
      });
      print('UID saved to Firestore successfully!');
    } catch (error) {
      print('Error saving UID to Firestore: $error');
    }
  }

  void sendNotification() async {
    if (nearestFCMToken != null) {
      final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
      await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAApeeRKFQ:APA91bG2STzaKtq-pwEZQA6nAdzkbFwGqz80bvaF-wM4I1uQIIDOO8pYKz2kIEyPoJEZW3pn6oHrtARdewwttGkVS18gaf1380kC7LpFltrTNKO2FXCZJ5bPX8Ruq9k0LexXudcjaf9I', // Your FCM server key
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '',
              'title': 'Someone is in distress',
              'android_channel_id':
                  'your_channel_id', // Required for Android 8.0 and above
              'alert': 'standard', // Set to 'standard' to show a dialog box
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'screen': 'dialog_box', // Screen to open in receiver app
            },
            'to': nearestFCMToken,
          },
        ),
      );
    } else {
      print('Nearest responder FCM token is null. Cannot send notification.');
    }
  }

  Future<void> saveConcernsToFirestore(List<String> selectedConcerns) async {
    try {
      await init(); // Ensure user is initialized

      final userConcernRef =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);

      final snapshot = await userConcernRef.get();

      Map<String, dynamic>? userData = snapshot.data();

      userData?['concerns'] =
          selectedConcerns.isNotEmpty ? selectedConcerns : FieldValue.delete();

      await userConcernRef.set(userData!);

      print('Concerns saved to Firestore successfully!');
    } catch (error) {
      print('Error saving concerns to Firestore: $error');
    }
  }

  init() async {
    user = (await _sharedPref.getCurrentNoAcc());
    if (user != null) {
      await _dialogService.showCustomDialog(
        variant: DialogType.inputNumber,
      );

      storeCurrentLocationOfUser();
      startLocationUpdates();
    }
  }

  void goToLogin() {
    _navigationService.navigateToLoginView();
  }

  void goToSignUp() {
    _navigationService.navigateToUserSignUpView();
  }

  void startLocationUpdates() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _positionStreamController.add(position);
    });
  }

  Future<void> storeCurrentLocationOfUser() async {
    setBusy(true);

    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser = positionOfUser;

    DateTime currentDateTime = DateTime.now();

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'latitude': positionOfUser.latitude,
      'longitude': positionOfUser.longitude,
      'timestamp': Timestamp.fromDate(currentDateTime),
    });

    setBusy(false);
  }
}
