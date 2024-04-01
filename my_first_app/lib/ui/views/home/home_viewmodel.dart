import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:my_first_app/model/user.dart';
import 'package:my_first_app/notification_service.dart';
import 'package:my_first_app/services/shared_pref_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';


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
  final Map<MarkerId, Marker> _markers = {};
  Map<MarkerId, Marker> get markers => _markers;
  final double _radius = 1000; // 1 kilometer
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool btnMedSelected = false;
  bool btnFireSelected = false;
  bool btnPoliceSelected = false;

  get counterLabel => null;
  late User user;
  late Connectivity _connectivity;
  late Timer timer;

  // Declare a class-level variable to store the FCM token
  String? nearestFCMToken;
  String? nearestUID;

  BuildContext? context;

  HomeViewModel(this.context);



void sendNotification() async {
  // Check if nearestFCMToken is not null before sending the notification
  if (nearestFCMToken != null) {
    final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
    await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAApeeRKFQ:APA91bG2STzaKtq-pwEZQA6nAdzkbFwGqz80bvaF-wM4I1uQIIDOO8pYKz2kIEyPoJEZW3pn6oHrtARdewwttGkVS18gaf1380kC7LpFltrTNKO2FXCZJ5bPX8Ruq9k0LexXudcjaf9I', // Your FCM server key
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '',
            'title': 'Someone is in distress',
            'android_channel_id': 'your_channel_id', // Required for Android 8.0 and above
            'alert': 'standard', // Set to 'standard' to show a dialog box
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'screen': 'dialog_box', // Screen to open in receiver app
          },
          'to': nearestFCMToken, // Receiver's FCM token
        },
      ),
    );
  } else {
    print('Nearest responder FCM token is null. Cannot send notification.');
  }
}


// void showDialogBox(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text("A Responder Has Received Your Notification"),
//         content: const SingleChildScrollView( // Wrap content with SingleChildScrollView
//           scrollDirection: Axis.horizontal, // Set scroll direction to horizontal
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
              
//               ElevatedButton(
//                 onPressed: () {
      
//                       },
//                 child: const Text("Close"),
//               ),
              
//             ],
//           ),
//         ],
//       );
//     },
//   );
// }

// void getLocationDataAndNotify() {
//   _getLocationDataOf1kmRadius();
//   bool shouldProceed = true;
//   try {
//     _getFcmAndUidOfNearest();
//   } catch (e) {
//     // Catch any exception that might occur during the execution of _getFcmAndUidOfNearest()
//     // and set shouldProceed to false to prevent the notification from being displayed.
//     shouldProceed = false;
//     rethrow;
//   }
//   if (shouldProceed) {
//     showDialogBox(context!);
//   }
// }

// void onNotificationClicked(Map<String, dynamic> data, bool isInForeground) {
//   // Handle notification click here
//   Future.delayed(const Duration(seconds: 2), () {
//     showDialogBox(context!);
    
//   });
// }


Future<void> vibrate() async {
    // Check if the device supports vibration
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator != null && hasVibrator) {
      // Vibrate for 500ms
      Vibration.vibrate(duration: 1000);
    } else {
      // Device doesn't support vibration or it's null
      print('Device does not support vibration');
    }
  }


  init() async {
    setBusy(true);
    user = (await _sharedPref.getCurrentUser())!;
    streamSubscription?.cancel();
    streamSubscription = _sharedPref.userStream.listen((userData) {
      if (userData != null) {
        user = userData;
        rebuildUi();
        storeCurrentLocationOfUser();
      }
    });

    setBusy(false);

//      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

//   // Set foreground notification presentation options
//   FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );

//   // Listen for incoming messages
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     // Handle foreground messages
//     if (message.notification != null) {
//       // Handle notification payload when app is in the foreground
//       onNotificationClicked(message.data, true);
//       vibrate();
//     }
//   });

//   // Listen for notification clicks when app is in the background
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     // Handle notification payload when app is in the background
//     onNotificationClicked(message.data, true);
//     vibrate();
//   });
// }


// Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//   if (message.notification != null) {
//     // Handle notification payload when app is completely closed
//     onNotificationClicked(message.data, true);
//     vibrate();
//   }
  }


Future<void> saveUidToResponder() async {
  try {
    await init(); // Ensure user is initialized

    final userSubUidRef = FirebaseFirestore.instance.collection('responder').doc(nearestUID).collection('userNeededHelp').doc(user.uid);

    await userSubUidRef.set({
      'userId': user.uid,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
    print('UID saved to Firestore successfully!');
  } catch (error) {
    print('Error saving UID to Firestore: $error');
    // Handle error accordingly
  }
}


Future<void> _getLocationDataOf1kmRadius() async {
  setBusy(true);

  // Get the user's current location
  Position positionOfUser = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);

  // Clear any existing markers on the map
  _markers.clear();

  // Fetch the location data from Firebase Firestore
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
      .collection('responder')
      .get();

  if (querySnapshot.docs.isEmpty) {
    print('No location data available');
    return;
  }


  double radiusInMeters = 1000; // 1km in meters

  // Iterate through the location data points, calculating the distance between the user's current location and each location data point
  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
    double latitude = documentSnapshot.data()['latitude'];
    double longitude = documentSnapshot.data()['longitude'];
    double distance = Geolocator.distanceBetween(
        positionOfUser.latitude,
        positionOfUser.longitude,
        latitude,
        longitude);

    // Check if the distance is within the radius (1km)
    if (distance <= radiusInMeters) {
      // Add the responder to the map if it's within the radius
      MarkerId markerId = MarkerId(documentSnapshot.id);
      Marker marker = Marker(
        markerId: markerId,
        position: LatLng(latitude, longitude),
        infoWindow: const InfoWindow(
          title: 'Responder',
        ),
      );
      _markers[markerId] = marker;
    }
  }

  // Print information of responders within 1km radius
  print('Responders within 1km radius:');
  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
    double latitude = documentSnapshot.data()['latitude'];
    double longitude = documentSnapshot.data()['longitude'];
    String name = documentSnapshot.data()['name'];
    double distance = Geolocator.distanceBetween(
        positionOfUser.latitude,
        positionOfUser.longitude,
        latitude,
        longitude);
    if (distance <= radiusInMeters) {
      nearestFCMToken = documentSnapshot.data()['fcmToken']; // Fetching FCM token
      nearestUID = documentSnapshot.data()['uid'];
      // print('Responder ID: ${documentSnapshot.id}');
      // print('Latitude: $latitude');
      // print('Longitude: $longitude');
      print('Name: $name');
      print('UID: $nearestUID');
      print('FCMtoken: $nearestFCMToken');
      // Print other information as needed
    }
  }

  // Print statement to indicate that the process is complete
  print('Location data processing is complete');

  setBusy(false);
}


Future<void> _getLocationDataAndMarkNearest() async {
  setBusy(true);

  // Get the user's current location
  Position positionOfUser = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);

  // Clear any existing markers on the map
  _markers.clear();

  // Fetch the location data from Firebase Firestore
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
      .collection('responder')
      .get();

  if (querySnapshot.docs.isEmpty) {
    print('No location data available');
    return;
  }

  // Initialize variables to store the nearest location and its FCM token
  Map<String, dynamic>? nearestLocation;
  double shortestDistance = _radius;

  // Iterate through the location data points, calculating the distance between the user's current location and each location data point
  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
    double latitude = documentSnapshot.data()['latitude'];
    double longitude = documentSnapshot.data()['longitude'];
    double distance = Geolocator.distanceBetween(
        positionOfUser.latitude,
        positionOfUser.longitude,
        latitude,
        longitude);

    // If the current location data point is closer to the user, replace the nearest location with the current location data point
    if (distance < shortestDistance) {
      shortestDistance = distance;
      nearestLocation = documentSnapshot.data();
      nearestFCMToken = documentSnapshot.data()['fcmToken']; // Fetching FCM token
      nearestUID = documentSnapshot.data()['uid'];
    }
  }

  // If a nearest location is found, add a marker on the map
  if (nearestLocation != null) {
    MarkerId markerId = MarkerId(nearestLocation.toString());
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(nearestLocation['latitude'], nearestLocation['longitude']),
      infoWindow: const InfoWindow(
        title: 'Nearest Responder',
      ),
    );
    _markers[markerId] = marker;

    // Print the FCM token of the nearest responder
    print('FCM token of nearest responder: $nearestFCMToken');
    print('uid of the nearest responder:$nearestUID');

   
  }

  setBusy(false);

  // If the location data processing is unsuccessful, print an error message
  if (nearestLocation == null) {
    print('Error processing location data');
  } else {
    print('Successfully implemented _getLocationDataAndMarkNearest()');
  }

  // Print statement to indicate that the process is complete
  print('Location data processing is complete');

  // Print the location data retrieved
  if (nearestLocation != null) {
    print('Nearest location data: $nearestLocation');
  }
}

Future<void> _getFcmAndUidOfNearest() async {
  setBusy(true);

  // Get the user's current location
  Position positionOfUser = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);

  // Fetch the location data from Firebase Firestore
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
      .collection('responder')
      .get();

  if (querySnapshot.docs.isEmpty) {
    print('No location data available');
    return;
  }

  // Initialize variables to store the nearest location and its FCM token
  Map<String, dynamic>? nearestLocation;
  double shortestDistance = _radius;

  // Iterate through the location data points, calculating the distance between the user's current location and each location data point
  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
    double latitude = documentSnapshot.data()['latitude'];
    double longitude = documentSnapshot.data()['longitude'];
    double distance = Geolocator.distanceBetween(
        positionOfUser.latitude,
        positionOfUser.longitude,
        latitude,
        longitude);

    // If the current location data point is closer to the user, replace the nearest location with the current location data point
    if (distance < shortestDistance) {
      shortestDistance = distance;
      nearestLocation = documentSnapshot.data();
      nearestFCMToken = documentSnapshot.data()['fcmToken']; // Fetching FCM token
      nearestUID = documentSnapshot.data()['uid'];
    }
     // Print the FCM token of the nearest responder
    print('FCM token of nearest responder: $nearestFCMToken');
    print('uid of the nearest responder:$nearestUID');
    sendNotification();
    saveUidToResponder();
  }

  setBusy(false);

  // If the location data processing is unsuccessful, print an error message
  if (nearestLocation == null) {
    print('Error processing location data');
  } else {
    print('Successfully implemented _getLocationDataAndMarkNearest()');
  }

  // Print statement to indicate that the process is complete
  print('Location data processing is complete');

  // Print the location data retrieved
  if (nearestLocation != null) {
    print('Nearest location data: $nearestLocation');
  }
}



UserStatusProvider() {
    user = FirebaseAuth.instance.currentUser! as User;
    _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateUserStatus(result);
    });
  }
  Future<void> _updateUserStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'status': 'offline',
      });
    } else {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'status': 'online',
      });
    }
    }


Future<void> helpPressed() async {
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

  _snackbarService.showSnackbar(
      message: "Rescue Coming!!", duration: const Duration(seconds: 2));

  // Clear the selected concern buttons
  btnMedSelected = false;
  btnFireSelected = false;
  btnPoliceSelected = false;
  rebuildUi();
  // getLocationDataAndNotify();
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

Future<void> saveConcernsToFirestore(List<String> selectedConcerns) async {
  try {
    await init(); // Ensure user is initialized

    final userConcernRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Get the current document snapshot to preserve other fields
    final snapshot = await userConcernRef.get();

    // Get the current data to preserve other fields
    Map<String, dynamic>? userData = snapshot.data();

    // Update the 'concerns' field
    userData?['concerns'] = selectedConcerns.isNotEmpty ? selectedConcerns : FieldValue.delete();

    // Update the document with the modified data
    await userConcernRef.set(userData!);

    print('Concerns saved to Firestore successfully!');
  } catch (error) {
    print('Error saving concerns to Firestore: $error');
    // Handle error accordingly
  }
}








Future<void> storeCurrentLocationOfUser() async {
  setBusy(true);

  // Get current position of the user
  Position positionOfUser = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  currentPositionOfUser = positionOfUser;

  // Get current date and time
  DateTime currentDateTime = DateTime.now();

  // Store the location data in Firestore along with date and time
  await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
    'latitude': positionOfUser.latitude,
    'longitude': positionOfUser.longitude,
    'timestamp': Timestamp.fromDate(currentDateTime),
  });

  // Animate camera to user's current position
  LatLng positionOfUserInLatLang = LatLng(
      currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
  CameraPosition cameraPosition =
      CameraPosition(target: positionOfUserInLatLang, zoom: 15);
  controllerGoogleMap!
      .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  setBusy(false);
}

  void initState() {
    notificationService.requestNotificationPermission();
    UserStatusProvider();
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
  timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => storeCurrentLocationOfUser());
  _getLocationDataOf1kmRadius();
}

  void goToProfileView() {
    _navigationService.navigateToProfileViewView();
  }

  void onPageChanged(int index) {
    currentPageIndex = index;
    rebuildUi();
    if (index == 1) {
      // _getLocationDataAndMarkNearest();
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

 @override
void dispose() {
  timer.cancel();
  streamSubscription?.cancel();
  super.dispose();
}

 

  void incrementCounter() {}

  void showBottomSheet() {}
}
