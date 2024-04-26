import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:my_first_app/model/user.dart';
import 'package:my_first_app/notification_service.dart';
import 'package:my_first_app/services/shared_pref_service.dart';
import 'package:my_first_app/ui/constants/app_png.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class HomeViewModel extends BaseViewModel {
  final PageController pageController = PageController(initialPage: 0);
  final _snackbarService = locator<SnackbarService>();
  final _sharedPref = locator<SharedPreferenceService>();
  StreamSubscription<User?>? streamSubscription;
  final describeTextController = TextEditingController();

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
  final StreamController<Position> _positionStreamController =
      StreamController<Position>();
  Stream<Position> get positionStream => _positionStreamController.stream;
  bool isUploading = false;
double uploadProgress = 0.0;

  bool btnMedSelected = false;
  bool btnFireSelected = false;
  bool btnPoliceSelected = false;

  get counterLabel => null;
  late User user;
  late Connectivity _connectivity;
  late Timer timer;
  late File _capturedImage;

  // Declare a class-level variable to store the FCM token
  String? nearestFCMToken;
  String? nearestUID;
  String? adminUid;
  bool isPhotoAdded = false;


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
            'to': nearestFCMToken, // Receiver's FCM token
          },
        ),
      );
    } else {
      print('Nearest responder FCM token is null. Cannot send notification.');
    }
  }


  Future<void> sendNotificationAdmin() async {
  // Get a reference to the admin collection
  CollectionReference adminCollection =
      FirebaseFirestore.instance.collection('admin');

  // Query for documents in the admin collection
  QuerySnapshot adminSnapshot = await adminCollection.get();

  // Iterate through each document in the collection
  adminSnapshot.docs.forEach((adminDocument) async {
    // Extract the 'fcmToken' field from the document data
    var data = adminDocument.data() as Map<String, dynamic>;
    if (data.containsKey('fcmToken')) {
      String fcmToken = data['fcmToken'];

      // Check if FCM token is not null before sending the notification
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
              'android_channel_id': 'your_channel_id', // Required for Android 8.0 and above
              'alert': 'standard', // Set to 'standard' to show a dialog box
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'screen': 'dialog_box', // Screen to open in receiver app
            },
            'to': fcmToken, // Receiver's FCM token
          },
        ),
      );
        }
  });
}
 void showDescribeDialog() {
  // Check if any of the options are selected
  if (btnFireSelected || btnMedSelected || btnPoliceSelected) {
    showDialogWithTextInput(context!);
  } else {
    _snackbarService.showSnackbar(
      message: "Select at least one emergency concern!",
      duration: const Duration(seconds: 1),
    );
  }
}


 Future<void> saveSituationField(String text) async {
FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).set({
                'situation': describeTextController.text,
              }, SetOptions(merge: true));
            await helpPressed();
}

Future<void> saveConcernPhoto(_capturedImage) async {
  // Get a reference to the users collection
  final usersCollection = FirebaseFirestore.instance.collection('users');

  // Get the current user's document
  final userDoc = usersCollection.doc(FirebaseAuth.instance.currentUser?.uid);

  // Save the image to Firebase Storage
  final storageRef = FirebaseStorage.instance.ref().child('concernPhotos/${userDoc.id}');
  final uploadTask = storageRef.putFile(_capturedImage);
  final snapshot = await uploadTask.whenComplete(() {});
  final downloadUrl = await snapshot.ref.getDownloadURL();

  // Save the image's download URL to the user's document
  await userDoc.set({
    'situationPhoto': downloadUrl,
  }, SetOptions(merge: true));
}



void showDialogWithTextInput(BuildContext context) {
  // Show the dialog box
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Describe The Situation'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: describeTextController,
                  decoration: InputDecoration(hintText: 'Type here'),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
  onPressed: () async {
    // Set loading state to true
    setState(() {
      isUploading = true;
    });

    // Call the camera app and get the captured image
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile != null) {
      // Display the captured image in the dialog box
      setState(() {
        _capturedImage = File(pickedFile.path);
      });

      // Save the image to the user's document
      await saveConcernPhoto(_capturedImage);

      // Change the icon color to green
      setState(() {
        isPhotoAdded = true;
      });
    }

    // Set loading state to false after uploading is finished
    setState(() {
      isUploading = false;
    });
  },
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.black,
    backgroundColor: Colors.grey[300],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  child: Stack(
    alignment: Alignment.center,
    children: [
      Icon(
        Icons.camera,
        color: isPhotoAdded ? Colors.green : Colors.black,
      ),
      if (isUploading)
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
    ],
  ),
),

                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Call the saveSituationField method and pass the text from the controller
                  saveSituationField(describeTextController.text);
                  Navigator.of(context).pop();
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      );
    },
  );
}



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
      }
    });
    storeCurrentLocationOfUser();
    setBusy(false);
  }

  Future<void> saveUidToResponder() async {
    try {
      await init(); // Ensure user is initialized

      final userSubUidRef = FirebaseFirestore.instance
          .collection('responder')
          .doc(nearestUID)
          .collection('userNeededHelp')
          .doc(user.uid);

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

  Future<void> executeGetAndSaveUid() async {
    try {
      // Get admin UID
      String? adminUid = await getAdminUid();

      // Check if admin UID is not null
      if (adminUid != null) {
        // Save UID to admin
        await saveUidToAdmin(adminUid);
        await saveNearestResponderId(adminUid);
      } else {
        print('Admin UID not found or collection is empty.');
        // Handle case where admin UID is not found
      }
    } catch (error) {
      print('Error executing getAdminUid and saveUidToAdmin: $error');
      // Handle error accordingly
    }
  }

  Future<String?> getAdminUid() async {
    // Get a reference to the admin collection
    CollectionReference adminCollection =
        FirebaseFirestore.instance.collection('admin');

    // Query for documents in the admin collection
    QuerySnapshot adminSnapshot = await adminCollection.get();

    // Check if there are any documents in the collection
    if (adminSnapshot.docs.isNotEmpty) {
      // Get the first document in the collection
      var adminDocument = adminSnapshot.docs.first;

      // Extract the 'uid' field from the document data
      var data = adminDocument.data() as Map<String, dynamic>;
      if (data.containsKey('uid')) {
        adminUid = data['uid'];
        return adminUid;
      }
    }

    // If there are no documents in the collection or uid is not found, return null
    return null;
  }

  Future<void> saveUidToAdmin(String adminUid) async {
    try {
      await init(); // Ensure user is initialized

      final userSubUidRef = FirebaseFirestore.instance
          .collection('admin')
          .doc(adminUid)
          .collection('userNeededHelp')
          .doc(user.uid);

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

  Future<void> saveNearestResponderId(String adminUid) async {
    try {
      await init(); // Ensure user is initialized

      final userSubUidRef = FirebaseFirestore.instance
          .collection('admin')
          .doc(adminUid)
          .collection('nearestResponder')
          .doc(nearestUID);

      await userSubUidRef.set({
        'userId': nearestUID,
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
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('responder').get();

    if (querySnapshot.docs.isEmpty) {
      print('No location data available');
      return;
    }

    double radiusInMeters = 1000; // 1km in meters

    // Iterate through the location data points, calculating the distance between the user's current location and each location data point
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      double latitude = documentSnapshot.data()['latitude'];
      double longitude = documentSnapshot.data()['longitude'];
      String name = documentSnapshot.data()['name'];
      double distance = Geolocator.distanceBetween(positionOfUser.latitude,
          positionOfUser.longitude, latitude, longitude);

      // Check if the distance is within the radius (1km)
      if (distance <= radiusInMeters) {
        // Add the responder to the map if it's within the radius
        MarkerId markerId = MarkerId(documentSnapshot.id);
        Marker marker = Marker(
          markerId: markerId,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: name,
          ),
        );
        _markers[markerId] = marker;
      }
    }

    // Print information of responders within 1km radius
    print('Responders within 1km radius:');
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      double latitude = documentSnapshot.data()['latitude'];
      double longitude = documentSnapshot.data()['longitude'];
      String name = documentSnapshot.data()['name'];
      double distance = Geolocator.distanceBetween(positionOfUser.latitude,
          positionOfUser.longitude, latitude, longitude);
      if (distance <= radiusInMeters) {
        nearestFCMToken =
            documentSnapshot.data()['fcmToken']; // Fetching FCM token
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
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('responder').get();

    if (querySnapshot.docs.isEmpty) {
      print('No location data available');
      return;
    }

    // Initialize variables to store the nearest location and its FCM token
    Map<String, dynamic>? nearestLocation;
    double shortestDistance = _radius;

    // Iterate through the location data points, calculating the distance between the user's current location and each location data point
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      double latitude = documentSnapshot.data()['latitude'];
      double longitude = documentSnapshot.data()['longitude'];
      double distance = Geolocator.distanceBetween(positionOfUser.latitude,
          positionOfUser.longitude, latitude, longitude);

      // If the current location data point is closer to the user, replace the nearest location with the current location data point
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestLocation = documentSnapshot.data();
        nearestFCMToken =
            documentSnapshot.data()['fcmToken']; // Fetching FCM token
        nearestUID = documentSnapshot.data()['uid'];
      }
    }

    // If a nearest location is found, add a marker on the map
    if (nearestLocation != null) {
      MarkerId markerId = MarkerId(nearestLocation.toString());
      Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(nearestLocation['latitude'], nearestLocation['longitude']),
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
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('responder').get();

    if (querySnapshot.docs.isEmpty) {
      print('No location data available');
      return;
    }

    // Initialize variables to store the nearest location and its FCM token
    Map<String, dynamic>? nearestLocation;
    double shortestDistance = _radius;

    // Iterate through the location data points, calculating the distance between the user's current location and each location data point
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      double latitude = documentSnapshot.data()['latitude'];
      double longitude = documentSnapshot.data()['longitude'];
      double distance = Geolocator.distanceBetween(positionOfUser.latitude,
          positionOfUser.longitude, latitude, longitude);

      // If the current location data point is closer to the user, replace the nearest location with the current location data point
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestLocation = documentSnapshot.data();
        nearestFCMToken =
            documentSnapshot.data()['fcmToken']; // Fetching FCM token
        nearestUID = documentSnapshot.data()['uid'];
      }
      // Print the FCM token of the nearest responder
      print('FCM token of nearest responder: $nearestFCMToken');
      print('uid of the nearest responder:$nearestUID');
      sendNotification();
      sendNotificationAdmin();
      saveUidToResponder();
      executeGetAndSaveUid();
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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'status': 'offline',
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
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
      userData?['concerns'] =
          selectedConcerns.isNotEmpty ? selectedConcerns : FieldValue.delete();

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

  void startLocationUpdates() {
    // Start getting continuous updates of user's position
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _positionStreamController.add(position);
    });
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
    _getLocationDataOf1kmRadius();
  }

  void goToProfileView() {
    _navigationService.navigateToProfileViewView();
  }

  void onPageChanged(int index) {
    currentPageIndex = index;
    rebuildUi();
   _getLocationDataOf1kmRadius();
    storeCurrentLocationOfUser();

    if (index == 1) {
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
    _positionStreamController.close();
    super.dispose();
  }

  void incrementCounter() {}

  void showBottomSheet() {}
}
