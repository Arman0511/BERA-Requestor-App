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




void sendNotification() async {
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
          'body': 'Your message here',
          'title': 'Notification Title'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'screen': 'homepage', // Screen to open in receiver app
        },
        'to': 'eDU_uALBTqWOBdVCZp8sYR:APA91bGQw570nS_ORwMLwuhUgxuaelszOVEZ4Azv6WiGZvMovztCqP-m_jeQu0Qrt-TVWBl6ZtC6zA4SZNDcL_IyMui8nai_UvY6KWvyESfyw_KKD1t3Zr-cnllTMMOSZSu6vnDTXV4U', // Receiver's FCM token
      },
    ),
  );
}




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

  // Initialize the variable to store the nearest location
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
    }
  }

  // If a nearest location is found, add a marker on the map
  if (nearestLocation != null) {
    MarkerId markerId = MarkerId(nearestLocation.toString());
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(nearestLocation['latitude'], nearestLocation['longitude']),
      infoWindow: InfoWindow(
        title: 'Nearest Responder',
      ),
    );
    _markers[markerId] = marker;
  }

  setBusy(false);

  // If the location data processing is unsuccessful, print an error message
  if (nearestLocation == null) {
    print('Error processing location data');
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

    Future<void> printInstallationId() async {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // Request permission for receiving notifications (optional)
  await firebaseMessaging.requestPermission();

  // Get the installation ID
  String? installationId = await firebaseMessaging.getToken();

  // Print the installation ID
  print('Installation ID: $installationId');
}
  
// Future<void> sendNotificationToResponder(String title, String message,
//     String fcmToken, String installationId) async {
//   // Define the URL within the function
//   String url = 'https://fcm.googleapis.com/fcm/send';

//   // Add the `fcmToken` parameter to the function signature
//   // Replace the `Authorization` header with your own FCM server key
//   final Map<String, String> headers = {
//     'Content-Type': 'application/json',
//     'Authorization':
//         'key=AAAApeeRKFQ:APA91bG2STzaKtq-pwEZQA6nAdzkbFwGqz80bvaF-wM4I1uQIIDOO8pYKz2kIEyPoJEZW3pn6oHrtARdewwttGkVS18gaf1380kC7LpFltrTNKO2FXCZJ5bPX8Ruq9k0LexXudcjaf9I',
//   };

//   // Add the `to` field to the body of the request
//   // Replace the `title` and `body` fields with your own values
//   final Map<String, dynamic> requestBody = {
//     'to': fcmToken,
//     'notification': {
//       'title': title,
//       'body': message,
//       'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//       'icon': 'fcm_push_icon',
//     },
//     'data': {
//       'location': 'Sendeu',
//       'description': 'Helping hand needed!',
//       'installation_id': installationId, // Adding installation ID to data payload
//     },
//     'apns': {
//       'payload': {
//         'aps': {
//           'content-available': '1',
//         },
//       },
//     },
//     'android': {
//       'notification': {
//         'priority': 'high',
//       },
//       'data': {
//         'location': 'Sendeu',
//         'description': 'Helping hand needed!',
//         'installation_id': installationId, // Adding installation ID to data payload
//       },
//     },
//   };

//   // Send the request using the `sendFcmNotification()` function
//   // Replace the `token` parameter with the `fcmToken` parameter
//   final http.Client httpClient = http.Client();
//   final http.Response response = await httpClient.post(
//     Uri.parse(url),
//     headers: headers,
//     body: json.encode(requestBody),
//   );

//   if (response.statusCode != 200) {
//     throw Exception('Failed to send FCM notification: ${response.statusCode}');
//   }

//   httpClient.close();
// }

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
  sendNotification();
  printInstallationId();
  



 try {
    // String userToken = 'e8Gr92ZHQI2Dd0wX5Ik-3F:APA91bFaXl0dE03Im32L-4NCdSqe0-CaWQM7X0u_mTYSug3F8_yrNDPAg9wLxYPXVNMIzSr5IrYe7-bfuh0P013hI19mRpuxiIRizks5ZjG8y1-uOqZzM27wEZPOszZ0ScZESQ_-qrc9';
    // String message = 'Naay Nangayo ug Tabang!!!';
    // String installationId = 'e8Gr92ZHQI2Dd0wX5Ik-3F'; // Replace with actual installation ID

    // await sendNotificationToResponder(message, message, userToken, installationId);

    // print('FCM notification sent successfully!');

  } catch (error) {
    // print('Error sending FCM notification: $error');
    // Handle error accordingly
  }
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

Future<void> saveConcernsToFirestore(List<String> concerns) async {
  try {
    await init(); // Ensure user is initialized

    final userConcernRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Update the 'concerns' field with the selected concerns without overwriting other fields
    await userConcernRef.update({'concerns': FieldValue.arrayUnion(concerns)});
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
  storeCurrentLocationOfUser();
  timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => storeCurrentLocationOfUser());
  _getLocationDataAndMarkNearest();
}

  void goToProfileView() {
    _navigationService.navigateToProfileViewView();
  }

  void onPageChanged(int index) {
    currentPageIndex = index;
    rebuildUi();
    if (index == 1) {
      _getLocationDataAndMarkNearest();
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
